using System.ComponentModel.DataAnnotations;

namespace OrderGenerator.Models;

public class OrderViewModel
{
    [Required(ErrorMessage = "Selecione um símbolo")]
    public string Symbol { get; set; } = "";

    [Required(ErrorMessage = "Selecione um lado")]
    public char Side { get; set; }

    [Required(ErrorMessage = "Informe a quantidade")]
    [Range(1, 99999, ErrorMessage = "Quantidade deve estar entre 1 e 99.999")]
    public int Quantity { get; set; }

    [Required(ErrorMessage = "Informe o preço")]
    [Range(0.01, 999.99, ErrorMessage = "Preço deve estar entre 0,01 e 999,99")]
    public decimal Price { get; set; }

    public static readonly string[] AvailableSymbols = ["PETR4", "VALE3", "VIIA4"];
}
