@echo off
:: Verifica se o script está sendo executado como administrador
:: Tenta acessar uma pasta do sistema que requer permissão de administrador
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Solicitando permissões de administrador...
    :: Relança o script como administrador
    powershell -Command "Start-Process cmd -ArgumentList '/c %~fnx0' -Verb RunAs"
    exit /b
)

:: Executa o script PowerShell como administrador
PowerShell -ExecutionPolicy Bypass -File "%~dp0instalador.ps1"
pause
