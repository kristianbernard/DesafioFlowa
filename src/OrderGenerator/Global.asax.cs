using System.Diagnostics;
using System.Web;
using OrderGenerator.Services;

namespace OrderGenerator;

public class Global : HttpApplication
{
    private static FixInitiatorService? _fixService;

    public static FixInitiatorService? FixService => _fixService;

    protected void Application_Start(object sender, EventArgs e)
    {
        var configPath = Server.MapPath("~/fix_generator.cfg");
        Debug.WriteLine($"[OrderGenerator] Application_Start: configPath={configPath}");
        _fixService = new FixInitiatorService(configPath);
        _fixService.Start();
        Debug.WriteLine("[OrderGenerator] FixInitiatorService iniciado, aguardando conexão...");
    }

    protected void Application_End(object sender, EventArgs e)
    {
        _fixService?.Dispose();
    }
}
