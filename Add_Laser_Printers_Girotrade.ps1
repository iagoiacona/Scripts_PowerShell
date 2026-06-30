# ================================
# Criação das Credenciais
# ================================

cmdkey /generic:"192.168.42.3" /user:"192.168.42.3\printuser" /pass:"@YandeH!@#2019V2"

cmdkey /add:"192.168.42.3" /user:"192.168.42.3\printuser" /pass:"@YandeH!@#2019V2"
Start-Sleep -Seconds 10
net use \\192.168.42.3\IPC$ /user:192.168.42.3\printuser @YandeH!@#2019V2 /PERSISTENT:YES

# ================================
# Script de Mapeamento de Impressoras
# Servidor: 192.168.42.2
# ================================

$PrintServer = "\\192.168.42.3"
$Printers = @(
    "HP Expedicao 1",
    "HP Expedicao 2",
    "HP Adm",
    "HP Recebimento",
    "HP Picking"
)

foreach ($Printer in $Printers) {

    $FullPath = "$PrintServer\$Printer"

    # Verifica se já está instalada
    if (-not (Get-Printer | Where-Object { $_.Name -eq $Printer })) {

        try {
            Write-Host "Instalando impressora $Printer ..."
            Add-Printer -ConnectionName $FullPath
            Write-Host "✔ Impressora $Printer instalada com sucesso." -ForegroundColor Green
        }
        catch {
            Write-Host "❌ Erro ao instalar $Printer" -ForegroundColor Red
        }

    }
    else {
        Write-Host "⚠ Impressora $Printer já está instalada."
    }
}

# Add-Printer -ConnectionName "\\192.168.42.2\HP Expedicao 1"
# Get-Printer -ComputerName 192.168.42.3