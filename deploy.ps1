# Dashboard direkt auf den Home-Assistant-Server kopieren (ohne Git).
#
# Variante 1 – Samba-Freigabe (Add-on "Samba share"):
#   .\deploy.ps1
#   .\deploy.ps1 -Target "\\192.168.1.50\config\www"
#
# Variante 2 – SSH/SCP (Add-on "Advanced SSH & Web Terminal", Port meist 22):
#   .\deploy.ps1 -Ssh "root@homeassistant.local" -Port 22
#
# Kopiert dashboard.html (+ bmw.jpg/png/webp, falls vorhanden) nach /config/www.
# Danach im Browser neu laden – der Wandmodus lädt sich selbst neu (alle ~10 Minuten).

param(
  [string]$Target = "\\homeassistant.local\config\www",
  [string]$Ssh = "",
  [int]$Port = 22
)

$ErrorActionPreference = "Stop"
$here  = Split-Path -Parent $MyInvocation.MyCommand.Path
$files = @("dashboard.html","bmw.jpg","bmw.png","bmw.webp") |
         ForEach-Object { Join-Path $here $_ } | Where-Object { Test-Path $_ }

if (-not (Test-Path (Join-Path $here "dashboard.html"))) { throw "dashboard.html fehlt im Ordner $here" }

if ($Ssh) {
  foreach ($f in $files) {
    Write-Host "scp $(Split-Path -Leaf $f) -> ${Ssh}:/config/www/"
    & scp -P $Port $f "${Ssh}:/config/www/"
    if ($LASTEXITCODE -ne 0) { throw "scp fehlgeschlagen" }
  }
} else {
  if (-not (Test-Path $Target)) { throw "Ziel nicht erreichbar: $Target (Samba-Add-on aktiv? Adresse/IP prüfen)" }
  foreach ($f in $files) {
    Write-Host "Kopiere $(Split-Path -Leaf $f) -> $Target"
    Copy-Item $f $Target -Force
  }
}
Write-Host "Fertig. Aufruf: http://<ha-adresse>:8123/local/dashboard.html"
