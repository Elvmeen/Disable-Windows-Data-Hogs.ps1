# ===============================
# PowerShell Script to Disable Background Services and Set Metered Connection
# ===============================

# Run as administrator check
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "Please run this script as Administrator!"
    Exit
}

# Disable background services
$servicesToDisable = @(
    "DoSvc",    # Delivery Optimization
    "DiagTrack",# Connected User Experience
    "DPS",      # Diagnostic Policy Service
    "SysMain",  # Superfetch
    "WSearch",  # Windows Search
    "WerSvc"    # Windows Error Reporting
)
foreach ($svc in $servicesToDisable) {
    try {
        Stop-Service -Name $svc -Force -ErrorAction SilentlyContinue
        Set-Service -Name $svc -StartupType Disabled
        Write-Host "Disabled service: $svc"
    } catch {
        Write-Warning "Failed to disable service: $svc"
    }
}

# Registry edits
$regEdits = @(
    @{Path="HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"; Name="AllowTelemetry"; Value=0; Type="DWord"},
    @{Path="HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"; Name="UploadUserActivities"; Value=0; Type="DWord"},
    @{Path="HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"; Name="PublishUserActivities"; Value=0; Type="DWord"},
    @{Path="HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"; Name="ContentDeliveryAllowed"; Value=0; Type="DWord"},
    @{Path="HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"; Name="FeatureManagementEnabled"; Value=0; Type="DWord"},
    @{Path="HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"; Name="OemPreInstalledAppsEnabled"; Value=0; Type="DWord"},
    @{Path="HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"; Name="PreInstalledAppsEnabled"; Value=0; Type="DWord"},
    @{Path="HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"; Name="SilentInstalledAppsEnabled"; Value=0; Type="DWord"},
    @{Path="HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"; Name="SystemPaneSuggestionsEnabled"; Value=0; Type="DWord"},
    @{Path="HKCU:\Software\Policies\Microsoft\Windows\CloudContent"; Name="DisableWindowsSpotlightFeatures"; Value=1; Type="DWord"},
    @{Path="HKCU:\Software\Policies\Microsoft\Windows\CloudContent"; Name="DisableWindowsSpotlightOnActionCenter"; Value=1; Type="DWord"},
    @{Path="HKCU:\Software\Policies\Microsoft\Windows\CloudContent"; Name="DisableWindowsSpotlightOnSettings"; Value=1; Type="DWord"},
    @{Path="HKCU:\Software\Policies\Microsoft\Windows\CloudContent"; Name="DisableWindowsSpotlightOnLockScreen"; Value=1; Type="DWord"},
    @{Path="HKCU:\Software\Microsoft\Windows\CurrentVersion\PushNotifications"; Name="ToastEnabled"; Value=0; Type="DWord"},
    @{Path="HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore"; Name="AutoDownload"; Value=2; Type="DWord"},
    @{Path="HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"; Name="Start_TrackProgs"; Value=0; Type="DWord"},
    @{Path="HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"; Name="Start_TrackEnabled"; Value=0; Type="DWord"},
    @{Path="HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"; Name="Start_Recommendations"; Value=0; Type="DWord"}
)
foreach ($item in $regEdits) {
    try {
        if (-not (Test-Path $item.Path)) {
            New-Item -Path $item.Path -Force | Out-Null
        }
        New-ItemProperty -Path $item.Path -Name $item.Name -Value $item.Value -PropertyType $item.Type -Force | Out-Null
        Write-Host "Applied registry setting: $($item.Name)"
    } catch {
        Write-Warning "Failed to apply registry setting: $($item.Name)"
    }
}

# Set active Wi-Fi/Ethernet connection as metered
$profiles = Get-NetConnectionProfile
foreach ($profile in $profiles) {
    try {
        Set-NetConnectionProfile -Name $profile.Name -ConnectionMetered Metered
        Write-Host "Set '$($profile.Name)' connection as metered."
    } catch {
        Write-Warning "Failed to set metered connection for: $($profile.Name)"
    }
}
