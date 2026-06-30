namespace OrderGenerator.Models;

public class ExecutionReportResult
{
    public bool Accepted { get; set; }
    public string Symbol { get; set; } = "";
    public char Side { get; set; }
    public int Quantity { get; set; }
    public decimal Price { get; set; }
    public string? RejectReason { get; set; }
    public string SideDisplay => Side == '1' ? "Compra" : "Venda";
}
