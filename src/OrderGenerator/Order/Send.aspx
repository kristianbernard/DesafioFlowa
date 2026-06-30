<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Send.aspx.cs" Inherits="OrderGenerator.Order.Send" Async="true" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head runat="server">
    <meta charset="utf-8" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Nova Ordem - OrderGenerator</title>
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
        .form-label {
            font-weight: 600;
            font-size: 0.875rem;
            color: #495057;
            margin-bottom: 0.35rem;
            display: flex;
            align-items: center;
            gap: 0.35rem;
        }
        .form-label i {
            color: #6c757d;
            font-size: 0.8rem;
        }
        .form-control, .form-select {
            height: 48px;
            border: 1px solid #ced4da;
            border-radius: 8px;
            padding: 0.5rem 0.875rem;
            font-size: 0.9375rem;
            color: #212529;
            transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
        }
        .form-control:focus, .form-select:focus {
            border-color: #86b7fe;
            box-shadow: 0 0 0 0.25rem rgba(13,110,253,0.15);
            color: #212529;
        }
        .form-control::placeholder { color: #adb5bd; }
        .form-select { background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3e%3cpath fill='none' stroke='%23495057' stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M2 5l6 6 6-6'/%3e%3c/svg%3e"); }
        .form-select option { color: #212529; }
        .segmented-control {
            display: flex;
            height: 48px;
            border: 1px solid #ced4da;
            border-radius: 8px;
            overflow: hidden;
            background: #fff;
            transition: border-color 0.15s ease-in-out;
        }
        .segmented-control:focus-within {
            border-color: #86b7fe;
            box-shadow: 0 0 0 0.25rem rgba(13,110,253,0.15);
        }
        .segmented-option {
            flex: 1;
            position: relative;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            user-select: none;
            transition: background 0.15s ease-in-out, color 0.15s ease-in-out;
            font-size: 0.9375rem;
            font-weight: 500;
            color: #6c757d;
            background: #fff;
            border-right: 1px solid #ced4da;
        }
        .segmented-option:last-child { border-right: none; }
        .segmented-option input {
            position: absolute;
            opacity: 0;
            width: 0;
            height: 0;
            pointer-events: none;
        }
        .segmented-option input:checked + .segmented-label {
            background: #0d6efd;
            color: #fff;
        }
        .segmented-option input:checked + .segmented-label i {
            opacity: 1;
        }
        .segmented-label {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            width: 100%;
            height: 100%;
            padding: 0 0.5rem;
            cursor: pointer;
            transition: background 0.15s ease-in-out, color 0.15s ease-in-out;
            background: #fff;
            color: #6c757d;
        }
        .segmented-label i {
            font-size: 1rem;
            opacity: 0;
            transition: opacity 0.15s ease-in-out;
        }
        .segmented-label:hover {
            background: #f0f4ff;
            color: #0d6efd;
        }
        .btn-primary {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            height: 44px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 1rem;
            background: #0d6efd;
            border: none;
            padding: 0 1.5rem;
            transition: background 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
            cursor: pointer;
            color: #fff !important;
        }
        .btn-primary:hover { background: #0b5ed7; color: #fff !important; }
        .btn-primary:focus { box-shadow: 0 0 0 0.25rem rgba(13,110,253,0.3); color: #fff !important; }
        .btn-primary:active { color: #fff !important; }
        .btn-primary:disabled { background: #6ea8fe; cursor: not-allowed; color: #fff !important; }
        .btn-primary i {
            width: 16px;
            height: 16px;
            font-size: 16px;
            flex-shrink: 0;
            color: #fff !important;
        }
        .limit-info {
            background: #f8f9fa;
            border: 1px solid #e9ecef;
            border-radius: 8px;
            padding: 0.75rem 1rem;
            font-size: 0.875rem;
            color: #6c757d;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        .limit-info i { color: #0d6efd; font-size: 1rem; }
        .limit-info strong { color: #212529; }
        .alert-danger {
            background: #fef2f2;
            border: 1px solid #fecaca;
            color: #dc2626;
            border-radius: 8px;
            font-size: 0.875rem;
            display: flex;
            align-items: flex-start;
            gap: 0.5rem;
        }
        .alert-danger i { font-size: 1rem; margin-top: 0.1rem; }
        .last-result-link {
            color: #6c757d;
            text-decoration: none;
            font-size: 0.875rem;
            font-weight: 500;
            transition: color 0.15s;
        }
        .last-result-link:hover { color: #0d6efd; }
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
            .segmented-control { height: 44px; }
            .segmented-option { font-size: 0.875rem; }
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
                    <a class="nav-link active" href="Send.aspx">
                        <i class="bi bi-plus-circle me-1"></i>Nova Ordem
                    </a>
                </li>
            </ul>
        </div>
    </nav>

    <div class="container container-narrow py-4">
        <div class="page-header text-center">
            <h1 class="page-title">Nova Ordem</h1>
        </div>

        <div class="main-card">
            <form method="post" action="Send.aspx" id="orderForm">
                <div class="mb-3">
                    <label for="symbol" class="form-label">
                        <i class="bi bi-building"></i>Simbolo
                    </label>
                    <select name="symbol" id="symbol" class="form-select" required>
                        <option value="">Selecione um ativo</option>
                        <option value="PETR4">PETR4 - Petrobras PN</option>
                        <option value="VALE3">VALE3 - Vale ON</option>
                        <option value="VIIA4">VIIA4 - Via PN</option>
                    </select>
                </div>

                <div class="mb-3">
                    <label class="form-label">
                        <i class="bi bi-arrow-left-right"></i>Lado
                    </label>
                    <div class="segmented-control" role="radiogroup" aria-label="Lado da ordem">
                        <label class="segmented-option">
                            <input type="radio" name="side" value="1" checked />
                            <span class="segmented-label">
                                <i class="bi bi-check-lg"></i>
                                <span>Compra</span>
                            </span>
                        </label>
                        <label class="segmented-option">
                            <input type="radio" name="side" value="2" />
                            <span class="segmented-label">
                                <i class="bi bi-check-lg"></i>
                                <span>Venda</span>
                            </span>
                        </label>
                    </div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-6 mb-3 mb-md-0">
                        <label for="quantity" class="form-label">
                            <i class="bi bi-hash"></i>Quantidade
                        </label>
                        <input name="quantity" id="quantity" class="form-control" type="number" min="1" max="99999" placeholder="Ex: 100" required />
                    </div>
                    <div class="col-md-6">
                        <label for="price" class="form-label">
                            <i class="bi bi-currency-dollar"></i>Preco (R$)
                        </label>
                        <input name="price" id="price" class="form-control" type="text" inputmode="decimal" placeholder="Ex: 25,50" autocomplete="off" required />
                    </div>
                </div>

                <% if (!string.IsNullOrEmpty(ErrorMessage)) { %>
                    <div class="alert alert-danger mb-3" role="alert">
                        <i class="bi bi-exclamation-triangle-fill flex-shrink-0"></i>
                        <span><%= ErrorMessage %></span>
                    </div>
                <% } %>

                <div class="limit-info mb-3">
                    <i class="bi bi-shield-check flex-shrink-0"></i>
                    <span>Limite de exposicao: <strong>R$ 100.000.000,00</strong> por simbolo</span>
                </div>

                <button type="submit" class="btn btn-primary w-100" id="btnSubmit">
                    <span id="btnText"><i class="bi bi-send"></i>Enviar Ordem (NewOrderSingle)</span>
                    <span id="btnSpinner" class="spinner-border spinner-border-sm d-none" role="status"></span>
                </button>
            </form>
        </div>

        <div class="text-center mt-4">
            <a href="Result.aspx" class="last-result-link">
                <i class="bi bi-clock-history me-1"></i>Ultimo resultado
            </a>
        </div>
    </div>

    <footer>
        OrderGenerator &copy; 2026 &mdash; Desafio Flowa &bull; FIX 4.4
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        (function() {
            var priceEl = document.getElementById('price');
            var form = document.getElementById('orderForm');

            function formatPrice(value) {
                var raw = value.replace(/\D/g, '');
                if (raw.length === 0) return '';
                while (raw.length < 3) raw = '0' + raw;
                var dec = raw.slice(-2);
                var int = raw.slice(0, -2).replace(/^0+/, '') || '0';
                int = int.replace(/\B(?=(\d{3})+(?!\d))/g, '.');
                return int + ',' + dec;
            }

            function maskPrice(e) {
                var pos = e.target.selectionStart;
                var prevLen = e.target.value.length;
                var formatted = formatPrice(e.target.value);
                if (formatted !== e.target.value) {
                    e.target.value = formatted;
                    var newLen = formatted.length;
                    var delta = newLen - prevLen;
                    if (pos + delta > 0 && pos + delta <= newLen) {
                        e.target.setSelectionRange(pos + delta, pos + delta);
                    }
                }
            }

            if (priceEl) {
                var initial = formatPrice(priceEl.value);
                if (initial) priceEl.value = initial;
                priceEl.addEventListener('input', maskPrice);
                priceEl.addEventListener('keydown', function(e) {
                    if (e.key === 'Enter') return;
                    var val = this.value.replace(/\D/g, '');
                    var len = val.length;
                    if (e.key === 'Backspace' || e.key === 'Delete') {
                        if (len <= 1) { this.value = ''; return; }
                    }
                });
            }

            if (form) {
                form.addEventListener('submit', function() {
                    if (priceEl) {
                        var cleaned = priceEl.value.replace(/\./g, '').replace(',', '.');
                        priceEl.value = cleaned;
                    }
                    var btn = document.getElementById('btnSubmit');
                    var text = document.getElementById('btnText');
                    var spin = document.getElementById('btnSpinner');
                    btn.disabled = true;
                    text.classList.add('d-none');
                    spin.classList.remove('d-none');
                });
            }
        })();
    </script>
</body>
</html>
