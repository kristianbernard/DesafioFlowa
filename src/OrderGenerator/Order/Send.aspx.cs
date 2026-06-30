using System.Globalization;
using OrderGenerator.Models;
using OrderGenerator.Services;

namespace OrderGenerator.Order;

public partial class Send : System.Web.UI.Page
{
    public string? ErrorMessage { get; set; }

    protected async void Page_Load(object sender, EventArgs e)
    {
        if (Request.HttpMethod != "POST")
            return;

        var symbol = Request.Form["symbol"]?.Trim() ?? "";
        var sideStr = Request.Form["side"] ?? "";
        var qtyStr = Request.Form["quantity"]?.Trim() ?? "";
        var priceStr = Request.Form["price"]?.Trim() ?? "";

        if (string.IsNullOrEmpty(symbol) || !Array.Exists(OrderViewModel.AvailableSymbols, s => s == symbol))
        {
            ErrorMessage = "Selecione um símbolo válido.";
            return;
        }

        if (sideStr != "1" && sideStr != "2")
        {
            ErrorMessage = "Selecione um lado (Compra ou Venda).";
            return;
        }

        if (!int.TryParse(qtyStr, out var quantity) || quantity < 1 || quantity > 99999)
        {
            ErrorMessage = "Quantidade deve estar entre 1 e 99.999.";
            return;
        }

        if (!decimal.TryParse(priceStr, NumberStyles.Any, CultureInfo.InvariantCulture, out var price) || price < 0.01m || price > 999.99m || Math.Round(price, 2) != price)
        {
            ErrorMessage = "Preço deve estar entre 0,01 e 999,99.";
            return;
        }

        var side = sideStr == "1" ? '1' : '2';

        var service = Global.FixService;
        if (service == null)
        {
            ErrorMessage = "Serviço FIX não inicializado. Aguarde e tente novamente.";
            return;
        }

        try
        {
            var result = await service.SendOrderAsync(symbol, side, quantity, price);
            Session["LastResult"] = result;
            Response.Redirect("Result.aspx", false);
            Context.ApplicationInstance.CompleteRequest();
        }
        catch (Exception ex)
        {
            ErrorMessage = $"Erro ao enviar ordem: {ex.Message}";
        }
    }
}
