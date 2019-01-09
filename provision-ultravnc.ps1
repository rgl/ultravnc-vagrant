$ultraVncHome = 'C:\Program Files\uvnc bvba\UltraVnc'

choco install -y ultravnc

Write-Host 'Copying configuration file...'
Copy-Item -Force C:\vagrant\UltraVNC.ini $ultraVncHome

Write-Host 'Configuring MS Logon ACL...'
# NB this file was generated with:
#       &"C:\Program Files\uvnc bvba\UltraVnc\MSLogonACL.exe" /e C:\vagrant\UltraVNC-MSLogonACL.txt
&"$ultraVncHome\MSLogonACL.exe" /i /o C:\vagrant\UltraVNC-MSLogonACL.txt

# NB VNC password authentication is disabled in UltraVNC.ini,
#    this is here to show how we could change the passwords.
# NB the user can login using the local Windows users credentials.
# Write-Host 'Configuring VNC and View-Only passwords...'
# # NB each password must be at most 8 bytes.
# &"$ultraVncHome\setpasswd.exe" vagrant vagrant

Write-Host 'Restarting service...'
Restart-Service uvnc_service

# open the firewall.
Write-Host 'Creating the firewall rule to allow inbound TCP/IP access to the UltraVNC port 5900 and 5800...'
New-NetFirewallRule `
    -Name 'ULTRAVNC-In-TCP' `
    -DisplayName 'UltraVNC (TCP-In)' `
    -Direction Inbound `
    -Enabled True `
    -Protocol TCP `
    -LocalPort 5900 `
    | Out-Null

# add default desktop shortcuts (called from a provision-common.ps1 generated script).
[IO.File]::WriteAllText(
    "$env:USERPROFILE\ConfigureDesktop-UltraVnc.ps1",
@'
Install-ChocolateyShortcut `
    -ShortcutFilePath "$env:USERPROFILE\Desktop\UltraVNC Viewer.lnk" `
    -TargetPath 'C:\Program Files\uvnc bvba\UltraVnc\vncviewer.exe'
Install-ChocolateyShortcut `
    -ShortcutFilePath "$env:USERPROFILE\Desktop\UltraVNC Settings.lnk" `
    -TargetPath 'C:\Program Files\uvnc bvba\UltraVnc\uvnc_settings.exe'
'@)
