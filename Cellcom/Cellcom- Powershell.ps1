<#
Guardicore agent package distributor
Created by Tomer La France

#>

Set-ExecutionPolicy -ExecutionPolicy Unrestricted

#Variables:
$url = 'https://10.0.10.85/windows_installer.exe'
$agg_ip = '<Aggregator_ip/Clusters_fqdn>'
$Pass = "PASS"

#Staging area:

$Nodes = Get-Content -path .\nodes.txt
#test connection against all nodes to see if all are alive
Write-Host -ForegroundColor Cyan "PING TEST!"

Foreach($Node in $Nodes){
If((Test-Connection -ComputerName $Node -Count 1 -Quiet))
{
    Write-Host -ForegroundColor Yellow "$Node Ping success"
} else {
Write-Host -ForegroundColor Red "$Node ping Failed"
}
}

#Download and install:
Set-Item WSMan:localhost\client\trustedhosts -value * -Force

Foreach($Node in $Nodes)
{

Invoke-Command -ComputerName $Node -Credential administrator -ScriptBlock {

$url = 'https://10.0.10.85/windows_installer.exe'
$agg_ip = '<Aggregator_ip/Clusters_fqdn>'
$Pass = "PASS"

add-type @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
    public class TrustAllCertsPolicy : ICertificatePolicy {
        public bool CheckValidationResult(
            ServicePoint srvPoint, X509Certificate certificate,
            WebRequest request, int certificateProblem) {
            return true;
        }
    }
"@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy

    New-Item -ItemType directory -Path C:\Software
    $result = Invoke-WebRequest $url -OutFile 'c:\software\windows_installer.exe' -UseBasicParsing #Might need to create the directory first
    
    Write-Host -ForegroundColor Cyan "Attempting Installation..."
    c:\software\windows_installer.exe /a ${agg_ip}:443 /p $Pass /q
    Start-Sleep -s 60

    $software = "Guardicore Agents"
    $installed = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where { $_.DisplayName -eq $software }) -ne $null

    If(-Not $installed) {
    	Write-Host -ForegroundColor Red "'$software' is NOT installed."
    } else {
    	Write-Host -ForegroundColor Yellow "'$software' is installed Successfully."
}
}
}