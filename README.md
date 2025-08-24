# Disable-Windows-Data-Hogs.ps1
# 🚫 Disable-Windows-Data-Hogs.ps1

A PowerShell script that disables unnecessary background services, telemetry, live tiles, and Microsoft ads on Windows 10 to help users minimize unwanted data usage — especially useful for users on limited or metered internet connections.

---

⚙️ How to Use

🛡️ Must be run as Administrator

Download Disable-Windows-Data-Hogs.ps1 to your Desktop.

Open PowerShell as Administrator:

Press Win, type powershell

Right-click > Run as administrator

Run the script with this command:

    powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\Desktop\Disable-Windows-Data-Hogs.ps1"


Wait for it to finish — you'll see messages for each disabled service and registry tweak.

Restart your PC.


🔧 Manual Fix for Delivery Optimization (DoSvc)
🔹 Registry Path:
HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\DoSvc

🔹 What to Do:

Press Win + R, type regedit, press Enter

Navigate to:

HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\DoSvc


On the right side, find the entry named: Start

Double-click Start, and set the value to 4

Click OK, close the Registry Editor

Restart your PC


## 🎯 Features

This script does the following automatically:

### ✅ Disables background services:
- **Delivery Optimization (`DoSvc`)** – Peer-to-peer Windows updates
- **Connected User Experiences (`DiagTrack`)** – Telemetry and user activity tracking
- **Diagnostic Policy Service (`DPS`)** – Sends diagnostics data
- **SysMain (Superfetch)** – Prefetching system memory (useful only on HDDs)
- **Windows Search (`WSearch`)** – File indexing service
- **Windows Error Reporting (`WerSvc`)** – Crash reporting to Microsoft

### 🧠 Disables telemetry and tracking:
- Windows telemetry (AllowTelemetry = 0)
- Activity uploads
- Feedback collection

### 📰 Blocks live tiles, app suggestions, and content delivery:
- Live tile updates in Start Menu
- App suggestions and ads in Start Menu
- Spotlight content on lock screen
- Preinstalled and silently installed apps from Microsoft Store

### 🔕 Disables:
- Toast notifications
- Push notifications from apps

### 📶 Sets all active network connections (Wi-Fi and Ethernet) as **metered**:
- This helps prevent background data sync and large downloads like Windows updates.

---

## 📥 How to Use

> ⚠️ Must be run as **Administrator**

1. **Download** the script `Disable-Windows-Data-Hogs.ps1`
2. **Right-click** on the file and select **“Run with PowerShell”**
3. Wait for execution to complete (it prints messages for each action)
4. **Restart your PC** to apply all changes

---

## 💡 Why Use This?

This is ideal for:
- Users with **limited internet data plans**
- Those who want to **stop background telemetry and tracking**
- Power users looking to optimize performance and privacy

---

## 🛑 Disclaimer

Use at your own risk. This script makes system-level changes to services and the registry. Make sure you understand what it does before running it, and **back up your system** if needed.

---

## 📄 License

MIT License — feel free to fork, modify, or contribute.
