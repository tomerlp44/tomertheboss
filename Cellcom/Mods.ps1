#download the exe ignoring the ssl warning:
$url = https://10.0.10.85/windows_installer.exe
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
$result = Invoke-WebRequest $url -OutFile 'c:\software\windows_installer.exe' -UseBasicParsing


#


