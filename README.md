# Windows Driver Updater v3.0 🚀

A modern, user-friendly **PowerShell GUI application** for updating Windows drivers automatically. Version **3.0** introduces multi-language support, advanced filtering, scheduling, dark/light themes, and improved usability.

![Driver Updater Screenshot](https://github.com/user-attachments/assets/e97ee19f-903b-4162-8c95-585122432cae)


---

## 🚀 Quick Installation

Run this command in PowerShell as **Administrator** to launch the updater immediately:

```powershell
irm https://raw.githubusercontent.com/TheCHARIITH/DriverUpdate/main/DriveUpdateV3.ps1 | iex

```

---

## ✨ What's New in v3.0

### **🎨 Modernized UI/UX**

* **Dual-Theme Support**: Toggle between **Dark Mode** and **Light Mode** with a professional color palette.
* **Localized Experience**: Full support for 6 languages: English, Spanish, French, German, Portuguese, and Italian.
* **Enhanced Components**: Rounded corners, responsive layouts, and a real-time status bar with version tracking.

### **🛠️ Advanced Tools & Automation**

* **Task Scheduler**: Schedule automatic driver checks (Daily, Weekly, or Monthly) directly from the Tools menu.
* **System Protection**: Built-in "Create Restore Point" functionality before performing driver updates.
* **Network Proxy**: Integrated support for HTTP/HTTPS proxies for restricted network environments.
* **Advanced Filtering**: Filter driver scans by **Class** (Display, Audio, Network) or **Manufacturer**.

### **📊 Management & Logging**

* **Persistent Settings**: All preferences are saved in a structured JSON file at `%USERPROFILE%\Documents\The CHARITH_DriverUpdater\`.
* **Update History**: A detailed log of the last 100 tasks, including timestamps, status, and specific driver details.
* **Enhanced Silent Mode**: Perfect for system admins; run tasks via CLI without ever opening the GUI.

---

## 📋 Command-Line Parameters

| Parameter | Description |
| --- | --- |
| `-Silent` | Run tasks in the background without the GUI. |
| `-Task` | Define silent task: `WindowsUpdate`, `CheckDriverUpdates`, or `ScanDrivers`. |
| `-Language` | Force a specific language (e.g., `es`, `fr`, `de`). |
| `-ProxyAddress` | Set a custom proxy URL for the update session. |
| `-FilterClass` | Only process drivers belonging to a specific class. |

---

## 📥 Manual Setup

1. **Clone the repository:**
```powershell
git clone https://github.com/TheCHARIITH/DriverUpdate.git

```


2. **Navigate to the folder:**
```powershell
cd DriverUpdate

```


3. **Execute:**
```powershell
powershell -ExecutionPolicy Bypass -File DriveUpdateV3.ps1

```



---

## 🛡️ Safety & Requirements

> [!IMPORTANT]
> **Administrator Privileges** are required to scan and install system drivers.
> Always ensure you have a stable internet connection before beginning the update process.

* **OS**: Windows 10 or Windows 11 (Latest builds recommended).
* **PowerShell**: 5.1 or higher.
* **Dependencies**: The script automatically handles the `PSWindowsUpdate` module installation.

---

## 🤝 Contributing & Feedback

Contributions are what make the open-source community such an amazing place.

1. Fork the Project.
2. Create your Feature Branch (`git checkout -b feature/NewFeature`).
3. Commit your Changes (`git commit -m 'Add NewFeature'`).
4. Push to the Branch (`git push origin feature/NewFeature`).
5. Open a **Pull Request**.

---

## ⚖️ License

Distributed under the MIT License. See `LICENSE` for more information.

**Author:** [TheCHARITH](https://github.com/TheCHARIITH)

**Organization:** [Simplest Circuits](https://github.com/simplest-circuits)

---

**Made with 💜 and too much ☕ by TheCHARITH** | *Version 3.0.0 • 2026*
