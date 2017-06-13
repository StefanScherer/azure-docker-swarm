Start-Transcript -Path C:\provision.log

$ProgressPreference = 'SilentlyContinue'

Write-Host "provision.ps1"
Write-Host "FQDN = $($FQDN)"

Write-Host Windows Updates to manual
Cscript $env:WinDir\System32\SCregEdit.wsf /AU 1
Net stop wuauserv
Net start wuauserv

Write-Host Disable Windows Defender
Set-MpPreference -DisableRealtimeMonitoring $true

Write-Host Do not open Server Manager at logon
New-ItemProperty -Path HKCU:\Software\Microsoft\ServerManager -Name DoNotOpenServerManagerAtLogon -PropertyType DWORD -Value "1" -Force

Write-Host Pulling latest images
docker pull microsoft/windowsservercore
docker pull microsoft/nanoserver

Write-Host Open Swarm-mode ports
& netsh advfirewall firewall add rule name="Docker swarm-mode cluster management TCP" dir=in action=allow protocol=TCP localport=2377
& netsh advfirewall firewall add rule name="Docker swarm-mode node communication TCP" dir=in action=allow protocol=TCP localport=7946
& netsh advfirewall firewall add rule name="Docker swarm-mode node communication UDP" dir=in action=allow protocol=UDP localport=7946
& netsh advfirewall firewall add rule name="Docker swarm-mode overlay network UDP" dir=in action=allow protocol=UDP localport=4789

Write-Host Update Docker
# Install-Package -Name docker -ProviderName DockerMsftProvider -Verbose -Update -Force
$service = Get-Service 'docker' -ErrorAction SilentlyContinue
if ($service) {
    Write-Output '--Stopping Docker Windows service'
    Stop-Service docker
}
$version = "17.06.0-ce-rc3"
$downloadUrl = "https://download.docker.com/win/static/test/x86_64/docker-$version-x86_64.zip"
$outFilePath = "$env:TEMP\docker.zip"
Write-Output "--Downloading: $downloadUrl"
Invoke-WebRequest -UseBasicParsing -OutFile $outFilePath -Uri $downloadUrl
Expand-Archive -Path $outFilePath -DestinationPath $env:ProgramFiles -Force
Remove-Item $outFilePath
Start-Service docker

Write-Host Disable autologon
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name AutoAdminLogon -PropertyType DWORD -Value "0" -Force

Write-Host Cleaning up
Remove-Item C:\provision.ps1
