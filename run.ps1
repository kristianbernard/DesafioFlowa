$root = $PSScriptRoot

Write-Host "=== Compilando projetos ===" -ForegroundColor Cyan
dotnet build "$root\DesafioFlowa.sln" -q
if ($LASTEXITCODE -ne 0) { Write-Host "FALHA NA COMPILACAO" -ForegroundColor Red; exit 1 }

Write-Host "OK" -ForegroundColor Green
Write-Host ""

Write-Host "========== INSTRUCOES ==========" -ForegroundColor Yellow
Write-Host "1. Abra um SEGUNDO terminal (PowerShell)" -ForegroundColor White
Write-Host "2. Neste terminal (1), rode:" -ForegroundColor White
Write-Host "   dotnet run --project src\OrderAccumulator" -ForegroundColor Cyan
Write-Host ""
Write-Host "3. No segundo terminal (2), rode:" -ForegroundColor White
Write-Host "   & 'C:\Program Files (x86)\IIS Express\iisexpress.exe' /path:$root\src\OrderGenerator /port:5000" -ForegroundColor Cyan
Write-Host ""
Write-Host "4. Acesse no navegador:" -ForegroundColor White
Write-Host "   http://localhost:5000/Order/Send.aspx" -ForegroundColor Green
Write-Host "================================" -ForegroundColor Yellow

Start-Process powershell -ArgumentList "-NoExit", "cd '$root'; dotnet run --project src\OrderAccumulator"
Write-Host "`nAguardando OrderAccumulator iniciar..." -ForegroundColor Gray
Start-Sleep 3

Write-Host "Iniciando IIS Express..." -ForegroundColor Gray
& "C:\Program Files (x86)\IIS Express\iisexpress.exe" /path:"$root\src\OrderGenerator" /port:5000
