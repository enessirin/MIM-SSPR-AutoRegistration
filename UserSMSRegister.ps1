try{Add-PSSnapin FIMAutomation -ErrorAction Stop
Write-Host "FIMAutomation Module is imported" -ForegroundColor Green}
catch{Write-Host "FIMAutomation Module could not be imported" -ForegroundColor Red
break}
try{Import-Module ActiveDirectory -ErrorAction Stop
Write-Host "ActiveDirectory Module is imported" -ForegroundColor Green}
catch{Write-Host "ActiveDirectory Module could not be imported" -ForegroundColor Red
break}
param(
     [Parameter(Mandatory=$true)]
     [string]$DomainName
 )
$adusers = Get-ADUser -Filter * -Properties SamAccountName,MobilePhone
$adusers  | ForEach-Object {

$SamAccountName = $_.SamAccountName
$Mobile = $_.MobilePhone
$SamAccountName = $DomainName+"\"+$SamAccountName
$template = Get-AuthenticationWorkflowRegistrationTemplate -AuthenticationWorkflowName "Password Reset AuthN Workflow"
$custom = $template.Clone()
$custom.GateRegistrationTemplates.Data.Value = $Mobile
try{
Register-AuthenticationWorkflow -UserName $SamAccountName -AuthenticationWorkflowRegistrationTemplate $custom
Write-Host $SamAccountName "is registered." -ForegroundColor Green
}
catch{
Write-Host $SamAccountName "is not registered." -ForegroundColor Red
}
}