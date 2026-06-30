using OrderGenerator.Models;

namespace OrderGenerator.Order;

public partial class Result : System.Web.UI.Page
{
    public ExecutionReportResult? OrderResult { get; private set; }

    protected void Page_Load(object sender, EventArgs e)
    {
        OrderResult = Session["LastResult"] as ExecutionReportResult;
    }
}
