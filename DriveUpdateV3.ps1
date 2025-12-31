# Driver Updater by CHARITH - v3.0
# Run as Administrator
# Usage: irm https://raw.githubusercontent.com/The CHARITH/DriverUpdate/main/DriverUpdatev2.ps1 | iex
# Silent mode: .\updateAllDrivers.ps1 -Silent -Task "CheckDriverUpdates"

param(
    [switch]$Silent,
    [string]$Task = "",
    [string]$Language = "en",
    [string]$ProxyAddress = "",
    [string]$FilterClass = "",
    [string]$FilterManufacturer = ""
)

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# -------------------------
# Multi-Language Support
# -------------------------
$global:Languages = @{
    "en" = @{
        AppTitle = "Driver Updater by The CHARITH"
        BtnWU = "Check Windows Update"
        BtnCheckUpdates = "Check Driver Updates"
        BtnScan = "Scan Installed Drivers"
        BtnBackup = "Backup Drivers"
        BtnInstall = "Install From Folder"
        BtnCancel = "Cancel Task"
        BtnOpenLogs = "Open Logs"
        BtnDarkMode = "Dark Mode"
        BtnLightMode = "Light Mode"
        BtnSchedule = "Schedule Updates"
        BtnRestorePoint = "Create Restore Point"
        BtnHistory = "Update History"
        BtnSettings = "Settings"
        BtnFilters = "Filters"
        TaskRunning = "A task is already running. Cancel it first."
        PermissionError = "Please run this script as Administrator."
        BackupCanceled = "Backup canceled by user."
        InstallCanceled = "Install canceled by user."
        NoTaskToCancel = "No running task to cancel."
        TaskCancelled = "[CANCELLED] Task cancelled by user."
        LogFolderMissing = "Log folder missing."
        StartingTask = "-> Starting task:"
        TaskFinished = "=== Task finished:"
        SelectBackupFolder = "Select folder to save driver backup"
        SelectDriverFolder = "Select folder containing driver .inf files"
        ScheduleCreated = "Scheduled task created successfully!"
        ScheduleRemoved = "Scheduled task removed."
        RestorePointCreated = "System restore point created successfully!"
        RestorePointFailed = "Failed to create restore point."
        ProxyConfigured = "Proxy configured:"
        ProxyCleared = "Proxy settings cleared."
        FilterApplied = "Filter applied:"
        FilterCleared = "Filters cleared."
        LanguageChanged = "Language changed to:"
        HistoryEmpty = "No update history found."
        SettingsTitle = "Settings"
        ScheduleTitle = "Schedule Updates"
        FilterTitle = "Driver Filters"
        HistoryTitle = "Update History"
        Daily = "Daily"
        Weekly = "Weekly"
        Monthly = "Monthly"
        Time = "Time:"
        ProxyLabel = "Proxy Address:"
        ClassFilter = "Filter by Class:"
        ManufacturerFilter = "Filter by Manufacturer:"
        Apply = "Apply"
        Clear = "Clear"
        Close = "Close"
        Enable = "Enable"
        Disable = "Disable"
        Remove = "Remove Schedule"
    }
    "es" = @{
        AppTitle = "Actualizador de Controladores por The CHARITH"
        BtnWU = "Buscar Windows Update"
        BtnCheckUpdates = "Buscar Controladores"
        BtnScan = "Escanear Controladores"
        BtnBackup = "Respaldar Controladores"
        BtnInstall = "Instalar desde Carpeta"
        BtnCancel = "Cancelar Tarea"
        BtnOpenLogs = "Abrir Registros"
        BtnDarkMode = "Modo Oscuro"
        BtnLightMode = "Modo Claro"
        BtnSchedule = "Programar Actualizaciones"
        BtnRestorePoint = "Crear Punto Restauracion"
        BtnHistory = "Historial"
        BtnSettings = "Configuracion"
        BtnFilters = "Filtros"
        TaskRunning = "Ya hay una tarea en ejecucion. Cancelela primero."
        PermissionError = "Ejecute este script como Administrador."
        BackupCanceled = "Respaldo cancelado por el usuario."
        InstallCanceled = "Instalacion cancelada por el usuario."
        NoTaskToCancel = "No hay tarea para cancelar."
        TaskCancelled = "[CANCELADO] Tarea cancelada por el usuario."
        LogFolderMissing = "Carpeta de registros no encontrada."
        StartingTask = "-> Iniciando tarea:"
        TaskFinished = "=== Tarea finalizada:"
        SelectBackupFolder = "Seleccione carpeta para guardar respaldo"
        SelectDriverFolder = "Seleccione carpeta con archivos .inf"
        ScheduleCreated = "Tarea programada creada!"
        ScheduleRemoved = "Tarea programada eliminada."
        RestorePointCreated = "Punto de restauracion creado!"
        RestorePointFailed = "Error al crear punto de restauracion."
        ProxyConfigured = "Proxy configurado:"
        ProxyCleared = "Configuracion de proxy eliminada."
        FilterApplied = "Filtro aplicado:"
        FilterCleared = "Filtros eliminados."
        LanguageChanged = "Idioma cambiado a:"
        HistoryEmpty = "No hay historial de actualizaciones."
        SettingsTitle = "Configuracion"
        ScheduleTitle = "Programar Actualizaciones"
        FilterTitle = "Filtros de Controladores"
        HistoryTitle = "Historial de Actualizaciones"
        Daily = "Diario"
        Weekly = "Semanal"
        Monthly = "Mensual"
        Time = "Hora:"
        ProxyLabel = "Direccion Proxy:"
        ClassFilter = "Filtrar por Clase:"
        ManufacturerFilter = "Filtrar por Fabricante:"
        Apply = "Aplicar"
        Clear = "Limpiar"
        Close = "Cerrar"
        Enable = "Habilitar"
        Disable = "Deshabilitar"
        Remove = "Eliminar Programacion"
    }
    "fr" = @{
        AppTitle = "Mise a jour des pilotes par The CHARITH"
        BtnWU = "Windows Update"
        BtnCheckUpdates = "Verifier les Pilotes"
        BtnScan = "Analyser les Pilotes"
        BtnBackup = "Sauvegarder"
        BtnInstall = "Installer depuis Dossier"
        BtnCancel = "Annuler"
        BtnOpenLogs = "Ouvrir Journaux"
        BtnDarkMode = "Mode Sombre"
        BtnLightMode = "Mode Clair"
        BtnSchedule = "Planifier"
        BtnRestorePoint = "Point de Restauration"
        BtnHistory = "Historique"
        BtnSettings = "Parametres"
        BtnFilters = "Filtres"
        TaskRunning = "Une tache est deja en cours. Annulez-la d'abord."
        PermissionError = "Executez ce script en tant qu'Administrateur."
        BackupCanceled = "Sauvegarde annulee."
        InstallCanceled = "Installation annulee."
        NoTaskToCancel = "Aucune tache a annuler."
        TaskCancelled = "[ANNULE] Tache annulee."
        LogFolderMissing = "Dossier des journaux manquant."
        StartingTask = "-> Demarrage de la tache:"
        TaskFinished = "=== Tache terminee:"
        SelectBackupFolder = "Selectionnez le dossier de sauvegarde"
        SelectDriverFolder = "Selectionnez le dossier avec les fichiers .inf"
        ScheduleCreated = "Tache planifiee creee!"
        ScheduleRemoved = "Tache planifiee supprimee."
        RestorePointCreated = "Point de restauration cree!"
        RestorePointFailed = "Echec de creation du point de restauration."
        ProxyConfigured = "Proxy configure:"
        ProxyCleared = "Parametres proxy effaces."
        FilterApplied = "Filtre applique:"
        FilterCleared = "Filtres effaces."
        LanguageChanged = "Langue changee en:"
        HistoryEmpty = "Aucun historique trouve."
        SettingsTitle = "Parametres"
        ScheduleTitle = "Planifier les Mises a Jour"
        FilterTitle = "Filtres des Pilotes"
        HistoryTitle = "Historique des Mises a Jour"
        Daily = "Quotidien"
        Weekly = "Hebdomadaire"
        Monthly = "Mensuel"
        Time = "Heure:"
        ProxyLabel = "Adresse Proxy:"
        ClassFilter = "Filtrer par Classe:"
        ManufacturerFilter = "Filtrer par Fabricant:"
        Apply = "Appliquer"
        Clear = "Effacer"
        Close = "Fermer"
        Enable = "Activer"
        Disable = "Desactiver"
        Remove = "Supprimer Planification"
    }
    "de" = @{
        AppTitle = "Treiber-Updater von The CHARITH"
        BtnWU = "Windows Update"
        BtnCheckUpdates = "Treiber pruefen"
        BtnScan = "Treiber scannen"
        BtnBackup = "Sicherung"
        BtnInstall = "Aus Ordner installieren"
        BtnCancel = "Abbrechen"
        BtnOpenLogs = "Protokolle"
        BtnDarkMode = "Dunkelmodus"
        BtnLightMode = "Hellmodus"
        BtnSchedule = "Zeitplan"
        BtnRestorePoint = "Wiederherstellungspunkt"
        BtnHistory = "Verlauf"
        BtnSettings = "Einstellungen"
        BtnFilters = "Filter"
        TaskRunning = "Eine Aufgabe laeuft bereits."
        PermissionError = "Fuehren Sie dieses Skript als Administrator aus."
        BackupCanceled = "Sicherung abgebrochen."
        InstallCanceled = "Installation abgebrochen."
        NoTaskToCancel = "Keine Aufgabe zum Abbrechen."
        TaskCancelled = "[ABGEBROCHEN] Aufgabe abgebrochen."
        LogFolderMissing = "Protokollordner fehlt."
        StartingTask = "-> Starte Aufgabe:"
        TaskFinished = "=== Aufgabe beendet:"
        SelectBackupFolder = "Sicherungsordner auswaehlen"
        SelectDriverFolder = "Ordner mit .inf-Dateien auswaehlen"
        ScheduleCreated = "Geplante Aufgabe erstellt!"
        ScheduleRemoved = "Geplante Aufgabe entfernt."
        RestorePointCreated = "Wiederherstellungspunkt erstellt!"
        RestorePointFailed = "Fehler beim Erstellen des Wiederherstellungspunkts."
        ProxyConfigured = "Proxy konfiguriert:"
        ProxyCleared = "Proxy-Einstellungen geloescht."
        FilterApplied = "Filter angewendet:"
        FilterCleared = "Filter geloescht."
        LanguageChanged = "Sprache geaendert zu:"
        HistoryEmpty = "Kein Verlauf gefunden."
        SettingsTitle = "Einstellungen"
        ScheduleTitle = "Updates planen"
        FilterTitle = "Treiberfilter"
        HistoryTitle = "Update-Verlauf"
        Daily = "Taeglich"
        Weekly = "Woechentlich"
        Monthly = "Monatlich"
        Time = "Zeit:"
        ProxyLabel = "Proxy-Adresse:"
        ClassFilter = "Nach Klasse filtern:"
        ManufacturerFilter = "Nach Hersteller filtern:"
        Apply = "Anwenden"
        Clear = "Loeschen"
        Close = "Schliessen"
        Enable = "Aktivieren"
        Disable = "Deaktivieren"
        Remove = "Zeitplan entfernen"
    }
    "pt" = @{
        AppTitle = "Atualizador de Drivers por The CHARITH"
        BtnWU = "Windows Update"
        BtnCheckUpdates = "Verificar Drivers"
        BtnScan = "Escanear Drivers"
        BtnBackup = "Backup"
        BtnInstall = "Instalar da Pasta"
        BtnCancel = "Cancelar"
        BtnOpenLogs = "Abrir Logs"
        BtnDarkMode = "Modo Escuro"
        BtnLightMode = "Modo Claro"
        BtnSchedule = "Agendar"
        BtnRestorePoint = "Ponto de Restauracao"
        BtnHistory = "Historico"
        BtnSettings = "Configuracoes"
        BtnFilters = "Filtros"
        TaskRunning = "Uma tarefa ja esta em execucao."
        PermissionError = "Execute este script como Administrador."
        BackupCanceled = "Backup cancelado."
        InstallCanceled = "Instalacao cancelada."
        NoTaskToCancel = "Nenhuma tarefa para cancelar."
        TaskCancelled = "[CANCELADO] Tarefa cancelada."
        LogFolderMissing = "Pasta de logs nao encontrada."
        StartingTask = "-> Iniciando tarefa:"
        TaskFinished = "=== Tarefa concluida:"
        SelectBackupFolder = "Selecione a pasta de backup"
        SelectDriverFolder = "Selecione a pasta com arquivos .inf"
        ScheduleCreated = "Tarefa agendada criada!"
        ScheduleRemoved = "Tarefa agendada removida."
        RestorePointCreated = "Ponto de restauracao criado!"
        RestorePointFailed = "Falha ao criar ponto de restauracao."
        ProxyConfigured = "Proxy configurado:"
        ProxyCleared = "Configuracoes de proxy limpas."
        FilterApplied = "Filtro aplicado:"
        FilterCleared = "Filtros limpos."
        LanguageChanged = "Idioma alterado para:"
        HistoryEmpty = "Nenhum historico encontrado."
        SettingsTitle = "Configuracoes"
        ScheduleTitle = "Agendar Atualizacoes"
        FilterTitle = "Filtros de Drivers"
        HistoryTitle = "Historico de Atualizacoes"
        Daily = "Diario"
        Weekly = "Semanal"
        Monthly = "Mensal"
        Time = "Hora:"
        ProxyLabel = "Endereco Proxy:"
        ClassFilter = "Filtrar por Classe:"
        ManufacturerFilter = "Filtrar por Fabricante:"
        Apply = "Aplicar"
        Clear = "Limpar"
        Close = "Fechar"
        Enable = "Habilitar"
        Disable = "Desabilitar"
        Remove = "Remover Agendamento"
    }
    "it" = @{
        AppTitle = "Aggiornamento Driver di The CHARITH"
        BtnWU = "Windows Update"
        BtnCheckUpdates = "Verifica Driver"
        BtnScan = "Scansiona Driver"
        BtnBackup = "Backup"
        BtnInstall = "Installa da Cartella"
        BtnCancel = "Annulla"
        BtnOpenLogs = "Apri Log"
        BtnDarkMode = "Modalita Scura"
        BtnLightMode = "Modalita Chiara"
        BtnSchedule = "Pianifica"
        BtnRestorePoint = "Punto di Ripristino"
        BtnHistory = "Cronologia"
        BtnSettings = "Impostazioni"
        BtnFilters = "Filtri"
        TaskRunning = "Un'attivita e gia in esecuzione."
        PermissionError = "Esegui questo script come Amministratore."
        BackupCanceled = "Backup annullato."
        InstallCanceled = "Installazione annullata."
        NoTaskToCancel = "Nessuna attivita da annullare."
        TaskCancelled = "[ANNULLATO] Attivita annullata."
        LogFolderMissing = "Cartella log mancante."
        StartingTask = "-> Avvio attivita:"
        TaskFinished = "=== Attivita completata:"
        SelectBackupFolder = "Seleziona cartella di backup"
        SelectDriverFolder = "Seleziona cartella con file .inf"
        ScheduleCreated = "Attivita pianificata creata!"
        ScheduleRemoved = "Attivita pianificata rimossa."
        RestorePointCreated = "Punto di ripristino creato!"
        RestorePointFailed = "Errore nella creazione del punto di ripristino."
        ProxyConfigured = "Proxy configurato:"
        ProxyCleared = "Impostazioni proxy cancellate."
        FilterApplied = "Filtro applicato:"
        FilterCleared = "Filtri cancellati."
        LanguageChanged = "Lingua cambiata in:"
        HistoryEmpty = "Nessuna cronologia trovata."
        SettingsTitle = "Impostazioni"
        ScheduleTitle = "Pianifica Aggiornamenti"
        FilterTitle = "Filtri Driver"
        HistoryTitle = "Cronologia Aggiornamenti"
        Daily = "Giornaliero"
        Weekly = "Settimanale"
        Monthly = "Mensile"
        Time = "Ora:"
        ProxyLabel = "Indirizzo Proxy:"
        ClassFilter = "Filtra per Classe:"
        ManufacturerFilter = "Filtra per Produttore:"
        Apply = "Applica"
        Clear = "Cancella"
        Close = "Chiudi"
        Enable = "Abilita"
        Disable = "Disabilita"
        Remove = "Rimuovi Pianificazione"
    }
}

# Get localized string
function Get-LocalizedString([string]$key) {
    $lang = $global:CurrentLanguage
    if (-not $global:Languages.ContainsKey($lang)) { $lang = "en" }
    if ($global:Languages[$lang].ContainsKey($key)) {
        return $global:Languages[$lang][$key]
    }
    return $global:Languages["en"][$key]
}

$global:CurrentLanguage = $Language

# -------------------------
# Require Admin
# -------------------------
function Assert-AdminPrivilege {
    if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        if (-not $Silent) {
            [System.Windows.Forms.MessageBox]::Show((Get-LocalizedString "PermissionError"), "Permission Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        }
        exit 1
    }
}
Assert-AdminPrivilege

# -------------------------
# Globals and paths
# -------------------------
$AppTitle = Get-LocalizedString "AppTitle"
$LogBase = Join-Path $env:USERPROFILE "Documents\The CHARITH_DriverUpdater"
$HistoryFile = Join-Path $LogBase "UpdateHistory.json"
$SettingsFile = Join-Path $LogBase "Settings.json"
if (!(Test-Path $LogBase)) { New-Item -ItemType Directory -Path $LogBase -Force | Out-Null }

$global:CurrentJob = $null
$global:CurrentTaskLog = $null
$global:ProxySettings = @{ Enabled = $false; Address = "" }
$global:FilterSettings = @{ Class = ""; Manufacturer = "" }
$global:DarkModeEnabled = $false

# -------------------------
# Settings Management
# -------------------------
function Import-Settings {
    if (Test-Path $SettingsFile) {
        try {
            $settings = Get-Content -Path $SettingsFile -Raw | ConvertFrom-Json
            if ($settings.Language) { $global:CurrentLanguage = $settings.Language }
            if ($settings.Proxy) { 
                $global:ProxySettings.Enabled = $settings.Proxy.Enabled
                $global:ProxySettings.Address = $settings.Proxy.Address
            }
            if ($settings.Filters) {
                $global:FilterSettings.Class = $settings.Filters.Class
                $global:FilterSettings.Manufacturer = $settings.Filters.Manufacturer
            }
            if ($null -ne $settings.DarkMode) { $global:DarkModeEnabled = $settings.DarkMode }
        } catch {}
    }
}

function Export-Settings {
    $settings = @{
        Language = $global:CurrentLanguage
        Proxy = $global:ProxySettings
        Filters = $global:FilterSettings
        DarkMode = $global:DarkModeEnabled
    }
    $settings | ConvertTo-Json -Depth 3 | Set-Content -Path $SettingsFile -Encoding UTF8
}

Import-Settings

# Apply command-line parameters
if ($ProxyAddress) {
    $global:ProxySettings.Enabled = $true
    $global:ProxySettings.Address = $ProxyAddress
}
if ($FilterClass) { $global:FilterSettings.Class = $FilterClass }
if ($FilterManufacturer) { $global:FilterSettings.Manufacturer = $FilterManufacturer }

# -------------------------
# Update History Logging
# -------------------------
function Add-HistoryEntry {
    param(
        [string]$TaskName,
        [string]$Status,
        [string]$Details
    )
    $history = @()
    if (Test-Path $HistoryFile) {
        try {
            $content = Get-Content -Path $HistoryFile -Raw
            if ($content) {
                $parsed = $content | ConvertFrom-Json
                if ($parsed -is [array]) { 
                    $history = $parsed 
                } else { 
                    $history = @($parsed) 
                }
            }
        } catch { $history = @() }
    }
    
    $entry = [PSCustomObject]@{
        Timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
        Task = $TaskName
        Status = $Status
        Details = $Details
    }
    $history = @($entry) + $history
    # Keep last 100 entries
    if ($history.Count -gt 100) { $history = $history[0..99] }
    $history | ConvertTo-Json -Depth 3 | Set-Content -Path $HistoryFile -Encoding UTF8
}

function Get-UpdateHistory {
    if (Test-Path $HistoryFile) {
        try {
            $content = Get-Content -Path $HistoryFile -Raw
            if ($content) {
                return $content | ConvertFrom-Json
            }
        } catch {}
    }
    return @()
}

# -------------------------
# Network Proxy Support
# -------------------------
function Set-ProxySettings {
    param([string]$ProxyAddr, [bool]$Enable)
    $global:ProxySettings.Address = $ProxyAddr
    $global:ProxySettings.Enabled = $Enable
    
    if ($Enable -and $ProxyAddr) {
        [System.Net.WebRequest]::DefaultWebProxy = New-Object System.Net.WebProxy($ProxyAddr, $true)
        $env:HTTP_PROXY = $ProxyAddr
        $env:HTTPS_PROXY = $ProxyAddr
    } else {
        [System.Net.WebRequest]::DefaultWebProxy = [System.Net.WebRequest]::GetSystemWebProxy()
        Remove-Item Env:\HTTP_PROXY -ErrorAction SilentlyContinue
        Remove-Item Env:\HTTPS_PROXY -ErrorAction SilentlyContinue
    }
    Export-Settings
}

# Apply proxy if configured
if ($global:ProxySettings.Enabled -and $global:ProxySettings.Address) {
    Set-ProxySettings -ProxyAddr $global:ProxySettings.Address -Enable $true
}

# -------------------------
# System Restore Point
# -------------------------
function New-RestorePoint {
    param([string]$Description = "Driver Updater Restore Point")
    try {
        # Enable System Restore on system drive if not already enabled
        Enable-ComputerRestore -Drive "$env:SystemDrive\" -ErrorAction SilentlyContinue
        
        # Create the restore point
        Checkpoint-Computer -Description $Description -RestorePointType "MODIFY_SETTINGS" -ErrorAction Stop
        Add-HistoryEntry -TaskName "RestorePoint" -Status "Success" -Details $Description
        return $true
    } catch {
        Add-HistoryEntry -TaskName "RestorePoint" -Status "Failed" -Details $_.Exception.Message
        return $false
    }
}

# -------------------------
# Scheduled Updates
# -------------------------
$ScheduledTaskName = "DriverUpdater_ScheduledCheck"

function Get-ScheduledUpdateTask {
    try {
        return Get-ScheduledTask -TaskName $ScheduledTaskName -ErrorAction SilentlyContinue
    } catch { return $null }
}

function Set-ScheduledUpdate {
    param(
        [ValidateSet("Daily", "Weekly", "Monthly")]
        [string]$Frequency,
        [string]$Time = "03:00"
    )
    
    try {
        # Remove existing task if any
        Remove-ScheduledUpdate
        
        $scriptPath = $PSCommandPath
        if (-not $scriptPath) { $scriptPath = $MyInvocation.PSCommandPath }
        
        $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -WindowStyle Hidden -File `"$scriptPath`" -Silent -Task CheckDriverUpdates"
        
        switch ($Frequency) {
            "Daily" { $trigger = New-ScheduledTaskTrigger -Daily -At $Time }
            "Weekly" { $trigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek Monday -At $Time }
            "Monthly" { $trigger = New-ScheduledTaskTrigger -Monthly -DaysOfMonth 1 -At $Time }
        }
        
        $principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest
        $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable
        
        Register-ScheduledTask -TaskName $ScheduledTaskName -Action $action -Trigger $trigger -Principal $principal -Settings $settings -Force | Out-Null
        
        Add-HistoryEntry -TaskName "ScheduleUpdate" -Status "Created" -Details "$Frequency at $Time"
        return $true
    } catch {
        Add-HistoryEntry -TaskName "ScheduleUpdate" -Status "Failed" -Details $_.Exception.Message
        return $false
    }
}

function Remove-ScheduledUpdate {
    try {
        Unregister-ScheduledTask -TaskName $ScheduledTaskName -Confirm:$false -ErrorAction SilentlyContinue
        return $true
    } catch { return $false }
}

# -------------------------
# Silent Mode Operation
# -------------------------
if ($Silent -and $Task) {
    $logFile = Join-Path $LogBase "$Task`_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"
    
    function Write-SilentLog($msg) {
        $timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
        Add-Content -Path $logFile -Value "$timestamp - $msg"
    }
    
    Write-SilentLog "Starting silent mode: $Task"
    
    switch ($Task) {
        "WindowsUpdate" {
            Write-SilentLog "Running Windows Update..."
            try {
                & wuauclt.exe /detectnow 2>&1 | Out-Null
                Start-Sleep -Seconds 2
                Start-Process -FilePath "usoclient.exe" -ArgumentList "StartScan" -NoNewWindow -Wait
                Start-Process -FilePath "usoclient.exe" -ArgumentList "StartDownload" -NoNewWindow -Wait
                Start-Process -FilePath "usoclient.exe" -ArgumentList "StartInstall" -NoNewWindow -Wait
                Write-SilentLog "Windows Update completed"
                Add-HistoryEntry -TaskName "WindowsUpdate" -Status "Completed" -Details "Silent mode"
            } catch {
                Write-SilentLog "Error: $_"
                Add-HistoryEntry -TaskName "WindowsUpdate" -Status "Failed" -Details $_.Exception.Message
            }
        }
        "CheckDriverUpdates" {
            Write-SilentLog "Checking for driver updates..."
            try {
                $UpdateSession = New-Object -ComObject Microsoft.Update.Session
                $UpdateSearcher = $UpdateSession.CreateUpdateSearcher()
                $SearchResult = $UpdateSearcher.Search("IsInstalled=0 and Type='Driver'")
                
                if ($SearchResult.Updates.Count -eq 0) {
                    Write-SilentLog "No driver updates available"
                    Add-HistoryEntry -TaskName "CheckDriverUpdates" -Status "Completed" -Details "No updates found"
                } else {
                    Write-SilentLog "Found $($SearchResult.Updates.Count) driver updates"
                    foreach ($Update in $SearchResult.Updates) {
                        Write-SilentLog "  - $($Update.Title)"
                    }
                    Add-HistoryEntry -TaskName "CheckDriverUpdates" -Status "Completed" -Details "Found $($SearchResult.Updates.Count) updates"
                }
            } catch {
                Write-SilentLog "Error: $_"
                Add-HistoryEntry -TaskName "CheckDriverUpdates" -Status "Failed" -Details $_.Exception.Message
            }
        }
        "ScanDrivers" {
            Write-SilentLog "Scanning installed drivers..."
            try {
                $drivers = Get-CimInstance Win32_PnPSignedDriver | Select-Object DeviceName, Manufacturer, DriverVersion, InfName, Class, DriverDate
                
                # Apply filters
                if ($global:FilterSettings.Class) {
                    $drivers = $drivers | Where-Object { $_.Class -like "*$($global:FilterSettings.Class)*" }
                }
                if ($global:FilterSettings.Manufacturer) {
                    $drivers = $drivers | Where-Object { $_.Manufacturer -like "*$($global:FilterSettings.Manufacturer)*" }
                }
                
                Write-SilentLog "Found $($drivers.Count) drivers"
                $csvPath = Join-Path $LogBase "InstalledDrivers_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"
                $drivers | Export-Csv -Path $csvPath -NoTypeInformation -Encoding UTF8
                Write-SilentLog "Exported to: $csvPath"
                Add-HistoryEntry -TaskName "ScanDrivers" -Status "Completed" -Details "Found $($drivers.Count) drivers"
            } catch {
                Write-SilentLog "Error: $_"
                Add-HistoryEntry -TaskName "ScanDrivers" -Status "Failed" -Details $_.Exception.Message
            }
        }
        default {
            Write-SilentLog "Unknown task: $Task"
            Add-HistoryEntry -TaskName $Task -Status "Failed" -Details "Unknown task"
        }
    }
    
    Write-SilentLog "Silent mode completed"
    exit 0
}

# -------------------------
# Helper Functions
# -------------------------
function New-TaskLog([string]$taskName) {
    $ts = (Get-Date).ToString("yyyyMMdd_HHmmss")
    $logFile = Join-Path $LogBase "$($taskName)_$ts.log"
    New-Item -Path $logFile -ItemType File -Force | Out-Null
    return $logFile
}

function Add-StatusUI {
    param($form, $statusControl, $text)
    if ($form -and $statusControl) {
        $method = [System.Windows.Forms.MethodInvoker]{
            $statusControl.AppendText("$text`r`n")
            $statusControl.ScrollToCaret()
        }
        $form.Invoke($method)
    }
}

# -------------------------
# Modern UI Color Scheme
# -------------------------
$global:UIColors = @{
    # Dark Theme
    Dark = @{
        Background = [System.Drawing.Color]::FromArgb(18, 18, 18)
        Surface = [System.Drawing.Color]::FromArgb(30, 30, 30)
        SurfaceHover = [System.Drawing.Color]::FromArgb(45, 45, 45)
        Primary = [System.Drawing.Color]::FromArgb(0, 150, 136)  # Teal accent
        PrimaryHover = [System.Drawing.Color]::FromArgb(0, 180, 165)
        Secondary = [System.Drawing.Color]::FromArgb(66, 66, 66)
        Text = [System.Drawing.Color]::FromArgb(240, 240, 240)
        TextSecondary = [System.Drawing.Color]::FromArgb(170, 170, 170)
        Border = [System.Drawing.Color]::FromArgb(60, 60, 60)
        Success = [System.Drawing.Color]::FromArgb(76, 175, 80)
        Warning = [System.Drawing.Color]::FromArgb(255, 152, 0)
        Error = [System.Drawing.Color]::FromArgb(244, 67, 54)
        MenuBar = [System.Drawing.Color]::FromArgb(25, 25, 25)
        StatusBar = [System.Drawing.Color]::FromArgb(0, 120, 108)
    }
    # Light Theme
    Light = @{
        Background = [System.Drawing.Color]::FromArgb(255, 255, 255)
        Surface = [System.Drawing.Color]::FromArgb(245, 247, 250)
        SurfaceHover = [System.Drawing.Color]::FromArgb(235, 238, 242)
        Primary = [System.Drawing.Color]::FromArgb(0, 137, 123)  # Teal accent
        PrimaryHover = [System.Drawing.Color]::FromArgb(0, 150, 136)
        Secondary = [System.Drawing.Color]::FromArgb(224, 224, 224)
        Text = [System.Drawing.Color]::FromArgb(33, 33, 33)
        TextSecondary = [System.Drawing.Color]::FromArgb(117, 117, 117)
        Border = [System.Drawing.Color]::FromArgb(224, 224, 224)
        Success = [System.Drawing.Color]::FromArgb(67, 160, 71)
        Warning = [System.Drawing.Color]::FromArgb(251, 140, 0)
        Error = [System.Drawing.Color]::FromArgb(229, 57, 53)
        MenuBar = [System.Drawing.Color]::FromArgb(255, 255, 255)
        StatusBar = [System.Drawing.Color]::FromArgb(0, 137, 123)
    }
}

function Get-ThemeColors {
    if ($global:DarkModeEnabled) { return $global:UIColors.Dark }
    return $global:UIColors.Light
}

# -------------------------
# Build Form
# -------------------------
$form = New-Object Windows.Forms.Form
$form.Text = $AppTitle
$form.Size = '1050,720'
$form.MinimumSize = '1050,720'
$form.StartPosition = "CenterScreen"
$form.Font = New-Object Drawing.Font("Segoe UI", 9.5)

# -------------------------
# Menu Strip
# -------------------------
$menuStrip = New-Object Windows.Forms.MenuStrip
$menuStrip.Padding = '6,2,0,2'

# File Menu
$menuFile = New-Object Windows.Forms.ToolStripMenuItem
$menuFile.Text = "&File"

$menuOpenLogs = New-Object Windows.Forms.ToolStripMenuItem
$menuOpenLogs.Text = (Get-LocalizedString "BtnOpenLogs")
$menuOpenLogs.ShortcutKeys = [System.Windows.Forms.Keys]::Control -bor [System.Windows.Forms.Keys]::L

$menuSeparator1 = New-Object Windows.Forms.ToolStripSeparator

$menuExit = New-Object Windows.Forms.ToolStripMenuItem
$menuExit.Text = "Exit"
$menuExit.ShortcutKeys = [System.Windows.Forms.Keys]::Alt -bor [System.Windows.Forms.Keys]::F4

$menuFile.DropDownItems.AddRange(@($menuOpenLogs, $menuSeparator1, $menuExit))

# Actions Menu
$menuActions = New-Object Windows.Forms.ToolStripMenuItem
$menuActions.Text = "&Actions"

$menuWU = New-Object Windows.Forms.ToolStripMenuItem
$menuWU.Text = (Get-LocalizedString "BtnWU")
$menuWU.ShortcutKeys = [System.Windows.Forms.Keys]::F5

$menuCheckUpdates = New-Object Windows.Forms.ToolStripMenuItem
$menuCheckUpdates.Text = (Get-LocalizedString "BtnCheckUpdates")
$menuCheckUpdates.ShortcutKeys = [System.Windows.Forms.Keys]::F6

$menuScan = New-Object Windows.Forms.ToolStripMenuItem
$menuScan.Text = (Get-LocalizedString "BtnScan")
$menuScan.ShortcutKeys = [System.Windows.Forms.Keys]::F7

$menuSeparator2 = New-Object Windows.Forms.ToolStripSeparator

$menuBackup = New-Object Windows.Forms.ToolStripMenuItem
$menuBackup.Text = (Get-LocalizedString "BtnBackup")
$menuBackup.ShortcutKeys = [System.Windows.Forms.Keys]::Control -bor [System.Windows.Forms.Keys]::B

$menuInstall = New-Object Windows.Forms.ToolStripMenuItem
$menuInstall.Text = (Get-LocalizedString "BtnInstall")
$menuInstall.ShortcutKeys = [System.Windows.Forms.Keys]::Control -bor [System.Windows.Forms.Keys]::I

$menuSeparator3 = New-Object Windows.Forms.ToolStripSeparator

$menuCancel = New-Object Windows.Forms.ToolStripMenuItem
$menuCancel.Text = (Get-LocalizedString "BtnCancel")
$menuCancel.ShortcutKeys = [System.Windows.Forms.Keys]::Control -bor [System.Windows.Forms.Keys]::Q

$menuActions.DropDownItems.AddRange(@($menuWU, $menuCheckUpdates, $menuScan, $menuSeparator2, $menuBackup, $menuInstall, $menuSeparator3, $menuCancel))

# Tools Menu
$menuTools = New-Object Windows.Forms.ToolStripMenuItem
$menuTools.Text = "&Tools"

$menuRestorePoint = New-Object Windows.Forms.ToolStripMenuItem
$menuRestorePoint.Text = (Get-LocalizedString "BtnRestorePoint")

$menuSchedule = New-Object Windows.Forms.ToolStripMenuItem
$menuSchedule.Text = (Get-LocalizedString "BtnSchedule")

$menuFilters = New-Object Windows.Forms.ToolStripMenuItem
$menuFilters.Text = (Get-LocalizedString "BtnFilters")

$menuSeparator4 = New-Object Windows.Forms.ToolStripSeparator

$menuHistory = New-Object Windows.Forms.ToolStripMenuItem
$menuHistory.Text = (Get-LocalizedString "BtnHistory")
$menuHistory.ShortcutKeys = [System.Windows.Forms.Keys]::Control -bor [System.Windows.Forms.Keys]::H

$menuTools.DropDownItems.AddRange(@($menuRestorePoint, $menuSchedule, $menuFilters, $menuSeparator4, $menuHistory))

# View Menu
$menuView = New-Object Windows.Forms.ToolStripMenuItem
$menuView.Text = "&View"

$menuToggleTheme = New-Object Windows.Forms.ToolStripMenuItem
$menuToggleTheme.Text = (Get-LocalizedString "BtnDarkMode")
$menuToggleTheme.ShortcutKeys = [System.Windows.Forms.Keys]::Control -bor [System.Windows.Forms.Keys]::T

$menuSeparator5 = New-Object Windows.Forms.ToolStripSeparator

# Language submenu
$menuLanguage = New-Object Windows.Forms.ToolStripMenuItem
$menuLanguage.Text = "Language"

$langItems = @("English (en)", "Español (es)", "Français (fr)", "Deutsch (de)", "Português (pt)", "Italiano (it)")
$langCodes = @("en", "es", "fr", "de", "pt", "it")
for ($i = 0; $i -lt $langItems.Count; $i++) {
    $langMenuItem = New-Object Windows.Forms.ToolStripMenuItem
    $langMenuItem.Text = $langItems[$i]
    $langMenuItem.Tag = $langCodes[$i]
    if ($langCodes[$i] -eq $global:CurrentLanguage) {
        $langMenuItem.Checked = $true
    }
    $menuLanguage.DropDownItems.Add($langMenuItem) | Out-Null
}

$menuView.DropDownItems.AddRange(@($menuToggleTheme, $menuSeparator5, $menuLanguage))

# Settings Menu
$menuSettingsTop = New-Object Windows.Forms.ToolStripMenuItem
$menuSettingsTop.Text = "&Settings"
$menuSettingsTop.ShortcutKeys = [System.Windows.Forms.Keys]::Control -bor [System.Windows.Forms.Keys]::Oemcomma

$menuStrip.Items.AddRange(@($menuFile, $menuActions, $menuTools, $menuView, $menuSettingsTop))

# -------------------------
# Toolbar Panel
# -------------------------
$toolbarPanel = New-Object Windows.Forms.Panel
$toolbarPanel.Dock = 'Top'
$toolbarPanel.Height = 56
# Note: toolbarPanel and menuStrip are added later for correct dock order

# FlowLayoutPanel for centered buttons
$buttonContainer = New-Object Windows.Forms.FlowLayoutPanel
$buttonContainer.Dock = 'Fill'
$buttonContainer.FlowDirection = 'LeftToRight'
$buttonContainer.WrapContents = $false
$buttonContainer.AutoSize = $false
$buttonContainer.Padding = '0,8,0,8'
$toolbarPanel.Controls.Add($buttonContainer)

# Function to center buttons when form resizes
function Update-ButtonContainerPadding {
    $totalButtonWidth = 155 + 155 + 155 + 120 + 140 + 110 + (5 * 12)  # buttons + gaps
    $availableWidth = $toolbarPanel.ClientSize.Width
    $leftPadding = [Math]::Max(0, [int](($availableWidth - $totalButtonWidth) / 2))
    $buttonContainer.Padding = "$leftPadding,8,0,8"
}

# Modern Button Style
function New-RoundedRegion {
    param([int]$Width, [int]$Height, [int]$Radius = 8)
    $path = New-Object System.Drawing.Drawing2D.GraphicsPath
    $r = $Radius
    $w = $Width
    $h = $Height
    # Top-left arc
    $path.AddArc(0, 0, $r * 2, $r * 2, 180, 90)
    # Top-right arc
    $path.AddArc($w - $r * 2, 0, $r * 2, $r * 2, 270, 90)
    # Bottom-right arc
    $path.AddArc($w - $r * 2, $h - $r * 2, $r * 2, $r * 2, 0, 90)
    # Bottom-left arc
    $path.AddArc(0, $h - $r * 2, $r * 2, $r * 2, 90, 90)
    $path.CloseFigure()
    return New-Object System.Drawing.Region($path)
}

function New-ModernButton {
    param(
        [string]$Text,
        [int]$Width = 130,
        [bool]$Primary = $false,
        [string]$IconChar = ""
    )
    $btn = New-Object System.Windows.Forms.Button
    $btn.Text = if ($IconChar) { "$IconChar  $Text" } else { $Text }
    $btn.Width = $Width
    $btn.Height = 38
    $btn.FlatStyle = "Flat"
    $btn.FlatAppearance.BorderSize = 0
    $btn.Cursor = [System.Windows.Forms.Cursors]::Hand
    $btn.Font = New-Object Drawing.Font("Segoe UI Semibold", 9)
    $btn.Tag = $Primary
    $btn.TextAlign = 'MiddleCenter'
    
    # Apply rounded corners
    $btn.Region = New-RoundedRegion -Width $Width -Height 38 -Radius 6
    
    return $btn
}

# Create toolbar buttons with margins for spacing
$btnWU = New-ModernButton -Text (Get-LocalizedString "BtnWU") -Width 155 -Primary $true
$btnWU.Margin = '0,0,12,0'
$btnCheckUpdates = New-ModernButton -Text (Get-LocalizedString "BtnCheckUpdates") -Width 155 -Primary $true
$btnCheckUpdates.Margin = '0,0,12,0'
$btnScan = New-ModernButton -Text (Get-LocalizedString "BtnScan") -Width 155 -Primary $true
$btnScan.Margin = '0,0,12,0'
$btnBackup = New-ModernButton -Text (Get-LocalizedString "BtnBackup") -Width 120
$btnBackup.Margin = '0,0,12,0'
$btnInstall = New-ModernButton -Text (Get-LocalizedString "BtnInstall") -Width 140
$btnInstall.Margin = '0,0,12,0'
$btnCancel = New-ModernButton -Text (Get-LocalizedString "BtnCancel") -Width 110
$btnCancel.Margin = '0,0,0,0'

# Add buttons to centered container
$buttonContainer.Controls.AddRange(@($btnWU, $btnCheckUpdates, $btnScan, $btnBackup, $btnInstall, $btnCancel))

# -------------------------
# Toolbar Separator (created here, added later for correct dock order)
# -------------------------
$toolbarSeparator = New-Object Windows.Forms.Panel
$toolbarSeparator.Dock = 'Top'
$toolbarSeparator.Height = 1

# -------------------------
# Status Bar
# -------------------------
$statusBar = New-Object Windows.Forms.Panel
$statusBar.Dock = 'Bottom'
$statusBar.Height = 28

$statusLabel = New-Object Windows.Forms.Label
$statusLabel.Text = "  Ready"
$statusLabel.Dock = 'Left'
$statusLabel.Width = 600
$statusLabel.TextAlign = 'MiddleLeft'
$statusLabel.Font = New-Object Drawing.Font("Segoe UI", 9)
$statusBar.Controls.Add($statusLabel)

$versionLabel = New-Object Windows.Forms.Label
$versionLabel.Text = "v3.0  "
$versionLabel.Dock = 'Right'
$versionLabel.Width = 60
$versionLabel.TextAlign = 'MiddleRight'
$versionLabel.Font = New-Object Drawing.Font("Segoe UI", 8.5)
$statusBar.Controls.Add($versionLabel)

# -------------------------
# Main Content Container
# -------------------------
$contentPanel = New-Object Windows.Forms.Panel
$contentPanel.Dock = 'Fill'
$contentPanel.Padding = '16,16,16,8'

# Add controls in correct order for docking
# Windows Forms docks controls in reverse order (last added = first docked)
# Order: Fill first, then Bottom, then Top (in reverse visual order)
$form.Controls.Add($contentPanel)    # Fill - takes remaining space
$form.Controls.Add($statusBar)       # Bottom
$form.Controls.Add($toolbarSeparator) # Top - appears below toolbar
$form.Controls.Add($toolbarPanel)    # Top - appears below menu
$form.Controls.Add($menuStrip)       # Top - appears at very top
$form.MainMenuStrip = $menuStrip

# Status container panel (acts as border)
$statusBorderPanel = New-Object Windows.Forms.Panel
$statusBorderPanel.Dock = 'Fill'
$statusBorderPanel.Padding = '1,1,1,1'
$contentPanel.Controls.Add($statusBorderPanel)

# Status RichTextBox with modern styling
$status = New-Object Windows.Forms.RichTextBox
$status.Multiline = $true
$status.ReadOnly = $true
$status.Dock = 'Fill'
$status.ScrollBars = 'Vertical'
$status.BorderStyle = 'None'
$status.Font = New-Object Drawing.Font("Cascadia Code, Consolas, Courier New", 9.5)
$statusBorderPanel.Controls.Add($status)

# Progress Panel (Dock Bottom - add after Fill so it appears at bottom)
$progressPanel = New-Object Windows.Forms.Panel
$progressPanel.Dock = 'Bottom'
$progressPanel.Height = 36
$progressPanel.Padding = '0,8,0,8'
$contentPanel.Controls.Add($progressPanel)

# Progress bar border panel
$progressBorderPanel = New-Object Windows.Forms.Panel
$progressBorderPanel.Dock = 'Fill'
$progressBorderPanel.Padding = '1,1,1,1'
$progressPanel.Controls.Add($progressBorderPanel)

# Modern Progress Bar
$progress = New-Object Windows.Forms.ProgressBar
$progress.Dock = 'Fill'
$progress.Style = 'Continuous'
$progress.Value = 0
$progressBorderPanel.Controls.Add($progress)

# Header Label (Dock Top - add last so it appears at top)
$headerLabel = New-Object Windows.Forms.Label
$headerLabel.Text = "Output Console"
$headerLabel.Dock = 'Top'
$headerLabel.Height = 26
$headerLabel.Font = New-Object Drawing.Font("Segoe UI Semibold", 9.5)
$headerLabel.TextAlign = 'MiddleLeft'
$contentPanel.Controls.Add($headerLabel)

# Language combobox for compatibility
$cmbLang = New-Object Windows.Forms.ComboBox
$cmbLang.Items.AddRange(@("en", "es", "fr", "de", "pt", "it"))
$cmbLang.SelectedItem = $global:CurrentLanguage

# DataGrid for drivers result (hidden initially)
$driversGrid = New-Object Windows.Forms.DataGridView
$driversGrid.ReadOnly = $true
$driversGrid.AllowUserToAddRows = $false
$driversGrid.AllowUserToDeleteRows = $false
$driversGrid.Height = 60
$driversGrid.Visible = $false

# Timer to poll job/logs
$timer = New-Object Windows.Forms.Timer
$timer.Interval = 1000

# -------------------------
# Background job helpers
# -------------------------
function Start-BackgroundTask {
    param(
        [string]$Name,
        [array]$TaskArgs
    )
    if ($null -ne $global:CurrentJob -and (Get-Job -Id $global:CurrentJob.Id -ErrorAction SilentlyContinue)) {
        [System.Windows.Forms.MessageBox]::Show((Get-LocalizedString "TaskRunning"), "Task Running", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        return $null
    }

    $log = New-TaskLog $Name
    $global:CurrentTaskLog = $log
    Add-StatusUI $form $status ("$(Get-LocalizedString 'StartingTask') $Name")

    # Pass filter settings to job
    $filterClass = $global:FilterSettings.Class
    $filterMfr = $global:FilterSettings.Manufacturer

    # Start job with task logic defined directly in the job
    $job = Start-Job -Name $Name -ScriptBlock {
        param($taskName, $logPath, $innerArgs, $filterClass, $filterMfr)
        
        # Logging function
        function L($m) {
            $t = (Get-Date).ToString("s")
            Add-Content -Path $logPath -Value ("$t - $m")
        }
        
        try {
            # Execute task based on task name
            switch ($taskName) {
                "WindowsUpdate" {
                    L "Starting Windows Update process..."
                    try {
                        & wuauclt.exe /detectnow 2>&1 | Out-Null
                        L "[1/4] Update detection triggered"
                    } catch { 
                        L "[ERROR] Detection failed: $_"
                        L "Completed"
                        return
                    }
                    Start-Sleep -Seconds 3
                    
                    try {
                        $proc = Start-Process -FilePath "usoclient.exe" -ArgumentList "StartScan" -NoNewWindow -Wait -PassThru -ErrorAction Stop
                        L "[2/4] Scanning for updates..."
                        if ($proc.ExitCode -ne 0) {
                            L "  (No updates found or scan in progress)"
                        }
                    } catch { 
                        L "[ERROR] Scan failed: $_"
                        L "Completed"
                        return
                    }
                    Start-Sleep -Seconds 3
                    
                    try {
                        $proc = Start-Process -FilePath "usoclient.exe" -ArgumentList "StartDownload" -NoNewWindow -Wait -PassThru -ErrorAction Stop
                        if ($proc.ExitCode -eq 0) {
                            L "[3/4] Downloading updates..."
                        } else {
                            L "[3/4] No updates to download (system may be up to date)"
                        }
                    } catch { 
                        L "[ERROR] Download failed: $_"
                        L "Completed"
                        return
                    }
                    Start-Sleep -Seconds 3
                    
                    try {
                        $proc = Start-Process -FilePath "usoclient.exe" -ArgumentList "StartInstall" -NoNewWindow -Wait -PassThru -ErrorAction Stop
                        if ($proc.ExitCode -eq 0) {
                            L "[4/4] Installing updates..."
                        } else {
                            L "[4/4] No updates to install (system may be up to date)"
                        }
                    } catch { 
                        L "[ERROR] Installation failed: $_"
                        L "Completed"
                        return
                    }
                    L ""
                    L "Windows Update process completed successfully!"
                    L "Check Settings -> Windows Update for detailed status."
                    L "Completed"
                }
                "CheckDriverUpdates" {
                    L "Checking for available driver updates..."
                    try {
                        $UpdateSession = New-Object -ComObject Microsoft.Update.Session
                        $UpdateSearcher = $UpdateSession.CreateUpdateSearcher()
                        L "Searching Windows Update (this may take a minute)..."
                        $SearchResult = $UpdateSearcher.Search("IsInstalled=0 and Type='Driver'")
                        
                        L ""
                        if ($SearchResult.Updates.Count -eq 0) {
                            L "No driver updates available. Your system is up to date!"
                        } else {
                            L "Found $($SearchResult.Updates.Count) driver update(s) available:"
                            L ""
                            $updateNum = 1
                            foreach ($Update in $SearchResult.Updates) {
                                # Apply filters if set
                                $showUpdate = $true
                                if ($filterMfr -and $Update.DriverProvider) {
                                    if ($Update.DriverProvider -notlike "*$filterMfr*") { $showUpdate = $false }
                                }
                                
                                if ($showUpdate) {
                                    L "$updateNum. $($Update.Title)"
                                    if ($Update.DriverProvider) { L "   Provider: $($Update.DriverProvider)" }
                                    if ($Update.MaxDownloadSize -gt 0) { 
                                        L "   Size: $([math]::Round($Update.MaxDownloadSize / 1MB, 2)) MB" 
                                    }
                                    $updateNum++
                                }
                            }
                            L ""
                            L "To install: Use 'Check Windows Update' button or go to Settings -> Windows Update"
                        }
                    } catch {
                        L "[ERROR] Failed to check for updates: $_"
                        L "Ensure Windows Update service is running."
                    }
                    L "Completed"
                }
                "ScanDrivers" {
                    L "Scanning installed drivers..."
                    try {
                        $drivers = Get-CimInstance Win32_PnPSignedDriver | Select-Object DeviceName, Manufacturer, DriverVersion, InfName, Class, DriverDate
                        
                        # Apply filters
                        if ($filterClass) {
                            L "Applying class filter: $filterClass"
                            $drivers = $drivers | Where-Object { $_.Class -like "*$filterClass*" }
                        }
                        if ($filterMfr) {
                            L "Applying manufacturer filter: $filterMfr"
                            $drivers = $drivers | Where-Object { $_.Manufacturer -like "*$filterMfr*" }
                        }
                        
                        L "Found $($drivers.Count) driver(s) matching criteria"
                        
                        # Group by class
                        $driversByClass = $drivers | Group-Object -Property Class
                        L "Categories: $($driversByClass.Count) different driver types"
                        
                        L ""
                        L "Sample drivers:"
                        $sampleCount = [Math]::Min(5, $drivers.Count)
                        $drivers | Sort-Object DeviceName | Select-Object -First $sampleCount | ForEach-Object {
                            L "  * $($_.DeviceName) (v$($_.DriverVersion))"
                        }
                        if ($drivers.Count -gt $sampleCount) {
                            L "  ... and $($drivers.Count - $sampleCount) more"
                        }
                        
                        L ""
                        L "Exporting full list to CSV..."
                        $csvPath = Join-Path (Split-Path $logPath) "InstalledDrivers_$((Get-Date).ToString('yyyyMMdd_HHmmss')).csv"
                        $drivers | Sort-Object DeviceName | Export-Csv -Path $csvPath -NoTypeInformation -Encoding UTF8
                        L "Exported to: $csvPath"
                        L "Completed"
                    } catch {
                        L "[ERROR] Failed to scan drivers: $_"
                    }
                }
                "BackupDrivers" {
                    $dest = $innerArgs[0]
                    L "Backing up drivers to: $dest"
                    try {
                        if (!(Test-Path $dest)) { 
                            New-Item -ItemType Directory -Path $dest -Force | Out-Null
                        }
                        L "Exporting drivers (this may take several minutes)..."
                        & dism.exe /online /export-driver /destination:$dest 2>&1 | Out-Null
                        $exportedCount = (Get-ChildItem -Path $dest -Recurse -Directory -ErrorAction SilentlyContinue).Count
                        if ($exportedCount -gt 0) {
                            L "Backup completed: $exportedCount driver package(s) exported"
                        } else {
                            L "Backup completed. Check destination folder for exported drivers."
                        }
                    } catch {
                        L "[ERROR] Backup failed: $_"
                    }
                    L "Completed"
                }
                "InstallDrivers" {
                    $folder = $innerArgs[0]
                    L "Installing drivers from: $folder"
                    try {
                        if (-not (Test-Path $folder)) {
                            L "[ERROR] Folder not found: $folder"
                            L "Completed"
                            return
                        }
                        $infFiles = Get-ChildItem -Path $folder -Recurse -Include *.inf -ErrorAction SilentlyContinue
                        if ($infFiles.Count -eq 0) {
                            L "[ERROR] No .inf driver files found in folder"
                            L "Completed"
                            return
                        }
                        
                        L "Found $($infFiles.Count) driver file(s)"
                        L "Installing drivers..."
                        L ""
                        $successCount = 0
                        $failCount = 0
                        $current = 0
                        
                        foreach ($inf in $infFiles) {
                            $current++
                            L "[$current/$($infFiles.Count)] $($inf.Name)"
                            try {
                                $out = & pnputil.exe /add-driver $inf.FullName /install 2>&1
                                $hasError = $false
                                $out | ForEach-Object { 
                                    if ($_ -match "error|failed|fail" -and -not $hasError) {
                                        $hasError = $true
                                        $failCount++
                                    }
                                }
                                if (-not $hasError) {
                                    $successCount++
                                }
                            } catch {
                                $failCount++
                            }
                            Start-Sleep -Milliseconds 300
                        }
                        
                        L ""
                        L "Installation complete: $successCount successful, $failCount failed"
                        if ($successCount -gt 0) {
                            L "Note: Reboot may be required for some drivers."
                        }
                    } catch {
                        L "[ERROR] Installation failed: $_"
                    }
                    L "Completed"
                }
                default {
                    L "ERROR: Unknown task name: $taskName"
                }
            }
        } catch {
            L "ERROR in job: $_"
            if ($_.ScriptStackTrace) {
                L "Stack trace: $($_.ScriptStackTrace)"
            }
        }
    } -ArgumentList $Name, $log, $TaskArgs, $filterClass, $filterMfr -RunAs32:$false

    $global:CurrentJob = $job
    # start UI timer to tail log
    $timer.Start()
    return $job
}

# Tail log file content and update UI
$timer.Add_Tick({
    try {
        if ($global:CurrentTaskLog -and (Test-Path $global:CurrentTaskLog)) {
            $lines = Get-Content -Path $global:CurrentTaskLog -Tail 200 -ErrorAction SilentlyContinue
            if ($lines) {
                $text = ($lines -join "`r`n")
                # Update UI (replace full text)
                $invoke = [System.Windows.Forms.MethodInvoker]{
                    $status.Clear()
                    $status.AppendText($text + "`r`n")
                    $status.ScrollToCaret()
                }
                $form.Invoke($invoke)
            }
        }

        # Update progress heuristic with more detailed tracking
        if ($global:CurrentTaskLog -and (Test-Path $global:CurrentTaskLog)) {
            $content = Get-Content -Path $global:CurrentTaskLog -Tail 100 -ErrorAction SilentlyContinue
            $contentStr = $content -join "`n"
            $p = 0
            
            # Windows Update progress
            if ($contentStr -match "\[1/4\]") { $p = 25 }
            if ($contentStr -match "\[2/4\]") { $p = 50 }
            if ($contentStr -match "\[3/4\]") { $p = 75 }
            if ($contentStr -match "\[4/4\]") { $p = 90 }
            
            # Driver update check progress
            if ($contentStr -match "Searching Windows Update") { $p = 30 }
            if ($contentStr -match "Found.*driver update") { $p = 80 }
            
            # Scan drivers progress
            if ($contentStr -match "Scanning installed") { $p = 30 }
            if ($contentStr -match "Found.*driver.*matching") { $p = 60 }
            if ($contentStr -match "Exporting full list") { $p = 80 }
            
            # Backup drivers progress
            if ($contentStr -match "Exporting drivers") { $p = 40 }
            if ($contentStr -match "Backup completed") { $p = 90 }
            
            # Install drivers progress
            if ($contentStr -match "Found.*driver file") { $p = 20 }
            if ($contentStr -match "\[.*\/.*\]") {
                # Extract progress from [X/Y] format
                if ($contentStr -match "\[(\d+)\/(\d+)\]") {
                    $current = [int]$matches[1]
                    $total = [int]$matches[2]
                    if ($total -gt 0) {
                        $p = 20 + [int](($current / $total) * 70)
                    }
                }
            }
            
            # Generic progress indicators
            if ($p -eq 0) {
                if ($contentStr -match "Starting") { $p = 10 }
            }
            
            if ($contentStr -match "Completed") { $p = 100 }
            
            $progress.Value = [Math]::Min(100, [int]$p)
        }

        # Check job finished
        if ($null -ne $global:CurrentJob) {
            $jobState = (Get-Job -Id $global:CurrentJob.Id -ErrorAction SilentlyContinue).State
            if ($jobState -in @("Completed","Failed","Stopped","Disconnected","Blocked","Suspended","Aborted")) {
                Start-Sleep -Milliseconds 200
                # Log to history
                $taskName = $global:CurrentJob.Name
                Add-HistoryEntry -TaskName $taskName -Status $jobState -Details "Task completed"
                
                # pull final output and mark complete
                $finishedText = Get-LocalizedString 'TaskFinished'
                $invoke = [System.Windows.Forms.MethodInvoker]{
                    $status.AppendText("`r`n$finishedText $jobState ===`r`n")
                    $status.ScrollToCaret()
                    $progress.Value = 100
                    $statusLabel.Text = "  Task completed: $jobState"
                }
                $form.Invoke($invoke)
                # cleanup job object
                Remove-Job -Id $global:CurrentJob.Id -Force -ErrorAction SilentlyContinue
                $global:CurrentJob = $null
                $timer.Stop()
            }
        }
    } catch {
        # ignore UI timer exceptions
    }
})

# -------------------------
# Theme Functions
# -------------------------
function Set-Theme {
    param([bool]$Dark)
    $global:DarkModeEnabled = $Dark
    $colors = Get-ThemeColors
    
    # Main form
    $form.BackColor = $colors.Background
    
    # Menu strip
    $menuStrip.BackColor = $colors.MenuBar
    $menuStrip.ForeColor = $colors.Text
    foreach ($item in $menuStrip.Items) {
        $item.BackColor = $colors.MenuBar
        $item.ForeColor = $colors.Text
    }
    
    # Toolbar
    $toolbarPanel.BackColor = $colors.Surface
    $buttonContainer.BackColor = $colors.Surface
    
    # Toolbar separator
    $toolbarSeparator.BackColor = $colors.Border
    
    # Style toolbar buttons
    foreach ($ctrl in $buttonContainer.Controls) {
        if ($ctrl -is [System.Windows.Forms.Button]) {
            if ($ctrl.Tag -eq $true) {
                # Primary buttons
                $ctrl.BackColor = $colors.Primary
                $ctrl.ForeColor = [System.Drawing.Color]::White
                $ctrl.FlatAppearance.MouseOverBackColor = $colors.PrimaryHover
            } else {
                # Secondary buttons
                $ctrl.BackColor = $colors.Secondary
                $ctrl.ForeColor = $colors.Text
                $ctrl.FlatAppearance.MouseOverBackColor = $colors.SurfaceHover
            }
        }
    }
    
    # Content panel
    $contentPanel.BackColor = $colors.Background
    $headerLabel.BackColor = $colors.Background
    $headerLabel.ForeColor = $colors.TextSecondary
    
    # Status textbox with border
    $statusBorderPanel.BackColor = $colors.Border
    $status.BackColor = $colors.Surface
    $status.ForeColor = $colors.Text
    
    # Progress panel with border
    $progressPanel.BackColor = $colors.Background
    $progressBorderPanel.BackColor = $colors.Border
    
    # Status bar
    $statusBar.BackColor = $colors.StatusBar
    $statusLabel.BackColor = $colors.StatusBar
    $statusLabel.ForeColor = [System.Drawing.Color]::White
    $versionLabel.BackColor = $colors.StatusBar
    $versionLabel.ForeColor = [System.Drawing.Color]::FromArgb(200, 255, 255, 255)
    
    # Update menu theme text
    if ($Dark) {
        $menuToggleTheme.Text = Get-LocalizedString "BtnLightMode"
    } else {
        $menuToggleTheme.Text = Get-LocalizedString "BtnDarkMode"
    }
    
    Export-Settings
}

# -------------------------
# Update UI Language
# -------------------------
function Update-UILanguage {
    $form.Text = Get-LocalizedString "AppTitle"
    
    # Toolbar buttons
    $btnWU.Text = Get-LocalizedString "BtnWU"
    $btnCheckUpdates.Text = Get-LocalizedString "BtnCheckUpdates"
    $btnScan.Text = Get-LocalizedString "BtnScan"
    $btnBackup.Text = Get-LocalizedString "BtnBackup"
    $btnInstall.Text = Get-LocalizedString "BtnInstall"
    $btnCancel.Text = Get-LocalizedString "BtnCancel"
    
    # Menu items
    $menuOpenLogs.Text = Get-LocalizedString "BtnOpenLogs"
    $menuWU.Text = Get-LocalizedString "BtnWU"
    $menuCheckUpdates.Text = Get-LocalizedString "BtnCheckUpdates"
    $menuScan.Text = Get-LocalizedString "BtnScan"
    $menuBackup.Text = Get-LocalizedString "BtnBackup"
    $menuInstall.Text = Get-LocalizedString "BtnInstall"
    $menuCancel.Text = Get-LocalizedString "BtnCancel"
    $menuRestorePoint.Text = Get-LocalizedString "BtnRestorePoint"
    $menuSchedule.Text = Get-LocalizedString "BtnSchedule"
    $menuFilters.Text = Get-LocalizedString "BtnFilters"
    $menuHistory.Text = Get-LocalizedString "BtnHistory"
    
    if ($global:DarkModeEnabled) {
        $menuToggleTheme.Text = Get-LocalizedString "BtnLightMode"
    } else {
        $menuToggleTheme.Text = Get-LocalizedString "BtnDarkMode"
    }
    
    # Update language menu checkmarks
    foreach ($item in $menuLanguage.DropDownItems) {
        $item.Checked = ($item.Tag -eq $global:CurrentLanguage)
    }
}

# -------------------------
# Dialog Functions
# -------------------------
function Show-HistoryDialog {
    $colors = Get-ThemeColors
    
    $historyForm = New-Object Windows.Forms.Form
    $historyForm.Text = Get-LocalizedString "HistoryTitle"
    $historyForm.Size = '750,500'
    $historyForm.StartPosition = "CenterParent"
    $historyForm.BackColor = $colors.Background
    $historyForm.TopMost = $true
    $historyForm.Font = New-Object Drawing.Font("Segoe UI", 9.5)
    $historyForm.FormBorderStyle = 'FixedDialog'
    $historyForm.MaximizeBox = $false
    
    # Header
    $header = New-Object Windows.Forms.Label
    $header.Text = Get-LocalizedString "HistoryTitle"
    $header.Dock = 'Top'
    $header.Height = 45
    $header.BackColor = $colors.Primary
    $header.ForeColor = [System.Drawing.Color]::White
    $header.Font = New-Object Drawing.Font("Segoe UI Semibold", 12)
    $header.TextAlign = 'MiddleCenter'
    
    $historyList = New-Object Windows.Forms.ListView
    $historyList.Dock = 'Fill'
    $historyList.View = 'Details'
    $historyList.FullRowSelect = $true
    $historyList.GridLines = $false
    $historyList.BackColor = $colors.Surface
    $historyList.ForeColor = $colors.Text
    $historyList.BorderStyle = 'None'
    $historyList.Font = New-Object Drawing.Font("Segoe UI", 9)
    
    $historyList.Columns.Add("Timestamp", 160) | Out-Null
    $historyList.Columns.Add("Task", 140) | Out-Null
    $historyList.Columns.Add("Status", 100) | Out-Null
    $historyList.Columns.Add("Details", 300) | Out-Null
    
    $history = Get-UpdateHistory
    if ($history) {
        foreach ($entry in $history) {
            $item = New-Object Windows.Forms.ListViewItem($entry.Timestamp)
            $item.SubItems.Add($entry.Task) | Out-Null
            $item.SubItems.Add($entry.Status) | Out-Null
            $item.SubItems.Add($entry.Details) | Out-Null
            $historyList.Items.Add($item) | Out-Null
        }
    }
    
    # Add controls in correct order: Fill first, then Top (reverse dock processing)
    $historyForm.Controls.Add($historyList)
    $historyForm.Controls.Add($header)
    $historyForm.ShowDialog($form) | Out-Null
}

function Show-ScheduleDialog {
    $colors = Get-ThemeColors
    
    $schedForm = New-Object Windows.Forms.Form
    $schedForm.Text = Get-LocalizedString "ScheduleTitle"
    $schedForm.Size = '420,300'
    $schedForm.StartPosition = "CenterParent"
    $schedForm.BackColor = $colors.Background
    $schedForm.FormBorderStyle = 'FixedDialog'
    $schedForm.MaximizeBox = $false
    $schedForm.TopMost = $true
    $schedForm.Font = New-Object Drawing.Font("Segoe UI", 9.5)
    
    # Header
    $header = New-Object Windows.Forms.Label
    $header.Text = Get-LocalizedString "ScheduleTitle"
    $header.Dock = 'Top'
    $header.Height = 45
    $header.BackColor = $colors.Primary
    $header.ForeColor = [System.Drawing.Color]::White
    $header.Font = New-Object Drawing.Font("Segoe UI Semibold", 12)
    $header.TextAlign = 'MiddleCenter'
    
    $contentPanel = New-Object Windows.Forms.Panel
    $contentPanel.Dock = 'Fill'
    $contentPanel.Padding = '20,15,20,15'
    $contentPanel.BackColor = $colors.Surface
    
    # Add controls in correct order: Fill first, then Top (reverse dock processing)
    $schedForm.Controls.Add($contentPanel)
    $schedForm.Controls.Add($header)
    
    $lblFreq = New-Object Windows.Forms.Label
    $lblFreq.Text = "Frequency:"
    $lblFreq.Location = '0,10'
    $lblFreq.Size = '100,25'
    $lblFreq.ForeColor = $colors.Text
    $contentPanel.Controls.Add($lblFreq)
    
    $cmbFreq = New-Object Windows.Forms.ComboBox
    $cmbFreq.Location = '110,8'
    $cmbFreq.Size = '180,28'
    $cmbFreq.DropDownStyle = 'DropDownList'
    $cmbFreq.BackColor = $colors.Background
    $cmbFreq.ForeColor = $colors.Text
    $cmbFreq.Items.AddRange(@((Get-LocalizedString "Daily"), (Get-LocalizedString "Weekly"), (Get-LocalizedString "Monthly")))
    $cmbFreq.SelectedIndex = 0
    $contentPanel.Controls.Add($cmbFreq)
    
    $lblTime = New-Object Windows.Forms.Label
    $lblTime.Text = Get-LocalizedString "Time"
    $lblTime.Location = '0,50'
    $lblTime.Size = '100,25'
    $lblTime.ForeColor = $colors.Text
    $contentPanel.Controls.Add($lblTime)
    
    $txtTime = New-Object Windows.Forms.TextBox
    $txtTime.Location = '110,48'
    $txtTime.Size = '180,28'
    $txtTime.Text = "03:00"
    $txtTime.BackColor = $colors.Background
    $txtTime.ForeColor = $colors.Text
    $contentPanel.Controls.Add($txtTime)
    
    $existingTask = Get-ScheduledUpdateTask
    $lblStatus = New-Object Windows.Forms.Label
    $lblStatus.Location = '0,95'
    $lblStatus.Size = '350,25'
    $lblStatus.Font = New-Object Drawing.Font("Segoe UI Semibold", 9)
    if ($existingTask) {
        $lblStatus.Text = "Current schedule: Active"
        $lblStatus.ForeColor = $colors.Success
    } else {
        $lblStatus.Text = "No schedule configured"
        $lblStatus.ForeColor = $colors.TextSecondary
    }
    $contentPanel.Controls.Add($lblStatus)
    
    # Buttons panel
    $btnPanel = New-Object Windows.Forms.Panel
    $btnPanel.Location = '0,135'
    $btnPanel.Size = '360,40'
    $contentPanel.Controls.Add($btnPanel)
    
    $btnEnable = New-Object Windows.Forms.Button
    $btnEnable.Text = Get-LocalizedString "Enable"
    $btnEnable.Location = '0,0'
    $btnEnable.Size = '110,36'
    $btnEnable.FlatStyle = 'Flat'
    $btnEnable.FlatAppearance.BorderSize = 0
    $btnEnable.BackColor = $colors.Primary
    $btnEnable.ForeColor = [System.Drawing.Color]::White
    $btnEnable.Cursor = [System.Windows.Forms.Cursors]::Hand
    $btnEnable.Add_Click({
        $freqMap = @{
            (Get-LocalizedString "Daily") = "Daily"
            (Get-LocalizedString "Weekly") = "Weekly"
            (Get-LocalizedString "Monthly") = "Monthly"
        }
        $freq = $freqMap[$cmbFreq.SelectedItem]
        if (-not $freq) { $freq = "Daily" }
        if (Set-ScheduledUpdate -Frequency $freq -Time $txtTime.Text) {
            $lblStatus.Text = Get-LocalizedString "ScheduleCreated"
            $lblStatus.ForeColor = $colors.Success
        }
    })
    $btnPanel.Controls.Add($btnEnable)
    
    $btnRemove = New-Object Windows.Forms.Button
    $btnRemove.Text = Get-LocalizedString "Remove"
    $btnRemove.Location = '120,0'
    $btnRemove.Size = '120,36'
    $btnRemove.FlatStyle = 'Flat'
    $btnRemove.FlatAppearance.BorderSize = 0
    $btnRemove.BackColor = $colors.Secondary
    $btnRemove.ForeColor = $colors.Text
    $btnRemove.Cursor = [System.Windows.Forms.Cursors]::Hand
    $btnRemove.Add_Click({
        Remove-ScheduledUpdate
        $lblStatus.Text = Get-LocalizedString "ScheduleRemoved"
        $lblStatus.ForeColor = $colors.TextSecondary
    })
    $btnPanel.Controls.Add($btnRemove)
    
    $btnClose = New-Object Windows.Forms.Button
    $btnClose.Text = Get-LocalizedString "Close"
    $btnClose.Location = '250,0'
    $btnClose.Size = '100,36'
    $btnClose.FlatStyle = 'Flat'
    $btnClose.FlatAppearance.BorderSize = 0
    $btnClose.BackColor = $colors.Secondary
    $btnClose.ForeColor = $colors.Text
    $btnClose.Cursor = [System.Windows.Forms.Cursors]::Hand
    $btnClose.Add_Click({ $schedForm.Close() })
    $btnPanel.Controls.Add($btnClose)
    
    $schedForm.ShowDialog($form) | Out-Null
}

function Show-FiltersDialog {
    $colors = Get-ThemeColors
    
    $filterForm = New-Object Windows.Forms.Form
    $filterForm.Text = Get-LocalizedString "FilterTitle"
    $filterForm.Size = '420,260'
    $filterForm.StartPosition = "CenterParent"
    $filterForm.BackColor = $colors.Background
    $filterForm.FormBorderStyle = 'FixedDialog'
    $filterForm.MaximizeBox = $false
    $filterForm.TopMost = $true
    $filterForm.Font = New-Object Drawing.Font("Segoe UI", 9.5)
    
    # Header
    $header = New-Object Windows.Forms.Label
    $header.Text = Get-LocalizedString "FilterTitle"
    $header.Dock = 'Top'
    $header.Height = 45
    $header.BackColor = $colors.Primary
    $header.ForeColor = [System.Drawing.Color]::White
    $header.Font = New-Object Drawing.Font("Segoe UI Semibold", 12)
    $header.TextAlign = 'MiddleCenter'
    
    $contentPanel = New-Object Windows.Forms.Panel
    $contentPanel.Dock = 'Fill'
    $contentPanel.Padding = '20,15,20,15'
    $contentPanel.BackColor = $colors.Surface
    
    # Add controls in correct order: Fill first, then Top (reverse dock processing)
    $filterForm.Controls.Add($contentPanel)
    $filterForm.Controls.Add($header)
    
    $lblClass = New-Object Windows.Forms.Label
    $lblClass.Text = Get-LocalizedString "ClassFilter"
    $lblClass.Location = '0,10'
    $lblClass.Size = '160,25'
    $lblClass.ForeColor = $colors.Text
    $contentPanel.Controls.Add($lblClass)
    
    $txtClass = New-Object Windows.Forms.TextBox
    $txtClass.Location = '170,8'
    $txtClass.Size = '180,28'
    $txtClass.Text = $global:FilterSettings.Class
    $txtClass.BackColor = $colors.Background
    $txtClass.ForeColor = $colors.Text
    $contentPanel.Controls.Add($txtClass)
    
    $lblMfr = New-Object Windows.Forms.Label
    $lblMfr.Text = Get-LocalizedString "ManufacturerFilter"
    $lblMfr.Location = '0,50'
    $lblMfr.Size = '160,25'
    $lblMfr.ForeColor = $colors.Text
    $contentPanel.Controls.Add($lblMfr)
    
    $txtMfr = New-Object Windows.Forms.TextBox
    $txtMfr.Location = '170,48'
    $txtMfr.Size = '180,28'
    $txtMfr.Text = $global:FilterSettings.Manufacturer
    $txtMfr.BackColor = $colors.Background
    $txtMfr.ForeColor = $colors.Text
    $contentPanel.Controls.Add($txtMfr)
    
    # Buttons panel
    $btnPanel = New-Object Windows.Forms.Panel
    $btnPanel.Location = '0,100'
    $btnPanel.Size = '360,40'
    $contentPanel.Controls.Add($btnPanel)
    
    $btnApply = New-Object Windows.Forms.Button
    $btnApply.Text = Get-LocalizedString "Apply"
    $btnApply.Location = '0,0'
    $btnApply.Size = '110,36'
    $btnApply.FlatStyle = 'Flat'
    $btnApply.FlatAppearance.BorderSize = 0
    $btnApply.BackColor = $colors.Primary
    $btnApply.ForeColor = [System.Drawing.Color]::White
    $btnApply.Cursor = [System.Windows.Forms.Cursors]::Hand
    $btnApply.Add_Click({
        $global:FilterSettings.Class = $txtClass.Text
        $global:FilterSettings.Manufacturer = $txtMfr.Text
        Export-Settings
        Add-StatusUI $form $status "$(Get-LocalizedString 'FilterApplied') Class='$($txtClass.Text)', Manufacturer='$($txtMfr.Text)'"
        $filterForm.Close()
    })
    $btnPanel.Controls.Add($btnApply)
    
    $btnClear = New-Object Windows.Forms.Button
    $btnClear.Text = Get-LocalizedString "Clear"
    $btnClear.Location = '120,0'
    $btnClear.Size = '100,36'
    $btnClear.FlatStyle = 'Flat'
    $btnClear.FlatAppearance.BorderSize = 0
    $btnClear.BackColor = $colors.Secondary
    $btnClear.ForeColor = $colors.Text
    $btnClear.Cursor = [System.Windows.Forms.Cursors]::Hand
    $btnClear.Add_Click({
        $txtClass.Text = ""
        $txtMfr.Text = ""
        $global:FilterSettings.Class = ""
        $global:FilterSettings.Manufacturer = ""
        Export-Settings
        Add-StatusUI $form $status (Get-LocalizedString "FilterCleared")
    })
    $btnPanel.Controls.Add($btnClear)
    
    $btnClose = New-Object Windows.Forms.Button
    $btnClose.Text = Get-LocalizedString "Close"
    $btnClose.Location = '230,0'
    $btnClose.Size = '100,36'
    $btnClose.FlatStyle = 'Flat'
    $btnClose.FlatAppearance.BorderSize = 0
    $btnClose.BackColor = $colors.Secondary
    $btnClose.ForeColor = $colors.Text
    $btnClose.Cursor = [System.Windows.Forms.Cursors]::Hand
    $btnClose.Add_Click({ $filterForm.Close() })
    $btnPanel.Controls.Add($btnClose)
    
    $filterForm.ShowDialog($form) | Out-Null
}

function Show-SettingsDialog {
    $colors = Get-ThemeColors
    
    $settingsForm = New-Object Windows.Forms.Form
    $settingsForm.Text = Get-LocalizedString "SettingsTitle"
    $settingsForm.Size = '500,340'
    $settingsForm.StartPosition = "CenterParent"
    $settingsForm.BackColor = $colors.Background
    $settingsForm.FormBorderStyle = 'FixedDialog'
    $settingsForm.MaximizeBox = $false
    $settingsForm.TopMost = $true
    $settingsForm.Font = New-Object Drawing.Font("Segoe UI", 9.5)
    
    # Header
    $header = New-Object Windows.Forms.Label
    $header.Text = Get-LocalizedString "SettingsTitle"
    $header.Dock = 'Top'
    $header.Height = 45
    $header.BackColor = $colors.Primary
    $header.ForeColor = [System.Drawing.Color]::White
    $header.Font = New-Object Drawing.Font("Segoe UI Semibold", 12)
    $header.TextAlign = 'MiddleCenter'
    
    $contentPanel = New-Object Windows.Forms.Panel
    $contentPanel.Dock = 'Fill'
    $contentPanel.Padding = '20,15,20,15'
    $contentPanel.BackColor = $colors.Surface
    
    # Add controls in correct order: Fill first, then Top (reverse dock processing)
    $settingsForm.Controls.Add($contentPanel)
    $settingsForm.Controls.Add($header)
    
    # Proxy section
    $lblProxySection = New-Object Windows.Forms.Label
    $lblProxySection.Text = "Network Proxy"
    $lblProxySection.Location = '0,5'
    $lblProxySection.Size = '150,20'
    $lblProxySection.ForeColor = $colors.Primary
    $lblProxySection.Font = New-Object Drawing.Font("Segoe UI Semibold", 9.5)
    $contentPanel.Controls.Add($lblProxySection)
    
    $lblProxy = New-Object Windows.Forms.Label
    $lblProxy.Text = Get-LocalizedString "ProxyLabel"
    $lblProxy.Location = '0,35'
    $lblProxy.Size = '130,25'
    $lblProxy.ForeColor = $colors.Text
    $contentPanel.Controls.Add($lblProxy)
    
    $txtProxy = New-Object Windows.Forms.TextBox
    $txtProxy.Location = '140,33'
    $txtProxy.Size = '220,28'
    $txtProxy.Text = $global:ProxySettings.Address
    $txtProxy.BackColor = $colors.Background
    $txtProxy.ForeColor = $colors.Text
    $contentPanel.Controls.Add($txtProxy)
    
    $chkProxy = New-Object Windows.Forms.CheckBox
    $chkProxy.Text = Get-LocalizedString "Enable"
    $chkProxy.Location = '370,33'
    $chkProxy.Size = '80,25'
    $chkProxy.Checked = $global:ProxySettings.Enabled
    $chkProxy.ForeColor = $colors.Text
    $contentPanel.Controls.Add($chkProxy)
    
    $btnApplyProxy = New-Object Windows.Forms.Button
    $btnApplyProxy.Text = Get-LocalizedString "Apply"
    $btnApplyProxy.Location = '140,70'
    $btnApplyProxy.Size = '110,34'
    $btnApplyProxy.FlatStyle = 'Flat'
    $btnApplyProxy.FlatAppearance.BorderSize = 0
    $btnApplyProxy.BackColor = $colors.Primary
    $btnApplyProxy.ForeColor = [System.Drawing.Color]::White
    $btnApplyProxy.Cursor = [System.Windows.Forms.Cursors]::Hand
    $btnApplyProxy.Add_Click({
        Set-ProxySettings -ProxyAddr $txtProxy.Text -Enable $chkProxy.Checked
        if ($chkProxy.Checked -and $txtProxy.Text) {
            Add-StatusUI $form $status "$(Get-LocalizedString 'ProxyConfigured') $($txtProxy.Text)"
        } else {
            Add-StatusUI $form $status (Get-LocalizedString "ProxyCleared")
        }
    })
    $contentPanel.Controls.Add($btnApplyProxy)
    
    # Separator
    $separator = New-Object Windows.Forms.Label
    $separator.Location = '0,120'
    $separator.Size = '440,1'
    $separator.BackColor = $colors.Border
    $contentPanel.Controls.Add($separator)
    
    # Info section
    $lblInfoSection = New-Object Windows.Forms.Label
    $lblInfoSection.Text = "Application Info"
    $lblInfoSection.Location = '0,130'
    $lblInfoSection.Size = '150,20'
    $lblInfoSection.ForeColor = $colors.Primary
    $lblInfoSection.Font = New-Object Drawing.Font("Segoe UI Semibold", 9.5)
    $contentPanel.Controls.Add($lblInfoSection)
    
    $lblInfo = New-Object Windows.Forms.Label
    $lblInfo.Text = "Logs: $LogBase"
    $lblInfo.Location = '0,155'
    $lblInfo.Size = '440,20'
    $lblInfo.ForeColor = $colors.TextSecondary
    $lblInfo.Font = New-Object Drawing.Font("Segoe UI", 8.5)
    $contentPanel.Controls.Add($lblInfo)
    
    $lblInfo2 = New-Object Windows.Forms.Label
    $lblInfo2.Text = "Settings: $SettingsFile"
    $lblInfo2.Location = '0,175'
    $lblInfo2.Size = '440,20'
    $lblInfo2.ForeColor = $colors.TextSecondary
    $lblInfo2.Font = New-Object Drawing.Font("Segoe UI", 8.5)
    $contentPanel.Controls.Add($lblInfo2)
    
    $btnClose = New-Object Windows.Forms.Button
    $btnClose.Text = Get-LocalizedString "Close"
    $btnClose.Location = '170,210'
    $btnClose.Size = '110,36'
    $btnClose.FlatStyle = 'Flat'
    $btnClose.FlatAppearance.BorderSize = 0
    $btnClose.BackColor = $colors.Secondary
    $btnClose.ForeColor = $colors.Text
    $btnClose.Cursor = [System.Windows.Forms.Cursors]::Hand
    $btnClose.Add_Click({ $settingsForm.Close() })
    $contentPanel.Controls.Add($btnClose)
    
    $settingsForm.ShowDialog($form) | Out-Null
}

# -------------------------
# Action Functions (shared by buttons and menus)
# -------------------------
function Invoke-WindowsUpdate {
    $status.Clear()
    $progress.Value = 0
    $statusLabel.Text = "  Running Windows Update..."
    Start-BackgroundTask -Name "WindowsUpdate" -TaskArgs @()
}

function Invoke-CheckDriverUpdates {
    $status.Clear()
    $progress.Value = 0
    $statusLabel.Text = "  Checking for driver updates..."
    Start-BackgroundTask -Name "CheckDriverUpdates" -TaskArgs @()
}

function Invoke-ScanDrivers {
    $status.Clear()
    $progress.Value = 0
    $statusLabel.Text = "  Scanning installed drivers..."
    Start-BackgroundTask -Name "ScanDrivers" -TaskArgs @()
}

function Invoke-BackupDrivers {
    $status.Clear()
    $progress.Value = 0
    $fbd = New-Object System.Windows.Forms.FolderBrowserDialog
    $fbd.Description = Get-LocalizedString "SelectBackupFolder"
    $fbd.ShowNewFolderButton = $true
    if ($fbd.ShowDialog($form) -eq [System.Windows.Forms.DialogResult]::OK) {
        $dest = $fbd.SelectedPath
        $statusLabel.Text = "  Backing up drivers..."
        Start-BackgroundTask -Name "BackupDrivers" -TaskArgs @($dest)
    } else {
        Add-StatusUI $form $status (Get-LocalizedString "BackupCanceled")
    }
}

function Invoke-InstallDrivers {
    $status.Clear()
    $progress.Value = 0
    $fbd = New-Object System.Windows.Forms.FolderBrowserDialog
    $fbd.Description = Get-LocalizedString "SelectDriverFolder"
    $fbd.ShowNewFolderButton = $false
    if ($fbd.ShowDialog($form) -eq [System.Windows.Forms.DialogResult]::OK) {
        $folder = $fbd.SelectedPath
        $statusLabel.Text = "  Installing drivers..."
        Start-BackgroundTask -Name "InstallDrivers" -TaskArgs @($folder)
    } else {
        Add-StatusUI $form $status (Get-LocalizedString "InstallCanceled")
    }
}

function Invoke-CancelTask {
    try {
        if ($null -ne $global:CurrentJob) {
            Stop-Job -Id $global:CurrentJob.Id -Force -ErrorAction SilentlyContinue
            Remove-Job -Id $global:CurrentJob.Id -Force -ErrorAction SilentlyContinue
            $global:CurrentJob = $null
            $timer.Stop()
            $progress.Value = 0
            $statusLabel.Text = "  Task cancelled"
            Add-StatusUI $form $status (Get-LocalizedString "TaskCancelled")
        } else {
            Add-StatusUI $form $status (Get-LocalizedString "NoTaskToCancel")
        }
    } catch {
        Add-StatusUI $form $status "Cancel error: $_"
    }
}

function Invoke-OpenLogs {
    if (Test-Path $LogBase) {
        Start-Process -FilePath "explorer.exe" -ArgumentList "`"$LogBase`""
    } else {
        Add-StatusUI $form $status (Get-LocalizedString "LogFolderMissing")
    }
}

function Invoke-ToggleTheme {
    Set-Theme -Dark (-not $global:DarkModeEnabled)
}

function Invoke-CreateRestorePoint {
    $status.Clear()
    $statusLabel.Text = "  Creating restore point..."
    Add-StatusUI $form $status "Creating system restore point..."
    $progress.Value = 50
    
    if (New-RestorePoint -Description "Driver Updater - $(Get-Date -Format 'yyyy-MM-dd HH:mm')") {
        Add-StatusUI $form $status (Get-LocalizedString "RestorePointCreated")
        $statusLabel.Text = "  Restore point created"
    } else {
        Add-StatusUI $form $status (Get-LocalizedString "RestorePointFailed")
        $statusLabel.Text = "  Restore point failed"
    }
    $progress.Value = 100
}

# -------------------------
# Button handlers
# -------------------------
$btnWU.Add_Click({ Invoke-WindowsUpdate })
$btnCheckUpdates.Add_Click({ Invoke-CheckDriverUpdates })
$btnScan.Add_Click({ Invoke-ScanDrivers })
$btnBackup.Add_Click({ Invoke-BackupDrivers })
$btnInstall.Add_Click({ Invoke-InstallDrivers })
$btnCancel.Add_Click({ Invoke-CancelTask })

# -------------------------
# Menu handlers
# -------------------------
$menuWU.Add_Click({ Invoke-WindowsUpdate })
$menuCheckUpdates.Add_Click({ Invoke-CheckDriverUpdates })
$menuScan.Add_Click({ Invoke-ScanDrivers })
$menuBackup.Add_Click({ Invoke-BackupDrivers })
$menuInstall.Add_Click({ Invoke-InstallDrivers })
$menuCancel.Add_Click({ Invoke-CancelTask })
$menuOpenLogs.Add_Click({ Invoke-OpenLogs })
$menuToggleTheme.Add_Click({ Invoke-ToggleTheme })
$menuRestorePoint.Add_Click({ Invoke-CreateRestorePoint })
$menuSchedule.Add_Click({ Show-ScheduleDialog })
$menuHistory.Add_Click({ Show-HistoryDialog })
$menuFilters.Add_Click({ Show-FiltersDialog })
$menuSettingsTop.Add_Click({ Show-SettingsDialog })
$menuExit.Add_Click({ $form.Close() })

# Language menu handlers
foreach ($item in $menuLanguage.DropDownItems) {
    $item.Add_Click({
        $clickedItem = $this
        $global:CurrentLanguage = $clickedItem.Tag
        Update-UILanguage
        Export-Settings
        $statusLabel.Text = "  $(Get-LocalizedString 'LanguageChanged') $($clickedItem.Tag)"
        Add-StatusUI $form $status "$(Get-LocalizedString 'LanguageChanged') $($clickedItem.Tag)"
    })
}

# Update button centering on resize
$form.Add_Resize({ Update-ButtonContainerPadding })

# Form closing cleanup
$form.Add_FormClosing({
    try {
        if ($null -ne $global:CurrentJob) {
            Stop-Job -Id $global:CurrentJob.Id -Force -ErrorAction SilentlyContinue
            Remove-Job -Id $global:CurrentJob.Id -Force -ErrorAction SilentlyContinue
        }
    } catch {}
})

# Apply saved theme
Set-Theme -Dark $global:DarkModeEnabled

# Show form
$form.Topmost = $true
$form.Add_Shown({
    $form.Activate()
    Update-ButtonContainerPadding
})
[void]$form.ShowDialog()
