# HA Dashboard

Einzelne Datei `dashboard.html` – läuft im Browser, spricht per WebSocket mit Home Assistant.
Zugriffstoken und Layout liegen nur im Browser (localStorage), nicht in dieser Datei und nicht im Repo.

Optional daneben: `bmw.jpg` (Fahrzeugfoto für den Wandmodus, wird automatisch freigestellt).

## Updates auf den HA-Server bringen

### Variante A – direkt kopieren (einfachste, ohne Git)

1. In Home Assistant das Add-on **Samba share** installieren und starten.
2. Hier im Ordner (PowerShell):

   ```powershell
   .\deploy.ps1                                   # \\homeassistant.local\config\www
   .\deploy.ps1 -Target "\\192.168.1.50\config\www"
   ```

   Oder per SSH (Add-on **Advanced SSH & Web Terminal**):

   ```powershell
   .\deploy.ps1 -Ssh "root@homeassistant.local"
   ```

3. Aufruf: `http://<ha-adresse>:8123/local/dashboard.html`

### Variante B – mit Git (Push vom PC, Pull auf dem Server)

Einmalig am PC (Git für Windows nötig, privates GitHub-Repo anlegen):

```powershell
git init -b main
git add .
git commit -m "Dashboard"
git remote add origin https://github.com/<user>/ha-dashboard.git
git push -u origin main
```

Einmalig auf dem HA-Server (SSH-Add-on):

```bash
cd /config/www
git clone https://github.com/<user>/ha-dashboard.git dashboard-repo
```

Aufruf: `http://<ha-adresse>:8123/local/dashboard-repo/dashboard.html`

Updates: am PC `git add . && git commit -m "..." && git push`, auf dem Server

```bash
cd /config/www/dashboard-repo && git pull --ff-only
```

Privates Repo: auf dem Server einen Deploy-Key (nur lesen) oder ein Fine-grained-Token verwenden.

### Raspberry Pi (Wandmodus)

Variante 1 (einfach): Chromium zeigt direkt die HA-Adresse – kein Git auf dem Pi nötig.

```bash
chromium-browser --kiosk "http://<ha-adresse>:8123/local/dashboard.html#kiosk"
```

Der Wandmodus prüft alle 10 Minuten, ob sich die Datei geändert hat, und lädt dann selbst neu.
Den Token einmal im Zahnrad eintragen (bleibt im Browser-Profil des Pi).
