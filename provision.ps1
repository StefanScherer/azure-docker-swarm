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

#Write-Host Pulling latest images
#docker pull microsoft/windowsservercore
#docker pull microsoft/nanoserver

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
$version = "17.06.0-ce-rc4"
$downloadUrl = "https://download.docker.com/win/static/test/x86_64/docker-$version.zip"
$outFilePath = "$env:TEMP\docker.zip"
Write-Output "--Downloading: $downloadUrl"
Invoke-WebRequest -UseBasicParsing -OutFile $outFilePath -Uri $downloadUrl
Expand-Archive -Path $outFilePath -DestinationPath $env:ProgramFiles -Force
Remove-Item $outFilePath
Start-Service docker

Write-Host Disable autologon
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name AutoAdminLogon -PropertyType DWORD -Value "0" -Force

Write-Host "Downloading OpenSSH"
Invoke-WebRequest "https://github.com/PowerShell/Win32-OpenSSH/releases/download/v0.0.16.0/OpenSSH-Win64.zip" -OutFile OpenSSH-Win64.zip -UseBasicParsing

Write-Host "Expanding OpenSSH"
Expand-Archive OpenSSH-Win64.zip C:\
Remove-Item -Force OpenSSH-Win64.zip

Write-Host "Disabling password authentication"
Add-Content C:\OpenSSH-Win64\sshd_config "`nPasswordAuthentication no"
Add-Content C:\OpenSSH-Win64\sshd_config "`nUseDNS no"

Push-Location C:\OpenSSH-Win64

Write-Host "Installing OpenSSH"
& .\install-sshd.ps1

Write-Host "Installing OpenSSH key auth"
& .\install-sshlsa.ps1

Write-Host "Generating host keys"
.\ssh-keygen.exe -A

Pop-Location

$newPath = 'C:\OpenSSH-Win64;' + [Environment]::GetEnvironmentVariable("PATH", [EnvironmentVariableTarget]::Machine)
[Environment]::SetEnvironmentVariable("PATH", $newPath, [EnvironmentVariableTarget]::Machine)

Write-Host "Adding public key to authorized_keys"
$keyPath = "~\.ssh\authorized_keys"
New-Item -Type Directory ~\.ssh > $null
$sshKey | Out-File $keyPath -Encoding Ascii

Write-Host "Opening firewall port 22"
New-NetFirewallRule -Protocol TCP -LocalPort 22 -Direction Inbound -Action Allow -DisplayName SSH

Write-Host "Setting sshd service startup type to 'Automatic'"
Set-Service sshd -StartupType Automatic
Set-Service ssh-agent -StartupType Automatic
Write-Host "Setting sshd service restart behavior"
sc.exe failure sshd reset= 86400 actions= restart/500

Write-Host Cleaning up
Remove-Item C:\provision.ps1

Restart-Computer -Force
