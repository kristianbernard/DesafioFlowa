<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Result.aspx.cs" Inherits="OrderGenerator.Order.Result" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head runat="server">
    <meta charset="utf-8" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Resultado - OrderGenerator</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet" />
    <style>
        * { box-sizing: border-box; }
        body {
            background: #fff;
            min-height: 100vh;
            font-family: 'Inter', 'Segoe UI', Roboto, system-ui, sans-serif;
            color: #212529;
        }
        .navbar {
            background: #fff !important;
            border-bottom: 1px solid #e9ecef !important;
            padding: 0.75rem 0;
        }
        .navbar-brand {
            font-weight: 700;
            color: #0d6efd !important;
            font-size: 1.25rem;
            letter-spacing: -0.3px;
        }
        .navbar-brand i { margin-right: 6px; }
        .nav-link {
            color: #6c757d !important;
            font-weight: 500;
            font-size: 0.9rem;
            padding: 0.5rem 1rem !important;
            border-radius: 6px;
            transition: background 0.15s;
        }
        .nav-link:hover { background: #f0f4ff; color: #0d6efd !important; }
        .page-header { margin-bottom: 1.5rem; }
        .page-title {
            font-weight: 700;
            font-size: 2rem;
            color: #212529;
            margin: 0 0 0.25rem;
            letter-spacing: -0.5px;
        }
        .page-subtitle {
            font-size: 1rem;
            color: #6c757d;
            margin: 0;
        }
        .main-card {
            background: #fff;
            border: 1px solid #e9ecef;
            border-radius: 12px;
            padding: 2rem 2.25rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.06), 0 1px 2px rgba(0,0,0,0.04);
        }
        .status-card {
            border-radius: 12px;
            padding: 1.75rem 2rem;
            text-align: center;
            margin-bottom: 1.5rem;
        }
        .status-accepted {
            background: #f0fdf4;
            border: 1px solid #bbf7d0;
        }
        .status-rejected {
            background: #fef2f2;
            border: 1px solid #fecaca;
        }
        .status-icon { font-size: 2.5rem; }
        .status-title {
            font-weight: 700;
            font-size: 1.5rem;
            margin: 0.5rem 0 0.25rem;
            letter-spacing: -0.3px;
        }
        .status-subtitle {
            font-size: 0.9rem;
            color: #6c757d;
        }
        .detail-table { margin-bottom: 0; }
        .detail-table th {
            color: #6c757d;
            font-weight: 600;
            font-size: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 0.4px;
            border: none;
            padding: 0.7rem 0.5rem;
            width: 38%;
        }
        .detail-table td {
            color: #212529;
            font-weight: 600;
            font-size: 0.95rem;
            border: none;
            padding: 0.7rem 0.5rem;
        }
        .detail-table tr {
            border-bottom: 1px solid #f1f3f5;
        }
        .detail-table tr:last-child { border-bottom: none; }
        .detail-card {
            border: 1px solid #e9ecef;
            border-radius: 8px;
            padding: 0.25rem 1.25rem;
            background: #fafbfc;
        }
        .value-positive { color: #16a34a; }
        .value-negative { color: #dc2626; }
        .value-total {
            color: #0d6efd;
            font-weight: 700;
            font-size: 1.05rem;
        }
        .empty-state {
            text-align: center;
            padding: 2.5rem 1rem;
        }
        .empty-state i {
            font-size: 3.5rem;
            color: #dee2e6;
            margin-bottom: 0.75rem;
        }
        .empty-state h3 {
            color: #6c757d;
            font-weight: 600;
            font-size: 1.25rem;
        }
        .btn-primary,
        .btn-primary:link,
        .btn-primary:visited,
        .btn-primary:hover,
        .btn-primary:focus,
        .btn-primary:active {
             height: 44px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 1rem;
            background: #0d6efd;
            border: none;
            padding: 0 1.5rem;
            transition: background 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            cursor: pointer;
            color: #fff !important;
        }
        .btn-primary:hover { background: #0b5ed7; }
        .btn-primary:focus { box-shadow: 0 0 0 0.25rem rgba(13,110,253,0.3); }

        .btn-primary i,
        .btn-primary span,
        .btn-primary svg {
            color: #fff !important;
            fill: currentColor;
        }
        .btn-primary i {
            width: 16px;
            height: 16px;
            font-size: 16px;
            flex-shrink: 0;
        }
        .btn-outline-secondary {
            height: 44px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 0.95rem;
            border: 1.5px solid #ced4da;
            color: #495057;
            padding: 0 1.5rem;
            transition: all 0.15s ease-in-out;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        .btn-outline-secondary i {
            width: 16px;
            height: 16px;
            font-size: 16px;
            flex-shrink: 0;
        }
        .btn-outline-secondary:hover {
            border-color: #0d6efd;
            color: #0d6efd;
            background: #f0f4ff;
        }
        .action-bar {
            display: flex;
            gap: 0.75rem;
            justify-content: center;
            flex-wrap: wrap;
            margin-top: 1.5rem;
        }
        .reject-reason {
            background: #fef2f2;
            border: 1px solid #fecaca;
            border-radius: 8px;
            padding: 0.6rem 1rem;
            color: #dc2626;
            font-size: 0.9rem;
            display: flex;
            align-items: flex-start;
            gap: 0.5rem;
        }
        .reject-reason i { font-size: 1rem; margin-top: 0.1rem; }
        footer {
            color: #adb5bd;
            font-size: 0.8rem;
            text-align: center;
            padding: 2rem 1rem;
        }
        .container-narrow { max-width: 700px; }
        @media (max-width: 576px) {
            .main-card { padding: 1.25rem; }
            .page-title { font-size: 1.5rem; }
            .action-bar { flex-direction: column; align-items: stretch; }
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <div class="container container-narrow">
            <a class="navbar-brand" href="Send.aspx">
                <i class="bi bi-graph-up-arrow"></i>OrderGenerator
            </a>
            <ul class="navbar-nav d-flex flex-row">
                <li class="nav-item">
                    <a class="nav-link" href="Send.aspx">
                        <i class="bi bi-plus-circle me-1"></i>Nova Ordem
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="Result.aspx">
                        <i class="bi bi-clipboard-check me-1"></i>Resultado
                    </a>
                </li>
            </ul>
        </div>
    </nav>

    <div class="container container-narrow py-4">
        <div class="page-header text-center">
            <h1 class="page-title">Resultado da Ordem</h1>
        </div>

        <div class="main-card">
            <% if (OrderResult == null) { %>
                <div class="empty-state">
                    <i class="bi bi-inbox"></i>
                    <h3>Nenhum resultado disponivel</h3>
                    <p class="text-muted mb-3">Envie uma ordem para ver o resultado aqui.</p>
                    <a href="Send.aspx" class="btn-primary">
                        <i class="bi bi-send"></i>Nova Ordem
                    </a>
                </div>
            <% } else { %>
                <div class="status-card <%= OrderResult.Accepted ? "status-accepted" : "status-rejected" %>">
                    <div class="status-icon">
                        <i class="bi <%= OrderResult.Accepted ? "bi-check-circle-fill" : "bi-x-circle-fill" %>"
                           style="color:<%= OrderResult.Accepted ? "#16a34a" : "#dc2626" %>">
                        </i>
                    </div>
                    <div class="status-title" style="color:<%= OrderResult.Accepted ? "#16a34a" : "#dc2626" %>">
                        <%= OrderResult.Accepted ? "ORDEM ACEITA" : "ORDEM REJEITADA" %>
                    </div>
                    <div class="status-subtitle">
                        <% if (OrderResult.Accepted) { %>
                            <i class="bi bi-check2 me-1"></i>A ordem foi processada e a exposicao foi atualizada.
                        <% } else { %>
                            <i class="bi bi-x-lg me-1"></i>A ordem foi rejeitada pelo OrderAccumulator.
                        <% } %>
                    </div>
                </div>

                <div class="detail-card">
                    <table class="detail-table">
                        <tbody>
                            <tr>
                                <th><i class="bi bi-coin me-2"></i>Simbolo</th>
                                <td><%= OrderResult.Symbol %></td>
                            </tr>
                            <tr>
                                <th><i class="bi bi-arrow-left-right me-2"></i>Lado</th>
                                <td class="<%= OrderResult.Side == '1' ? "value-positive" : "value-negative" %>">
                                    <i class="bi <%= OrderResult.Side == '1' ? "bi-arrow-up-short" : "bi-arrow-down-short" %> me-1"></i>
                                    <%= OrderResult.SideDisplay %>
                                </td>
                            </tr>
                            <tr>
                                <th><i class="bi bi-hash me-2"></i>Quantidade</th>
                                <td><%= OrderResult.Quantity.ToString("N0") %> acoes</td>
                            </tr>
                            <tr>
                                <th><i class="bi bi-cash me-2"></i>Preco</th>
                                <td>R$ <%= OrderResult.Price.ToString("N2") %></td>
                            </tr>
                            <tr>
                                <th><i class="bi bi-calculator me-2"></i>Total</th>
                                <td class="value-total">
                                    R$ <%= (OrderResult.Quantity * OrderResult.Price).ToString("N2") %>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <% if (!string.IsNullOrEmpty(OrderResult.RejectReason)) { %>
                    <div class="reject-reason mt-3">
                        <i class="bi bi-exclamation-triangle-fill flex-shrink-0"></i>
                        <span><%= OrderResult.RejectReason %></span>
                    </div>
                <% } %>

                <div class="action-bar">
                    <a href="Send.aspx" class="btn-primary">
                        <i class="bi bi-plus-circle"></i>Nova Ordem
                    </a>
                    <a href="Send.aspx" class="btn-outline-secondary">
                        <i class="bi bi-arrow-left"></i>Voltar
                    </a>
                </div>
            <% } %>
        </div>
    </div>

    <footer>
        OrderGenerator &copy; 2026 &mdash; Desafio Flowa &bull; FIX 4.4
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
