using QuickFix;
using OrderAccumulator;
using OrderAccumulator.Services;

var configPath = args.Length > 0 ? args[0] : Path.Combine(AppContext.BaseDirectory, "fix_accumulator.cfg");

if (!File.Exists(configPath))
{
    configPath = "fix_accumulator.cfg";
}

if (!File.Exists(configPath))
{
    Console.Error.WriteLine($"Arquivo de configuração não encontrado: {configPath}");
    return 1;
}

var baseDir = Path.GetDirectoryName(configPath) ?? AppContext.BaseDirectory;
var storeDir = Path.Combine(baseDir, "store");
var logDir = Path.Combine(baseDir, "log");
Directory.CreateDirectory(storeDir);
Directory.CreateDirectory(logDir);

var configText = File.ReadAllText(configPath)
    .Replace("FileStorePath=store", $"FileStorePath={storeDir}")
    .Replace("FileLogPath=log", $"FileLogPath={logDir}");
var fixedCfg = Path.Combine(baseDir, "fix_accumulator_runtime.cfg");
File.WriteAllText(fixedCfg, configText);

var settings = new SessionSettings(fixedCfg);

var calculator = new ExposureCalculator();
var application = new FixAcceptorApp(calculator);
var storeFactory = new FileStoreFactory(settings);
var logFactory = new FileLogFactory(settings);
var acceptor = new ThreadedSocketAcceptor(application, storeFactory, settings, logFactory);

Console.WriteLine("==============================================");
Console.WriteLine("  OrderAccumulator - Acceptor FIX");
Console.WriteLine("  Escutando na porta 5001");
Console.WriteLine("  Limite de exposição: R$ 100.000.000,00 por símbolo");
Console.WriteLine("==============================================");

acceptor.Start();

var stopEvent = new ManualResetEvent(false);
Console.CancelKeyPress += (_, e) =>
{
    e.Cancel = true;
    Console.WriteLine("\nEncerrando...");
    stopEvent.Set();
};

stopEvent.WaitOne();

acceptor.Stop();
Console.WriteLine("OrderAccumulator encerrado.");
return 0;
