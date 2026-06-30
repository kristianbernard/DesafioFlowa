using System.Diagnostics;
using QuickFix;
using QuickFix.Fields;
using OrderAccumulator.Models;
using FIX44 = QuickFix.FIX44;

namespace OrderAccumulator;

public class FixAcceptorApp : MessageCracker, IApplication
{
    private readonly ExposureCalculator _calculator;

    public FixAcceptorApp(ExposureCalculator calculator)
    {
        _calculator = calculator;
    }

    public void OnMessage(FIX44.NewOrderSingle order, SessionID sessionID)
    {
        var clOrdId = order.ClOrdID.getValue();
        var symbol = order.Symbol.getValue();
        var side = order.Side.getValue();
        var quantity = (int)order.OrderQty.getValue();
        var price = order.Price.getValue();

        var recvMsg = $"[OrderAccumulator] RECEBIDA NewOrderSingle: ClOrdID={clOrdId}, Symbol={symbol}, Side={side}, Qty={quantity}, Price={price}";
        Console.WriteLine(recvMsg);
        Debug.WriteLine(recvMsg);

        var (accepted, exposure) = _calculator.TryAcceptOrder(symbol, side, price, quantity);

        var execType = accepted ? ExecType.NEW : ExecType.REJECTED;
        var ordStatus = accepted ? OrdStatus.NEW : OrdStatus.REJECTED;

        var report = new FIX44.ExecutionReport(
            new OrderID(Guid.NewGuid().ToString()),
            new ExecID(Guid.NewGuid().ToString()),
            new ExecType(execType),
            new OrdStatus(ordStatus),
            new Symbol(symbol),
            new Side(side),
            new LeavesQty(accepted ? quantity : 0),
            new CumQty(accepted ? quantity : 0),
            new AvgPx(accepted ? price : 0)
        );

        report.ClOrdID = new ClOrdID(clOrdId);
        report.Price = new Price(price);
        report.OrderQty = new OrderQty(quantity);

        if (!accepted)
        {
            report.Text = new Text(
                $"REJEITADA: exposição excederia o limite de R$ 100.000.000,00. Symbol={symbol}, Exposição atual={exposure:N2}");
        }

        Session.SendToTarget(report, sessionID);

        var status = accepted ? "ACEITA" : "REJEITADA";
        var sentMsg = $"[OrderAccumulator] ENVIADA ExecutionReport: {status}, ClOrdID={clOrdId}, Exposição={exposure:N2}";
        Console.WriteLine(sentMsg);
        Debug.WriteLine(sentMsg);
    }

    public void FromApp(QuickFix.Message msg, SessionID sessionID)
    {
        Crack(msg, sessionID);
    }

    public void OnCreate(SessionID sessionID)
    {
        var msg = $"[OrderAccumulator] Sessão criada: {sessionID}";
        Console.WriteLine(msg);
        Debug.WriteLine(msg);
    }

    public void OnLogon(SessionID sessionID)
    {
        var msg = $"[OrderAccumulator] Logon: {sessionID}";
        Console.WriteLine(msg);
        Debug.WriteLine(msg);
    }

    public void OnLogout(SessionID sessionID)
    {
        var msg = $"[OrderAccumulator] Logout: {sessionID}";
        Console.WriteLine(msg);
        Debug.WriteLine(msg);
    }

    public void FromAdmin(QuickFix.Message msg, SessionID sessionID) { }
    public void ToAdmin(QuickFix.Message msg, SessionID sessionID) { }
    public void ToApp(QuickFix.Message msg, SessionID sessionID) { }
}
