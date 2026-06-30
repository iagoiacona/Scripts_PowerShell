# ================================
# Script de Mapeamento de Impressoras
# Servidor: 192.168.42.3
# ================================

$PrintServer = "\\192.168.42.3"
$Printers = @(
    "Zebra doca 1",
    "Zebra Doca 203",
    "Zebra Expedicao 1",
    "Zebra ilha 1",
    "Zebra ilha 2",
    "Zebra recebimento",
    "Zebra expedicao 2"
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