Install-Module ExchangeOnlineManagement

# Conecta ao Exchange Online PowerShell
Write-Host "Conectando ao Exchange Online PowerShell..."
Try {
    Connect-ExchangeOnline -ShowBanner:$false
    Write-Host "Conexão bem-sucedida!"
} Catch {
    Write-Error "Falha ao conectar ao Exchange Online PowerShell. Verifique suas credenciais e permissões."
    exit
}

# Obter caixas de correio compartilhadas
Write-Host "Obtendo caixas de correio compartilhadas..."
Try {
    $SharedMailboxes = Get-Mailbox -RecipientTypeDetails SharedMailbox -ResultSize Unlimited | Select-Object DisplayName, PrimarySmtpAddress, @{Name='Members';Expression={(Get-MailboxPermission $_.Identity | Where-Object {$_.AccessRights -like '*FullAccess*' -and $_.IsInherited -eq $false -and -not $_.User -like 'NT AUTHORITY\SELF'}).User -join '; '}}
    Write-Host "Caixas de correio compartilhadas obtidas com sucesso!"
} Catch {
    Write-Error "Falha ao obter caixas de correio compartilhadas. Verifique suas permissões."
    exit
}

# 3. Selecionar propriedades relevantes e exportar
If ($SharedMailboxes) {
    $OutputFilePath = "C:\Scripts\_$(Get-Date -Format 'ddMMyyyy').csv"
    $SharedMailboxes | Export-Csv -Path $OutputFilePath -NoTypeInformation -Encoding UTF8
    Write-Host "Lista de caixas de correio compartilhadas exportada para: $OutputFilePath"
} Else {
    Write-Host "Nenhuma caixa de correio compartilhada encontrada."
}

# Desconectar da sessão do Exchange Online PowerShell
Write-Host "Desconectando da sessão do Exchange Online PowerShell..."
Try {
    Disconnect-ExchangeOnline -Confirm:$false
    Write-Host "Desconexão bem-sucedida!"
} Catch {
    Write-Error "Falha ao desconectar da sessão do Exchange Online PowerShell."
}