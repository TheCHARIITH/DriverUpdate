# Driver Updater by CHARITH — v2.1
# Run as Administrator
# Usage: irm https://raw.githubusercontent.com/The CHARITH/DriverUpdate/main/DriverUpdatev2.ps1 | iex

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# -------------------------
# Require Admin (meka admin check ekak)
# -------------------------
function Require-Admin {
    if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        [System.Windows.Forms.MessageBox]::Show("Please run this script as Administrator.", "Permission Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        exit 1
    }
}
Require-Admin

# -------------------------
# Globals and paths
# -------------------------
$AppTitle = "Driver Updater by The CHARITH"
$LogBase = Join-Path $env:USERPROFILE "Documents\The CHARITH_DriverUpdater"
if (!(Test-Path $LogBase)) { New-Item -ItemType Directory -Path $LogBase -Force | Out-Null }

$global:CurrentJob = $null
$global:CurrentTaskLog = $null

# Helper: create timestamped log file
function New-TaskLog([string]$taskName) {
    $ts = (Get-Date).ToString("yyyyMMdd_HHmmss")
    $logFile = Join-Path $LogBase "$($taskName)_$ts.log"
    New-Item -Path $logFile -ItemType File -Force | Out-Null
    return $logFile
}

# Write to UI status (needs form invoke)
function Append-StatusUI {
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
# Build Form
# -------------------------
$form = New-Object Windows.Forms.Form
$form.Text = $AppTitle
$form.Size = '620,520'
$form.StartPosition = "CenterScreen"
$form.BackColor = 'WhiteSmoke'
$form.Font = New-Object Drawing.Font("Segoe UI", 10)

# Status RichTextBox
$status = New-Object Windows.Forms.RichTextBox
$status.Multiline = $true
$status.ReadOnly = $true
$status.Dock = 'Top'
$status.Height = 300
$status.BackColor = 'White'
$status.ScrollBars = 'Vertical'
$form.Controls.Add($status)

# Progress bar
$progress = New-Object Windows.Forms.ProgressBar
$progress.Dock = 'Top'
$progress.Height = 24
$progress.Style = 'Continuous'
$progress.Value = 0
$form.Controls.Add($progress)

# Buttons panel
$panel = New-Object Windows.Forms.FlowLayoutPanel
$panel.Dock = 'Top'
$panel.Height = 120
$panel.Padding = '10,10,10,10'
$panel.AutoSize = $false
$panel.FlowDirection = 'LeftToRight'
$form.Controls.Add($panel)

# Buttons
function New-Button($text, $width=140) {
    $btn = New-Object System.Windows.Forms.Button
    $btn.Text = $text
    $btn.Width = $width
    $btn.Height = 36
    $btn.FlatStyle = "System"
    return $btn
}

$btnWU = New-Button "Check Windows Update"
$btnScan = New-Button "Scan Installed Drivers"
$btnBackup = New-Button "Backup Drivers"
$btnInstall = New-Button "Install From Folder"
$btnCancel = New-Button "Cancel Task"
$btnOpenLogs = New-Button "Open Logs"
$btnToggleTheme = New-Button "Dark Mode"

$panel.Controls.AddRange(@($btnWU, $btnScan, $btnBackup, $btnInstall, $btnCancel, $btnOpenLogs, $btnToggleTheme))

# DataGrid for drivers result (hidden initially)
$driversGrid = New-Object Windows.Forms.DataGridView
$driversGrid.ReadOnly = $true
$driversGrid.AllowUserToAddRows = $false
$driversGrid.AllowUserToDeleteRows = $false
$driversGrid.Height = 60
$driversGrid.Visible = $false
$driversGrid.Dock = 'Top'
$form.Controls.Add($driversGrid)

# Timer to poll job/logs
$timer = New-Object Windows.Forms.Timer
$timer.Interval = 1000

# -------------------------
# Background job helpers
# -------------------------
function Start-BackgroundTask {
    param(
        [string]$Name,
        [scriptblock]$ScriptBlock,
        [array]$Args
    )
    if ($global:CurrentJob -ne $null -and (Get-Job -Id $global:CurrentJob.Id -ErrorAction SilentlyContinue)) {
        [System.Windows.Forms.MessageBox]::Show("A task is already running. Cancel it first.", "Task Running", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        return $null
    }

    $log = New-TaskLog $Name
    $global:CurrentTaskLog = $log
    Append-StatusUI $form $status ("→ Starting task: $Name")
    $scriptArgs = @($log) + $Args

    # Start job (pass log path as first argument)
    $job = Start-Job -Name $Name -ScriptBlock {
        param($logPath, $innerArgs)
        # small helper inside job
        function L($m) {
            $t = (Get-Date).ToString("s")
            Add-Content -Path $logPath -Value ("$t - $m")
        }
        try {
            & $using:ScriptBlock @($logPath, $innerArgs) 2>&1 | ForEach-Object { L($_) }
        } catch {
            L("ERROR in job: $_")
        }
    } -ArgumentList (,$scriptArgs) -RunAs32:$false

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

        # Update progress heuristic
        if ($global:CurrentTaskLog -and (Test-Path $global:CurrentTaskLog)) {
            $content = Get-Content -Path $global:CurrentTaskLog -Tail 100 -ErrorAction SilentlyContinue
            $p = 0
            if ($content -match "Starting") { $p = 10 }
            if ($content -match "Scan" -or $content -match "Listing") { $p = 35 }
            if ($content -match "Export" -or $content -match "Download" -or $content -match "Backup") { $p = 65 }
            if ($content -match "Install" -or $content -match "Export complete" -or $content -match "Completed") { $p = 90 }
            $progress.Value = [int]$p
        }

        # Check job finished
        if ($global:CurrentJob -ne $null) {
            $jobState = (Get-Job -Id $global:CurrentJob.Id -ErrorAction SilentlyContinue).State
            if ($jobState -in @("Completed","Failed","Stopped","Disconnected","Blocked","Suspended","Aborted")) {
                Start-Sleep -Milliseconds 200
                # pull final output and mark complete
                $finalLines = Get-Content -Path $global:CurrentTaskLog -Tail 200 -ErrorAction SilentlyContinue
                $invoke = [System.Windows.Forms.MethodInvoker]{
                    $status.AppendText("`r`n=== Task finished: $jobState ===`r`n")
                    $status.ScrollToCaret()
                    $progress.Value = 100
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
# Task scriptblocks (reusable)
# Each SB receives first param as $logPath and second as $innerArgs (array)
# -------------------------

# 1) Windows Update scan/install
$SB_WU = {
    param($logPath, $innerArgs)
    function L($m){ Add-Content $logPath ("$(Get-Date -Format 's') - $m") }
    L "Starting Windows Update scan"
    try {
        # trigger detection
        L "Triggering wuauclt /detectnow"
        & wuauclt.exe /detectnow 2>&1 | Out-String | ForEach-Object { L($_.Trim()) } 
    } catch { L "wuauclt error: $_" }
    Start-Sleep -Seconds 2
    try {
        L "Attempting usoclient StartScan"
        Start-Process -FilePath "usoclient.exe" -ArgumentList "StartScan" -NoNewWindow -Wait -ErrorAction Stop
        L "StartScan triggered"
    } catch { L "usoclient StartScan error: $_" }
    Start-Sleep -Seconds 2
    try {
        L "Attempting usoclient StartDownload"
        Start-Process -FilePath "usoclient.exe" -ArgumentList "StartDownload" -NoNewWindow -Wait -ErrorAction Stop
        L "StartDownload triggered"
    } catch { L "usoclient StartDownload error: $_" }
    Start-Sleep -Seconds 2
    try {
        L "Attempting usoclient StartInstall"
        Start-Process -FilePath "usoclient.exe" -ArgumentList "StartInstall" -NoNewWindow -Wait -ErrorAction Stop
        L "StartInstall triggered"
    } catch { L "usoclient StartInstall error: $_" }
    L "Windows Update steps completed (verify in Settings → Windows Update)."
    L "Completed"
}

# 2) Scan installed signed drivers and export CSV
$SB_ScanDrivers = {
    param($logPath, $innerArgs)
    function L($m){ Add-Content $logPath ("$(Get-Date -Format 's') - $m") }
    L "Scanning installed signed drivers via Win32_PnPSignedDriver"
    try {
        $drivers = Get-CimInstance Win32_PnPSignedDriver | Select-Object DeviceName, Manufacturer, DriverVersion, InfName, Class, DriverDate
        $csvPath = Join-Path (Split-Path $logPath) "InstalledDrivers_$((Get-Date).ToString('yyyyMMdd_HHmmss')).csv"
        $drivers | Sort-Object DeviceName | Export-Csv -Path $csvPath -NoTypeInformation -Encoding UTF8
        L "Exported installed drivers to CSV: $csvPath"
        L "Completed"
    } catch {
        L "Error enumerating drivers: $_"
    }
}

# 3) Backup 3rd-party drivers using DISM
$SB_BackupDrivers = {
    param($logPath, $innerArgs)
    function L($m){ Add-Content $logPath ("$(Get-Date -Format 's') - $m") }
    $dest = $innerArgs[0]
    L "Starting driver backup to: $dest"
    try {
        if (!(Test-Path $dest)) { New-Item -ItemType Directory -Path $dest -Force | Out-Null }
        L "Calling: dism /online /export-driver /destination:`"$dest`""
        $res = & dism.exe /online /export-driver /destination:$dest 2>&1
        $res | ForEach-Object { L($_) }
        L "Export complete. Check destination folder"
    } catch {
        L "DISM export error: $_"
    }
    L "Completed"
}

# 4) Install drivers from folder (recursively)
$SB_InstallFromFolder = {
    param($logPath, $innerArgs)
    function L($m){ Add-Content $logPath ("$(Get-Date -Format 's') - $m") }
    $folder = $innerArgs[0]
    L "Installing drivers from folder: $folder"
    try {
        if (-not (Test-Path $folder)) {
            L "Folder doesn't exist: $folder"
            return
        }
        # Use pnputil to add inf drivers recursively
        $infFiles = Get-ChildItem -Path $folder -Recurse -Include *.inf -ErrorAction SilentlyContinue
        if ($infFiles.Count -eq 0) {
            L "No .inf files found under $folder"
        } else {
            foreach ($inf in $infFiles) {
                L "-> Installing: $($inf.FullName)"
                $out = & pnputil.exe /add-driver $inf.FullName /install 2>&1
                $out | ForEach-Object { L($_) }
                Start-Sleep -Milliseconds 300
            }
            L "Driver install attempts complete. Reboot may be required for some drivers."
        }
    } catch {
        L "Error during install: $_"
    }
    L "Completed"
}

# -------------------------
# Button handlers (no extra confirmations per user's preference)
# -------------------------
$btnWU.Add_Click({
    $status.Clear()
    $progress.Value = 0
    Start-BackgroundTask -Name "WindowsUpdate" -ScriptBlock $SB_WU -Args @()
})

$btnScan.Add_Click({
    $status.Clear()
    $progress.Value = 0
    Start-BackgroundTask -Name "ScanDrivers" -ScriptBlock $SB_ScanDrivers -Args @()
})

$btnBackup.Add_Click({
    $status.Clear()
    $progress.Value = 0
    # Choose destination folder
    $fbd = New-Object System.Windows.Forms.FolderBrowserDialog
    $fbd.Description = "Select folder to save driver backup (will export all 3rd-party drivers)"
    $fbd.ShowNewFolderButton = $true
    if ($fbd.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $dest = $fbd.SelectedPath
        Start-BackgroundTask -Name "BackupDrivers" -ScriptBlock $SB_BackupDrivers -Args @($dest)
    } else {
        Append-StatusUI $form $status "Backup canceled by user."
    }
})

$btnInstall.Add_Click({
    $status.Clear()
    $progress.Value = 0
    $fbd = New-Object System.Windows.Forms.FolderBrowserDialog
    $fbd.Description = "Select folder containing driver .inf files"
    $fbd.ShowNewFolderButton = $false
    if ($fbd.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $folder = $fbd.SelectedPath
        Start-BackgroundTask -Name "InstallDrivers" -ScriptBlock $SB_InstallFromFolder -Args @($folder)
    } else {
        Append-StatusUI $form $status "Install canceled by user."
    }
})

$btnCancel.Add_Click({
    try {
        if ($global:CurrentJob -ne $null) {
            Stop-Job -Id $global:CurrentJob.Id -Force -ErrorAction SilentlyContinue
            Remove-Job -Id $global:CurrentJob.Id -Force -ErrorAction SilentlyContinue
            $global:CurrentJob = $null
            $timer.Stop()
            $progress.Value = 0
            Append-StatusUI $form $status "✖ Task cancelled by user."
        } else {
            Append-StatusUI $form $status "No running task to cancel."
        }
    } catch {
        Append-StatusUI $form $status "Cancel error: $_"
    }
})

$btnOpenLogs.Add_Click({
    # open log folder
    if (Test-Path $LogBase) {
        Start-Process -FilePath "explorer.exe" -ArgumentList "`"$LogBase`""
    } else {
        Append-StatusUI $form $status "Log folder missing."
    }
})

$btnToggleTheme.Add_Click({
    if ($form.BackColor.Name -eq "WhiteSmoke") {
        $form.BackColor = [System.Drawing.Color]::FromArgb(32,32,32)
        $status.BackColor = [System.Drawing.Color]::FromArgb(18,18,18)
        $status.ForeColor = [System.Drawing.Color]::White
        $panel.BackColor = $form.BackColor
        $btnToggleTheme.Text = "Light Mode"
    } else {
        $form.BackColor = 'WhiteSmoke'
        $status.BackColor = 'White'
        $status.ForeColor = 'Black'
        $panel.BackColor = $form.BackColor
        $btnToggleTheme.Text = "Dark Mode"
    }
})

# Form closing cleanup
$form.Add_FormClosing({
    try {
        if ($global:CurrentJob -ne $null) {
            Stop-Job -Id $global:CurrentJob.Id -Force -ErrorAction SilentlyContinue
            Remove-Job -Id $global:CurrentJob.Id -Force -ErrorAction SilentlyContinue
        }
    } catch {}
})

# Show form
$form.Topmost = $true
$form.Add_Shown({$form.Activate()})
[void]$form.ShowDialog()
