using System.Collections.Concurrent;
using System.Diagnostics;
using QuickFix;
using QuickFix.Fields;
using QuickFix.Transport;
using OrderGenerator.Models;
using FIX44 = QuickFix.FIX44;

namespace OrderGenerator.Services;

public class FixInitiatorService : IApplication, IDisposable
{
    private readonly ConcurrentDictionary<string, TaskCompletionSource<ExecutionReportResult>> _pendingOrders = new();
    private readonly string _configPath;
    private SocketInitiator? _initiator;
    private SessionID? _sessionId;

    public FixInitiatorService(string configPath)
    {
        _configPath = configPath;
    }

    public void Start()
    {
        var baseDir = Path.GetDirectoryName(_configPath) ?? AppDomain.CurrentDomain.BaseDirectory;
        var storeDir = Path.Combine(baseDir, "store");
        var logDir = Path.Combine(baseDir, "log");
        Directory.CreateDirectory(storeDir);
        Directory.CreateDirectory(logDir);

        var configText = File.ReadAllText(_configPath)
            .Replace("FileStorePath=store", $"FileStorePath={storeDir}")
            .Replace("FileLogPath=log", $"FileLogPath={logDir}");
        var tempCfg = Path.Combine(baseDir, "fix_generator_runtime.cfg");
        File.WriteAllText(tempCfg, configText);

        var settings = new SessionSettings(tempCfg);
        var storeFactory = new FileStoreFactory(settings);
        var logFactory = new FileLogFactory(settings);
        _initiator = new SocketInitiator(this, storeFactory, settings, logFactory);
        _initiator.Start();
    }

    public async Task<ExecutionReportResult> SendOrderAsync(string symbol, char side, int quantity, decimal price)
    {
        for (var i = 0; i < 100; i++)
        {
            if (_sessionId != null) break;
            await Task.Delay(100);
        }

        if (_sessionId == null)
            throw new InvalidOperationException("Sessão FIX não estabelecida. O OrderAccumulator está rodando na porta 5001?");

        var clOrdId = Guid.NewGuid().ToString("N");
        var tcs = new TaskCompletionSource<ExecutionReportResult>(TaskCreationOptions.RunContinuationsAsynchronously);
        _pendingOrders[clOrdId] = tcs;

        var order = new FIX44.NewOrderSingle(
            new ClOrdID(clOrdId),
            new Symbol(symbol),
            new Side(side),
            new TransactTime(DateTime.UtcNow),
            new OrdType(OrdType.LIMIT)
        )
        {
            OrderQty = new OrderQty(quantity),
            Price = new Price(price)
        };

        var sendMsg = $"[ENVIANDO] ClOrdID={clOrdId}, Symbol={symbol}, Side={side}, Qty={quantity}, Price={price}";
        Console.WriteLine(sendMsg);
        Debug.WriteLine(sendMsg);
        Session.SendToTarget(order, _sessionId);

        using var cts = new CancellationTokenSource(TimeSpan.FromSeconds(30));
        using (cts.Token.Register(() => tcs.TrySetCanceled()))
        {
            try
            {
                return await tcs.Task;
            }
            catch (OperationCanceledException)
            {
                _pendingOrders.TryRemove(clOrdId, out _);
                return new ExecutionReportResult
                {
                    Accepted = false,
                    Symbol = symbol,
                    Side = side,
                    Quantity = quantity,
                    Price = price,
                    RejectReason = "Tempo esgotado: sem resposta do OrderAccumulator em 30 segundos."
                };
            }
        }
    }

    public void FromApp(QuickFix.Message msg, SessionID sessionID)
    {
        if (msg is FIX44.ExecutionReport report)
        {
            var clOrdId = report.ClOrdID.getValue();
            var accepted = report.ExecType.getValue() == ExecType.NEW;
            var symbol = report.Symbol.getValue();
            var side = report.Side.getValue();
            var quantity = report.OrderQty != null ? report.OrderQty.getValue() : 0;
            var price = report.Price != null ? report.Price.getValue() : 0m;

            var recvMsg = $"[RECEBIDA] ClOrdID={clOrdId}, ExecType={(accepted ? "New" : "Rejected")}";
            Console.WriteLine(recvMsg);
            Debug.WriteLine(recvMsg);

            var result = new ExecutionReportResult
            {
                Accepted = accepted,
                Symbol = symbol,
                Side = side,
                Quantity = (int)quantity,
                Price = price,
                RejectReason = accepted ? null : report.Text?.getValue()
            };

            if (_pendingOrders.TryRemove(clOrdId, out var tcs))
                tcs.TrySetResult(result);
        }
    }

    public void OnCreate(SessionID sessionID)
    {
        var msg = $"[FIX] Sessão criada: {sessionID}";
        Console.WriteLine(msg);
        Debug.WriteLine(msg);
    }

    public void OnLogon(SessionID sessionID)
    {
        _sessionId = sessionID;
        var msg = $"[FIX] Conectado: {sessionID}";
        Console.WriteLine(msg);
        Debug.WriteLine(msg);
    }

    public void OnLogout(SessionID sessionID)
    {
        var msg = $"[FIX] Desconectado: {sessionID}";
        Console.WriteLine(msg);
        Debug.WriteLine(msg);
        if (_sessionId == sessionID)
            _sessionId = null;
    }

    public void FromAdmin(QuickFix.Message msg, SessionID sessionID) { }
    public void ToAdmin(QuickFix.Message msg, SessionID sessionID) { }
    public void ToApp(QuickFix.Message msg, SessionID sessionID) { }

    public void Dispose()
    {
        _initiator?.Stop();
    }
}
