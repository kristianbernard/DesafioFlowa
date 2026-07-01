# DesafioFlowa

Solução com duas aplicações C# que se comunicam via protocolo FIX 4.4 (QuickFix/n) para envio de ordens e cálculo de exposição financeira por símbolo.

## Tecnologias

- **.NET Framework 4.8.1** (OrderGenerator: Web Forms; OrderAccumulator: Console)
- **QuickFIX/n v1.10.0** (QuickFixn.Core + QuickFixn.FIX4.4)
- **FIX Protocol 4.4**
- **Bootstrap 5.3.3** + **Bootstrap Icons** (via CDN)
- **IIS Express** (servidor web local)

## Estrutura do Projeto

```
DesafioFlowa/
├── run.ps1                              # Script de execução (2 passos)
├── DesafioFlowa.sln
├── src/
│   ├── OrderGenerator/                  # Web Forms (FIX Initiator)
│   │   ├── OrderGenerator.csproj
│   │   ├── Web.config
│   │   ├── Global.asax / Global.asax.cs
│   │   ├── fix_generator.cfg
│   │   ├── Properties/
│   │   ├── Models/
│   │   │   └── OrderViewModel.cs        # ViewModel do formulário
│   │   ├── Contracts/
│   │   │   └── ExecutionReportResult.cs # DTO de retorno da ordem
│   │   ├── Services/
│   │   │   └── FixInitiatorService.cs   # Conexão FIX (Initiator)
│   │   └── Order/
│   │       ├── Send.aspx / .cs          # Formulário de envio
│   │       └── Result.aspx / .cs        # Resultado da ordem
│   └── OrderAccumulator/                # Console App (FIX Acceptor)
│       ├── OrderAccumulator.csproj
│       ├── Program.cs
│       ├── FixAcceptorApp.cs
│       ├── fix_accumulator.cfg
│       └── Services/
│           └── ExposureCalculator.cs    # Cálculo de exposição
├── .gitignore
└── README.md
```

## Como Executar

### Pré-requisitos

- [.NET SDK 10.0+](https://dotnet.microsoft.com/download) (compilação)
- [Visual Studio 2022](https://visualstudio.microsoft.com/) (opcional, para F5)
- IIS Express (instalado com VS 2022 em `C:\Program Files (x86)\IIS Express\`)

### Passos (via script)

Execute o script na raiz do projeto:

```powershell
.\run.ps1
```

O script:
1. Compila ambos os projetos com `dotnet build`
2. Inicia o **OrderAccumulator** (acceptor FIX na porta 5001)
3. Inicia o **IIS Express** servindo o OrderGenerator na porta 5000

Acesse http://localhost:5000 no navegador.

### Passos (manual - dois terminais)

**Terminal 1 — OrderAccumulator:**

```powershell
cd src\OrderAccumulator
dotnet run
```

**Terminal 2 — OrderGenerator (via IIS Express):**

```powershell
& "C:\Program Files (x86)\IIS Express\iisexpress.exe" /path:src\OrderGenerator /port:5000
```

Acesse http://localhost:5000.

### Uso

1. Selecione um símbolo (**PETR4**, **VALE3** ou **VIIA4**)
2. Escolha o lado (**Compra** ou **Venda**)
3. Informe a quantidade (1 a 99.999)
4. Informe o preço (0,01 a 999,99, múltiplo de 0,01)
5. Clique em **Enviar Ordem**
6. O resultado (aceita ou rejeitada) será exibido na página de resultado

### Regras de Exposição

- Limite por símbolo: **R$ 100.000.000,00**
- Exposição = Σ(compra preço × quantidade) − Σ(venda preço × quantidade)
- Ordens de compra **aumentam** a exposição
- Ordens de venda **diminuem** a exposição
- Se o valor absoluto ultrapassar o limite, a ordem é **rejeitada** (ExecType=Rejected) e não entra no cálculo
- Ordens dentro do limite são **aceitas** (ExecType=New) e incluídas no cálculo

---

This is a challenge by [Coodesh](https://coodesh.com/)
