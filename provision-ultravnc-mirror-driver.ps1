$ultraVncMirrorDriverHome = "C:\Program Files\uvnc bvba\UltraVncMirrorDriver"
$archiveUrl = 'http://sc.uvnc.com/drivers.zip'
$archiveHash = '67001c8f5a37c1ccd2d1750f21e28d372a8639c330aafbae111a5956c942b71a'
$archiveName = Split-Path $archiveUrl -Leaf
$archivePath = "$env:TEMP\$archiveName"

Write-Host 'Downloading mirror driver...'
(New-Object Net.WebClient).DownloadFile($archiveUrl, $archivePath)
$archiveActualHash = (Get-FileHash $archivePath -Algorithm SHA256).Hash
if ($archiveHash -ne $archiveActualHash) {
    throw "$archiveName downloaded from $archiveUrl to $archivePath has $archiveActualHash hash witch does not match the expected $archiveHash"
}

Write-Host 'Installing mirror driver...'
Expand-Archive $archivePath -DestinationPath $ultraVncMirrorDriverHome
Rename-Item "$ultraVncMirrorDriverHome\driver" "$ultraVncMirrorDriverHome\tmp"
Move-Item "$ultraVncMirrorDriverHome\tmp\vista64\*" $ultraVncMirrorDriverHome
Remove-Item -Recurse -Force "$ultraVncMirrorDriverHome\tmp"
$catPath = "$ultraVncMirrorDriverHome\driver\mv2.cat"
$cerPath = $catPath.Replace('.cat', '.cer')
$certificate = (Get-AuthenticodeSignature $catPath).SignerCertificate
[System.IO.File]::WriteAllBytes($cerPath, $certificate.Export('Cert'))
Import-Certificate -CertStoreLocation Cert:\LocalMachine\TrustedPublisher $cerPath | Out-Null
Push-Location $ultraVncMirrorDriverHome
.\setupdrv.exe install | Out-String -Stream
Pop-Location
Remove-Item $archivePath
