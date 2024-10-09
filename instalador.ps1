# Diretório temporário
try {
    # Tenta definir a política de execução para Unrestricted
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

    # Exibe uma mensagem de sucesso
    Write-Host "A politica de execucao foi atualizada com sucesso."
}
catch {
    Write-Host "Aviso: Politica Alterada com sucesso:"
}
finally {
    # Verifica a política de execução efetiva e lista todas as políticas

    # Mostra a lista completa das políticas de execução configuradas
    Get-ExecutionPolicy -List
}


$LocalTempDir = $env:TEMP

# Instalação do Chrome
$ChromeInstaller = "ChromeInstaller.exe"
(new-object System.Net.WebClient).DownloadFile('http://dl.google.com/chrome/install/375.126/chrome_installer.exe', "$LocalTempDir\$ChromeInstaller")
& "$LocalTempDir\$ChromeInstaller" /silent /install
$Process2Monitor = "ChromeInstaller"

# Monitora o processo de instalação do Chrome
Do {
    $ProcessesFound = Get-Process | ?{$Process2Monitor -contains $_.Name} | Select-Object -ExpandProperty Name
    If ($ProcessesFound) {
        "Still running: $($ProcessesFound -join ', ')" | Write-Host
        Start-Sleep -Seconds 2
    } else {
        rm "$LocalTempDir\$ChromeInstaller" -ErrorAction SilentlyContinue -Verbose
    }
} Until (!$ProcessesFound)

# Instalação do Firefox
$FirefoxInstaller = "FirefoxInstaller.exe"
(new-object System.Net.WebClient).DownloadFile('https://download.mozilla.org/?product=firefox-latest-ssl&os=win64&lang=en-US', "$LocalTempDir\$FirefoxInstaller")
& "$LocalTempDir\$FirefoxInstaller" -ms
$Process2Monitor = "FirefoxInstaller"

# Monitora o processo de instalação do Firefox
Do {
    $ProcessesFound = Get-Process | ?{$Process2Monitor -contains $_.Name} | Select-Object -ExpandProperty Name
    If ($ProcessesFound) {
        "Still running: $($ProcessesFound -join ', ')" | Write-Host
        Start-Sleep -Seconds 2
    } else {
        rm "$LocalTempDir\$FirefoxInstaller" -ErrorAction SilentlyContinue -Verbose
    }
} Until (!$ProcessesFound)


# Instalação do UltraVNC via Winget
Write-Host "Instalando o UltraVNC..."
winget install uvncbvba.UltraVnc

Write-Host "Instalação concluída com sucesso!"

Set-ExecutionPolicy Restricted -Scope CurrentUser