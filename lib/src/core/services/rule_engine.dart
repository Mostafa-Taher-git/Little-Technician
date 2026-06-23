import 'package:flutter/material.dart';
import 'package:littletech/src/core/constants/category_manager.dart';
import 'package:littletech/src/features/solutions/data/models/problem_solution_model.dart';

/// Each category has an icon and a list of problems.
class CategoryData {
  final String name;
  final IconData icon;
  final List<String> problems;

  const CategoryData({required this.name, required this.icon, required this.problems});
}

/// The complete knowledge-base for LittleTech.
class RuleEngine {
  static List<CategoryData> get categories {
    return CategoryManager.all.map((cat) {
      return CategoryData(name: cat.name, icon: cat.icon, problems: cat.problemKeys);
    }).toList();
  }

  /// Maps a problem string → list of solution steps.
  static final Map<String, List<String>> _solutions = {
    // ── CPU ──────────────────────────────────────────────────────────────────
    'high cpu usage': [
      'Open Task Manager (Ctrl + Shift + Esc) and sort by CPU column.',
      'Identify and end tasks consuming abnormally high CPU.',
      'Run a full malware scan with Windows Defender or your antivirus.',
      'Disable unnecessary startup programs in Task Manager → Startup tab.',
      'Update drivers and Windows to the latest version.',
    ],
    'cpu overheating': [
      'Ensure all case fans are spinning and not blocked by dust.',
      'Re-apply thermal paste between the CPU and cooler.',
      'Check that the CPU cooler is properly seated and mounted.',
      'Improve case airflow — add intake/exhaust fans if needed.',
      'Monitor temperatures with HWMonitor; keep below 85 °C under load.',
    ],
    'computer not turning on': [
      'Verify the power cable is firmly plugged into the PSU and wall outlet.',
      'Check the PSU switch at the back is set to "I" (on).',
      'Try a different power cable and outlet.',
      'Disconnect all peripherals and try powering on again.',
      'If still no power, test with a known-good PSU.',
    ],
    'beep codes on startup': [
      'Note the beep pattern (e.g. 1 long, 2 short).',
      'Consult your motherboard manual to decode the beep code.',
      'Reseat RAM sticks firmly in their slots.',
      'Reseat the GPU and all expansion cards.',
      'Clear CMOS by removing the battery for 30 seconds.',
    ],
    'cpu fan not spinning': [
      'Check that the fan cable is connected to the CPU_FAN header.',
      'Clean dust from the fan blades with compressed air.',
      'Enter BIOS and verify the fan is detected.',
      'Try connecting the fan to a different header to rule out a bad header.',
      'Replace the fan if it still does not spin.',
    ],
    'cpu not detected in bios': [
      'Confirm the CPU is compatible with your motherboard socket.',
      'Inspect the CPU socket for bent pins (Intel) or the CPU for bent pins (AMD).',
      'Update the BIOS to the latest version that supports your CPU.',
      'Reseat the CPU carefully and re-apply thermal paste.',
      'Test the CPU in another compatible motherboard if possible.',
    ],

    // ── RAM ──────────────────────────────────────────────────────────────────
    'random crashes / bsod': [
      'Run Windows Memory Diagnostic (search "mdsched" in Start menu).',
      'Use MemTest86 overnight to test RAM thoroughly.',
      'Reseat RAM sticks and clean the gold contacts with an eraser.',
      'Test one stick at a time to identify the faulty module.',
      'Ensure RAM speed/voltage matches BIOS XMP profile settings.',
    ],
    'insufficient memory warning': [
      'Close unnecessary browser tabs and background apps.',
      'Disable heavy startup programs via Task Manager.',
      'Increase virtual memory (page file) size in System settings.',
      'Consider upgrading to more RAM if you have free DIMM slots.',
      'Check for memory leaks using Task Manager → Performance tab.',
    ],
    'ram not detected': [
      'Reseat the RAM stick firmly until you hear the clips snap.',
      'Try a different DIMM slot on the motherboard.',
      'Verify the RAM type (DDR4/DDR5) is compatible with your motherboard.',
      'Clean the gold contacts gently with a pencil eraser.',
      'Test the RAM stick in another computer to confirm it works.',
    ],
    'ram overheating': [
      'Ensure adequate case airflow around the RAM area.',
      'Install RAM heatsinks if your modules do not have them.',
      'Reduce RAM voltage to the manufacturer-recommended value in BIOS.',
      'Avoid overclocking RAM beyond rated specifications.',
    ],
    'ram compatibility issues': [
      'Check the motherboard QVL (Qualified Vendor List) for supported RAM.',
      'Ensure all sticks have matching speed, timings, and voltage.',
      'Update BIOS to improve memory compatibility.',
      'Use matched kits rather than mixing different brands.',
    ],

    // ── Boot & OS ────────────────────────────────────────────────────────────
    "pc won't boot": [
      'Ensure the power cable is properly connected.',
      'Check if the PSU switch is turned on.',
      'Disconnect all external devices and try again.',
      'Enter BIOS and verify the boot drive is detected.',
      'Try booting from a USB recovery drive.',
    ],
    'boot loop': [
      'Boot into Safe Mode (hold Shift → Restart → Troubleshoot → Startup Settings).',
      'Uninstall recently installed drivers or updates.',
      'Run "sfc /scannow" from an elevated Command Prompt.',
      'Disable automatic restart on system failure in System settings.',
      'Perform a System Restore to a known-good restore point.',
    ],
    'blue screen of death (bsod)': [
      'Note the stop code shown on the BSOD screen.',
      'Boot into Safe Mode and uninstall recently installed drivers.',
      'Run "sfc /scannow" and "DISM /Online /Cleanup-Image /RestoreHealth".',
      'Check RAM with Windows Memory Diagnostic.',
      'Update all device drivers from the manufacturer website.',
    ],
    'os running slow': [
      'Restart your computer — this alone fixes many slowdowns.',
      'Run Disk Cleanup and delete temporary files.',
      'Disable visual effects in System → Advanced → Performance settings.',
      'Check for malware with a full system scan.',
      'Defragment HDD (not SSD) via Optimize Drives.',
    ],
    'windows not updating': [
      'Run the Windows Update Troubleshooter (Settings → Update → Troubleshoot).',
      'Restart the Windows Update service: net stop wuauserv / net start wuauserv.',
      'Free up disk space — updates need at least 10 GB free.',
      'Run DISM and sfc /scannow to repair corrupted system files.',
      'Manually download the update from the Microsoft Update Catalog.',
    ],

    // ── Audio ────────────────────────────────────────────────────────────────
    'no sound output': [
      'Check that speakers/headphones are plugged in and powered on.',
      'Click the speaker icon in the taskbar and select the correct output device.',
      'Run the Windows Audio Troubleshooter.',
      'Reinstall the audio driver from Device Manager.',
      'Check if audio is muted in the application itself.',
    ],
    'distorted audio': [
      'Update or reinstall the audio driver.',
      'Disable audio enhancements in Sound settings → Properties.',
      'Try different speakers/headphones to isolate the issue.',
      'Check the audio cable for damage.',
    ],
    'audio device not found': [
      'Open Device Manager and check for audio devices with yellow warnings.',
      'Enable the audio device in Device Manager if disabled.',
      'Reinstall the audio driver from the motherboard/laptop manufacturer site.',
      'Check BIOS to ensure onboard audio is enabled.',
    ],
    'microphone not working': [
      'Go to Settings → Privacy → Microphone and allow app access.',
      'Select the correct microphone in Sound settings.',
      'Check if the microphone is muted or the volume is too low.',
      'Update the audio driver.',
    ],
    'audio lag / delay': [
      'Disable Bluetooth audio codec and use aptX Low Latency if available.',
      'Update Bluetooth and audio drivers.',
      'Reduce the distance between the Bluetooth device and PC.',
      'Try a wired connection to rule out wireless latency.',
    ],

    // ── Mouse ────────────────────────────────────────────────────────────────
    'mouse not responding': [
      'Try a different USB port.',
      'Check the mouse on another computer to rule out hardware failure.',
      'Update or reinstall the mouse driver in Device Manager.',
      'For wireless mice, replace the battery.',
    ],
    'cursor lagging or stuttering': [
      'Update the mouse driver.',
      'Reduce mouse polling rate if using a gaming mouse.',
      'Close CPU-intensive background applications.',
      'Try a different mouse pad surface.',
    ],
    'mouse double-click issue': [
      'Adjust double-click speed in Settings → Devices → Mouse.',
      'Clean around the mouse button with compressed air.',
      'Update the mouse firmware (for gaming mice).',
      'If hardware-related, the microswitch may need replacement.',
    ],
    'wireless mouse disconnecting': [
      'Replace or recharge the battery.',
      'Move the USB receiver to a different port, preferably USB 2.0.',
      'Reduce interference by keeping the receiver away from USB 3.0 devices.',
      'Re-pair the mouse using the manufacturer pairing tool.',
    ],
    'scroll wheel not working': [
      'Clean the scroll wheel area with compressed air.',
      'Update the mouse driver.',
      'Check mouse settings to ensure scroll lines is not set to 0.',
      'Test in another application to rule out app-specific issues.',
    ],

    // ── Keyboard ─────────────────────────────────────────────────────────────
    'keyboard not responding': [
      'Try a different USB port or cable.',
      'Check the keyboard on another computer.',
      'Reinstall the keyboard driver in Device Manager.',
      'For PS/2 keyboards, restart the PC after reconnecting.',
    ],
    'keys typing wrong characters': [
      'Check your keyboard layout in Settings → Time & Language → Language.',
      'Ensure Num Lock is not interfering with letter keys.',
      'Clean under the keys for stuck debris.',
      'Run the keyboard troubleshooter.',
    ],
    'sticky keys': [
      'Clean under the affected keys with compressed air or isopropyl alcohol.',
      'Disable Sticky Keys in Settings → Accessibility → Keyboard.',
      'Replace keycaps if physically damaged.',
      'Consider replacing the keyboard if the issue persists.',
    ],
    'backlight not working': [
      'Check the keyboard backlight key shortcut (usually Fn + F-keys).',
      'Update the keyboard driver and manufacturer software.',
      'Check BIOS for keyboard backlight settings.',
      'If hardware-related, the LED ribbon cable may be loose.',
    ],
    'wireless keyboard lag': [
      'Replace the battery.',
      'Move the receiver closer and away from USB 3.0 interference.',
      'Update the keyboard firmware.',
      'Switch to a wired connection for latency-sensitive tasks.',
    ],

    // ── Printer ──────────────────────────────────────────────────────────────
    'printer not responding': [
      'Check that the printer is powered on and connected to the same network.',
      'Restart both the printer and the computer.',
      'Clear the print queue in Devices and Printers.',
      'Reinstall the printer driver from the manufacturer website.',
    ],
    'paper jam': [
      'Turn off the printer and unplug it.',
      'Gently pull the jammed paper in the direction of the paper path.',
      'Check for small torn paper pieces inside the printer.',
      'Reload paper correctly and ensure it is not damp or curled.',
    ],
    'poor print quality': [
      'Run the printer head cleaning utility from printer properties.',
      'Check ink/toner levels and replace low cartridges.',
      'Use the correct paper type setting in print preferences.',
      'Align the print head if your printer supports it.',
    ],
    'printer offline': [
      'Check the printer connection (USB or Wi-Fi).',
      'In Devices and Printers, right-click → Set as default and "Use Printer Online".',
      'Restart the Print Spooler service (services.msc).',
      'Reinstall the printer.',
    ],
    'driver installation failed': [
      'Download the latest driver directly from the printer manufacturer.',
      'Run the installer as Administrator.',
      'Uninstall the existing driver first via Device Manager.',
      'Try installing in Compatibility Mode for an older Windows version.',
    ],

    // ── Programs ─────────────────────────────────────────────────────────────
    'program crashes on launch': [
      'Run the program as Administrator.',
      'Update the program to the latest version.',
      'Check for missing Visual C++ Redistributable or .NET Framework.',
      'Run "sfc /scannow" to repair system files.',
      'Reinstall the program.',
    ],
    'software installation failed': [
      'Run the installer as Administrator.',
      'Ensure you have enough disk space.',
      'Disable antivirus temporarily during installation.',
      'Check Windows Event Viewer for the specific error code.',
    ],
    'program running slow': [
      'Close other applications to free up RAM and CPU.',
      'Check if the program has an update available.',
      'Clear the program\'s cache if applicable.',
      'Reinstall the program if it continues to lag.',
    ],
    'dll file missing error': [
      'Note the exact DLL file name from the error message.',
      'Reinstall the program that reports the missing DLL.',
      'Install the latest Visual C++ Redistributable package.',
      'Run "sfc /scannow" to restore system DLL files.',
    ],
    'program not compatible': [
      'Right-click the program → Properties → Compatibility tab.',
      'Try running in compatibility mode for an older Windows version.',
      'Check the program\'s system requirements against your PC specs.',
      'Look for a 64-bit version if you are on a 64-bit OS.',
    ],

    // ── Internet ─────────────────────────────────────────────────────────────
    'no internet connection': [
      'Restart your router and modem (unplug for 30 seconds).',
      'Check if other devices on the same network can access the internet.',
      'Run the Windows Network Troubleshooter.',
      'Reset network settings: netsh winsock reset and netsh int ip reset.',
      'Contact your ISP if the issue persists.',
    ],
    'slow internet speed': [
      'Run a speed test on speedtest.net to confirm actual speeds.',
      'Restart your router and check for firmware updates.',
      'Limit bandwidth-heavy apps (streaming, torrents, cloud sync).',
      'Move closer to the router or use a wired Ethernet connection.',
      'Contact your ISP if speeds are consistently below your plan.',
    ],
    'wi-fi not detected': [
      'Ensure Wi-Fi is enabled in Windows Settings → Network.',
      'Toggle Airplane mode off and on.',
      'Update the wireless adapter driver in Device Manager.',
      'Run: netsh winsock reset, then restart.',
    ],
    'dns server not responding': [
      'Change DNS to Google DNS (8.8.8.8) or Cloudflare (1.1.1.1).',
      'Flush DNS: ipconfig /flushdns in Command Prompt.',
      'Restart your router.',
      'Disable IPv6 temporarily in adapter settings.',
    ],
    'vpn not connecting': [
      'Check your internet connection works without the VPN.',
      'Try a different VPN server location.',
      'Update the VPN client to the latest version.',
      'Change the VPN protocol (OpenVPN, WireGuard, IKEv2).',
      'Temporarily disable firewall/antivirus to test.',
    ],

    // ── Hard Drive ───────────────────────────────────────────────────────────
    'hard drive not detected': [
      'Check SATA/data cable connections inside the PC.',
      'Try a different SATA port on the motherboard.',
      'Enter BIOS and check if the drive is listed.',
      'Try the drive in another computer or an external enclosure.',
    ],
    'clicking or grinding noise': [
      'Back up your data immediately — the drive may be failing.',
      'Do NOT attempt to open the drive yourself.',
      'Use data recovery software (Recuva, EaseUS) if data is critical.',
      'Replace the drive — mechanical noise indicates imminent failure.',
    ],
    'slow disk performance': [
      'Run chkdsk /f /r from an elevated Command Prompt.',
      'Defragment the drive (HDD only — never defrag an SSD).',
      'Check SMART status with CrystalDiskInfo.',
      'Free up space — keep at least 15% of the drive empty.',
    ],
    'disk full — no space': [
      'Run Disk Cleanup and remove temporary files.',
      'Use WinDirStat or TreeSize to find large files.',
      'Move media files to an external drive.',
      'Uninstall unused programs.',
    ],
    'corrupted files / sectors': [
      'Run chkdsk /f /r to scan and repair bad sectors.',
      'Run sfc /scannow for system file corruption.',
      'Back up important data immediately.',
      'Consider cloning the drive and replacing it.',
    ],

    // ── Display ──────────────────────────────────────────────────────────────
    'no display output': [
      'Ensure the monitor is powered on and the correct input is selected.',
      'Check the video cable (HDMI/DisplayPort/VGA) connection.',
      'Try a different cable or port.',
      'If using a dedicated GPU, ensure the monitor is connected to it (not motherboard).',
      'Reseat the GPU and check power cables.',
    ],
    'flickering screen': [
      'Update or reinstall the graphics driver.',
      'Try a different video cable.',
      'Lower the refresh rate in Display settings.',
      'Test with a different monitor to isolate the issue.',
    ],
    'black screen on boot': [
      'Boot into Safe Mode (interrupt boot 3 times or use a recovery USB).',
      'Uninstall recent display driver updates.',
      'Try connecting to a different display/TV.',
      'Reseat the GPU and check power connections.',
    ],
    'wrong resolution': [
      'Right-click desktop → Display settings → change resolution.',
      'Update the graphics driver.',
      'If the correct resolution is missing, reinstall the monitor driver.',
      'Check the monitor\'s native resolution in its manual.',
    ],
      'dead pixels': [
        'Use a stuck pixel fixer tool (JScreenFix) for stuck pixels.',
        'Apply gentle pressure with a soft cloth on the dead pixel area.',
        'Check the monitor warranty — many manufacturers cover dead pixels.',
        'True dead pixels (black) usually cannot be fixed and may require replacement.',
      ],

    // ── Mobile ────────────────────────────────────────────────────────────────
    'battery draining too fast': [
      'Check for power-hungry apps in Settings → Battery → Battery usage.',
      'Reduce screen brightness and set a shorter screen timeout.',
      'Disable background app refresh for non-essential apps.',
      'Turn off GPS, Bluetooth, and Wi-Fi when not in use.',
      'Replace the battery if health is degraded (check via Settings → Battery → Battery health).',
    ],
    'phone overheating': [
      'Remove the phone case while charging or gaming.',
      'Close background apps that may be overloading the processor.',
      'Avoid direct sunlight and hot environments.',
      'Update apps and the OS to the latest version.',
      'If persistent, check battery health and consider replacement.',
    ],
    'apps crashing on phone': [
      'Restart the phone to clear temporary glitches.',
      'Clear the app cache in Settings → Apps → select app → Storage → Clear cache.',
      'Update the app from Google Play / App Store.',
      'Uninstall and reinstall the problematic app.',
      'Reset app preferences if multiple apps crash (Settings → Apps → Reset app preferences).',
    ],
    'phone not charging': [
      'Try a different charging cable and power adapter.',
      'Clean the charging port gently with a toothpick or compressed air.',
      'Check for debris or lint stuck inside the port.',
      'Restart the phone while connected to the charger.',
      'If the issue persists, the charging port may need professional repair.',
    ],
    'slow phone performance': [
      'Restart the phone to clear temporary system files.',
      'Clear cached data in Settings → Storage → Cached data.',
      'Uninstall unused apps to free up storage.',
      'Reduce animations in Developer options (Settings → Developer options → Window animation scale → 0.5x).',
      'Keep at least 10% of storage free for smooth operation.',
    ],

    // ── Gaming ────────────────────────────────────────────────────────────────
    'game crashing on startup': [
      'Update your graphics driver to the latest version.',
      'Verify game files through Steam/launcher (Properties → Local files → Verify integrity).',
      'Disable overlays (Discord, Steam, GeForce Experience) and try again.',
      'Run the game as Administrator.',
      'Lower game graphics settings temporarily to reduce strain.',
    ],
    'low fps in games': [
      'Lower in-game graphics settings (shadows, reflections, anti-aliasing).',
      'Update graphics drivers from the manufacturer website.',
      'Close background applications consuming CPU/GPU resources.',
      'Disable V-Sync in the game or GPU control panel.',
      'Check for thermal throttling — monitor CPU and GPU temperatures with MSI Afterburner.',
    ],
    'controller not connecting': [
      'Check that the controller has fresh batteries or is charged.',
      'Re-pair the controller via Bluetooth (remove and re-add in Windows Bluetooth settings).',
      'Update controller firmware using the manufacturer app.',
      'Try a different USB cable for wired controllers.',
      'Test the controller on another device to confirm it works.',
    ],
    'game audio stuttering': [
      'Set audio sample rate to 44100 or 48000 Hz in Sound → Properties → Advanced.',
      'Update audio and chipset drivers.',
      'Disable audio enhancements in Sound → Properties → Enhancements.',
      'Reduce audio buffer size in the game settings.',
      'Switch from wireless to wired headphones to rule out Bluetooth latency.',
    ],
    'graphics driver crash': [
      'Perform a clean reinstall of graphics drivers using DDU (Display Driver Uninstaller) in Safe Mode.',
      'Lower GPU clock speeds using MSI Afterburner or similar.',
      'Check GPU temperatures and ensure fans are spinning properly.',
      'Verify your power supply can handle the GPU under load.',
      'Disable any GPU overclocking and revert to stock speeds.',
    ],

    // ── Smart Home ────────────────────────────────────────────────────────────
    'smart device offline': [
      'Verify the device is powered on (check power cable or batteries).',
      'Restart your router and the smart device.',
      'Ensure the device is connected to the correct 2.4 GHz Wi-Fi network.',
      'Move the device closer to the router to improve signal strength.',
      'Re-pair the device using the manufacturer app.',
    ],
    'voice assistant not responding': [
      'Check that the microphone is not muted on the device.',
      'Restart the voice assistant device.',
      'Verify the internet connection is working.',
      'Update the voice assistant firmware through the app.',
      'Re-link the device in the voice assistant app settings.',
    ],
    'smart light not connecting': [
      'Ensure the light bulb is screwed in and the switch is on.',
      'Toggle the wall switch off and on to reset the bulb.',
      'Check that the bulb is compatible with your smart home hub.',
      'Reset the bulb (usually by turning the switch on/off 5 times quickly).',
      'Re-pair the bulb through the manufacturer app.',
    ],
    'home hub setup failed': [
      'Ensure the hub is connected via Ethernet (if required) and powered on.',
      'Use the latest version of the manufacturer app.',
      'Restart the hub and router before retrying setup.',
      'Check firewall settings on your network that may block the hub.',
      'Contact manufacturer support if setup continues to fail.',
    ],
    'automation not triggering': [
      'Verify all devices in the automation are online and responsive.',
      'Check that conditions and triggers are configured correctly.',
      'Update the hub firmware and the manufacturer app.',
      'Delete and recreate the automation from scratch.',
      'Ensure all devices support the automation action type (on/off, dim, etc.).',
    ],

    // ── Networking ───────────────────────────────────────────────────────
    'dns lookup failing': [
      'Flush the DNS cache: ipconfig /flushdns in Command Prompt.',
      'Switch to a public DNS server like Google (8.8.8.8) or Cloudflare (1.1.1.1).',
      'Restart the DNS Client service in services.msc.',
      'Check the hosts file for incorrect entries blocking DNS resolution.',
      'Verify the network adapter DNS settings are configured correctly.',
    ],
    'dhcp not assigning ip': [
      'Restart the DHCP service on the router or server.',
      'Check that the DHCP scope has available IP addresses.',
      'Verify the device is set to obtain an IP address automatically.',
      'Restart the device and check if it gets an IP via ipconfig /renew.',
      'Check for IP conflicts — two devices with the same static IP break DHCP.',
    ],
    'vpn tunnel drops': [
      'Check the VPN client for keep-alive or dead peer detection settings.',
      'Switch to a more stable VPN protocol (WireGuard or IKEv2 over UDP).',
      'Ensure the MTU size is not causing fragmentation on the VPN interface.',
      'Update the VPN client firmware and server configuration.',
      'Check for NAT traversal issues if the tunnel drops behind a router.',
    ],
    'port scan detected': [
      'Identify the source IP and block it in the firewall immediately.',
      'Enable port scan detection and rate limiting on the firewall.',
      'Close unnecessary open ports using netstat -an and firewall rules.',
      'Enable intrusion detection system (IDS) alerts for suspicious activity.',
      'Review and harden exposed services — disable unused protocols and ports.',
    ],
    'firewall rule corruption': [
      'Export the current firewall configuration as a backup before changes.',
      'Reset the firewall to defaults: netsh advfirewall reset in Command Prompt.',
      'Re-import known-good firewall rules from backup or policy template.',
      'Check Group Policy for conflicting firewall rules pushed to the device.',
      'Verify each rule individually by disabling and re-enabling them one at a time.',
    ],
    'nat translation error': [
      'Check the NAT table on the router for full or stale entries.',
      'Increase the NAT table timeout for TCP/UDP sessions if needed.',
      'Verify the correct NAT type is configured (static, dynamic, or PAT).',
      'Restart the router to clear the NAT table and rebuild translations.',
      'Check for IP conflicts between the WAN and LAN interfaces.',
    ],
    'bandwidth being drained': [
      'Use network monitoring tools (Wireshark, NetFlow) to identify the source.',
      'Check for background updates, cloud sync, or streaming consuming bandwidth.',
      'Enable QoS on the router to prioritize critical traffic.',
      'Identify and disconnect rogue devices on the network.',
      'Set bandwidth limits per device using router traffic shaping settings.',
    ],
    'routing loop detected': [
      'Check routing tables for duplicate or conflicting routes on all routers.',
      'Verify no two routers are advertising the same subnet.',
      'Enable split horizon or route poisoning on distance-vector protocols.',
      'Use traceroute to identify where the loop begins and fix the route.',
      'Simplify the network topology to reduce routing complexity.',
    ],
    'wifi signal disappearing': [
      'Check for Wi-Fi channel interference from neighboring networks.',
      'Update the wireless access point firmware to the latest version.',
      'Reposition the access point to a central location away from obstructions.',
      'Switch between 2.4 GHz and 5 GHz bands to avoid congestion.',
      'Check if the wireless radio is being jammed or experiencing interference.',
    ],
    'bgp route hijacked': [
      'Immediately verify the legitimate route origin and announce the correct prefix.',
      'Enable RPKI (Resource Public Key Infrastructure) to validate route origins.',
      'Contact the upstream ISP to filter the unauthorized BGP announcements.',
      'Implement BGP prefix filtering to only accept routes from trusted peers.',
      'Monitor BGP update feeds for unexpected route changes in real time.',
    ],
    'iot botnet infection': [
      'Isolate the infected IoT device from the network immediately.',
      'Change all default passwords on the device and network accounts.',
      'Update the device firmware to the latest patched version.',
      'Set up network segmentation with VLANs to contain IoT traffic.',
      'Monitor outbound traffic for known C&C server IPs and block them.',
    ],
    'protocol stack corruption': [
      'Reset the TCP/IP stack: netsh int ip reset in Command Prompt.',
      'Reinstall the network adapter driver from the manufacturer website.',
      'Run the Windows Network Troubleshooter to auto-detect stack issues.',
      'Check for malware that may have modified the protocol stack.',
      'Verify the Winsock catalog with netsh winsock reset and restart.',
    ],
    'network total lockdown': [
      'Check physical connections — verify cables, switches, and patch panels.',
      'Restart all core networking equipment (switches, routers, firewalls).',
      'Identify if the lockdown is caused by a security policy or a failure.',
      'Check spanning tree protocol status for blocked ports.',
      'Verify VLAN configurations and trunk links between switches.',
    ],
    'switch loop detected': [
      'Identify the loop by checking for broadcast storms and high CPU on switches.',
      'Enable Spanning Tree Protocol (STP) on all switches to prevent loops.',
      'Trace the physical cabling to find the redundant connection causing the loop.',
      'Disable the offending port until the cabling is corrected.',
      'Implement port security to limit the number of MAC addresses per port.',
    ],
    'cable certification failed': [
      'Test the cable with a cable certifier to identify the failure point.',
      'Check for cable damage — kinks, cuts, or improper termination.',
      'Re-terminate the cable ends using the correct T568A or T568B standard.',
      'Replace the cable if it fails certification beyond acceptable limits.',
      'Verify the cable category matches the required speed (Cat5e for Gigabit).',
    ],

    // ── Core Components (new) ──────────────────────────────────────────────
    'overclocking unstable': [
      'Reset BIOS to default settings to remove all overclocks.',
      'Increase CPU voltage slightly (Vcore) in small 0.025V increments.',
      'Run a stress test (Prime95 or AIDA64) for at least 30 minutes.',
      'Monitor temperatures — keep below 85°C under load.',
      'If still unstable, reduce clock speed to the highest stable frequency.',
    ],
    'power supply failure': [
      'Check if the PSU fan spins when the PC is powered on.',
      'Test with a known-good PSU if available (swap test).',
      'Use a PSU tester or multimeter to check voltage rails (+12V, +5V, +3.3V).',
      'Inspect for bulging capacitors or burn marks on the PSU.',
      'Replace the PSU if voltages are out of spec or it fails to power on.',
    ],
    'usb port not working': [
      'Try a different USB port on the same computer.',
      'Check Device Manager for yellow warning icons on USB controllers.',
      'Uninstall and reinstall the USB controller driver in Device Manager.',
      'Check BIOS to ensure USB ports are enabled.',
      'Test the device on another computer to rule out device failure.',
    ],
    'thermal throttling': [
      'Open HWMonitor or Core Temp to confirm throttling temperatures.',
      'Clean dust from all fans and heatsinks with compressed air.',
      'Reapply thermal paste between CPU/GPU and heatsink.',
      'Improve case airflow — add case fans or improve cable management.',
      'Consider upgrading the CPU cooler if stock cooler is insufficient.',
    ],
    'pc randomly restarts': [
      'Check Windows Event Viewer for critical errors around the restart time.',
      'Run Windows Memory Diagnostic to test for RAM issues.',
      'Monitor CPU and GPU temperatures for thermal shutdowns.',
      'Test the PSU with a PSU tester — failing PSU causes random restarts.',
      'Update BIOS and all device drivers to latest versions.',
    ],
    'nvme ssd not recognized': [
      'Enter BIOS and check if the NVMe drive appears in the storage list.',
      'Try a different M.2 slot if your motherboard has multiple.',
      'Update BIOS to the latest version for NVMe compatibility.',
      'Ensure the M.2 slot is set to NVMe mode (not SATA) in BIOS.',
      'Test the drive in another M.2 slot or an external NVMe enclosure.',
    ],

    // ── RAM (new) ──────────────────────────────────────────────────────────
    'dual channel not working': [
      'Check that both RAM sticks are in the correct slots (usually A2 and B2).',
      'Enter BIOS and verify dual-channel mode is enabled.',
      'Test with both sticks individually to rule out a faulty module.',
      'Update BIOS — some boards need updates for proper dual-channel support.',
      'Ensure both sticks have matching speed, timings, and voltage.',
    ],
    'memory leak detection': [
      'Open Task Manager → Performance → Memory and check "In use" trend.',
      'Use Resource Monitor to identify processes with growing memory usage.',
      'Update the application causing the leak to its latest version.',
      'Restart the leaking application to free the consumed memory.',
      'Run Windows Memory Diagnostic to rule out hardware-level leaks.',
    ],
    'ecc memory error': [
      'Check the motherboard BIOS for ECC support and ensure it is enabled.',
      'Run a memory test (MemTest86) to identify the faulty DIMM.',
      'Reseat the ECC RAM sticks and clean contacts.',
      'Check server logs for corrected error counts — increasing errors mean failure.',
      'Replace the DIMM if uncorrectable errors occur or error count rises.',
    ],
    'xmp profile fails': [
      'Reset BIOS to defaults and try enabling XMP again.',
      'Manually set RAM frequency, timings, and voltage instead of using XMP.',
      'Test with one stick at a time to identify which module causes instability.',
      'Update BIOS — newer versions often improve XMP compatibility.',
      'If XMP still fails, run RAM at stock JEDEC speeds (no overclock).',
    ],

    // ── Operating System (new) ─────────────────────────────────────────────
    'registry corruption': [
      'Boot into Safe Mode and run "sfc /scannow" from an elevated Command Prompt.',
      'Run "DISM /Online /Cleanup-Image /RestoreHealth" to repair the system image.',
      'Use System Restore to revert to a restore point before the corruption.',
      'If boot fails, use a Windows recovery USB and run sfc from there.',
      'As a last resort, reset Windows while keeping personal files.',
    ],
    'application crash loop': [
      'Open Task Manager and end the crashing application process.',
      'Check Windows Event Viewer → Application logs for the crash error code.',
      'Update the application to the latest version from the developer.',
      'Reinstall the application after completely uninstalling it.',
      'Check for missing Visual C++ Redistributable or .NET Framework.',
    ],
    'user profile corrupted': [
      'Boot into Safe Mode and log in with a different administrator account.',
      'Open Registry Editor and navigate to HKLM\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\ProfileList.',
      'Delete the .bak profile entry for the corrupted account.',
      'Restart and log in — Windows will recreate the profile from the default.',
      'Copy personal files from C:\\Users\\OldProfile to the new profile.',
    ],
    'kernel security check': [
      'Boot into Safe Mode and run "sfc /scannow".',
      'Run "DISM /Online /Cleanup-Image /RestoreHealth".',
      'Update all device drivers, especially storage and network drivers.',
      'Run Windows Memory Diagnostic to check for RAM errors.',
      'If the error persists, use System Restore to revert to a working state.',
    ],

    // ── Audio (new) ────────────────────────────────────────────────────────
    'headphones only one side': [
      'Test the headphones on another device to confirm the issue.',
      'Check the audio balance in Settings → Sound → Output → Device properties → Balance.',
      'Clean the headphone jack with compressed air — debris can block a channel.',
      'Inspect the headphone cable for damage or kinks near the plug.',
      'Try a different pair of headphones to rule out the audio jack.',
    ],
    'bluetooth audio choppy': [
      'Move closer to the PC — reduce distance to under 3 meters.',
      'Remove other Bluetooth devices to reduce interference.',
      'Update Bluetooth adapter driver from Device Manager.',
      'Disable Wi-Fi or switch to 5 GHz to reduce 2.4 GHz congestion.',
      'Try switching audio codec to SBC in Bluetooth developer settings.',
    ],
    'audio crackling noise': [
      'Disable audio enhancements in Sound → Properties → Enhancements.',
      'Change the sample rate to 16-bit 44100Hz in Sound → Properties → Advanced.',
      'Update the audio driver from the motherboard manufacturer website.',
      'Check for electromagnetic interference — move speakers away from the PC.',
      'Try a different USB port if using a USB audio device.',
    ],
    'sound services stopped': [
      'Open Services (services.msc) and find "Windows Audio".',
      'Right-click → Properties and set Startup type to "Automatic".',
      'Click "Start" if the service is stopped, then Apply.',
      'Repeat for "Windows Audio Endpoint Builder" service.',
      'Restart the PC and verify sound works.',
    ],

    // ── Peripherals (new) ──────────────────────────────────────────────────
    'webcam not working': [
      'Check if the webcam is physically blocked or has a privacy shutter.',
      'Open Device Manager and look for the webcam under "Cameras" or "Imaging devices".',
      'Uninstall and reinstall the webcam driver.',
      'Check app permissions — go to Settings → Privacy → Camera and allow access.',
      'Test the webcam in another app (e.g., Camera app or Zoom) to isolate the issue.',
    ],
    'gaming controller drift': [
      'Calibrate the controller in Windows: Settings → Devices → Controllers → Calibrate.',
      'Clean around the analog stick with compressed air.',
      'Update controller firmware through the manufacturer app.',
      'Increase the dead zone in the game or controller settings.',
      'If persistent, the analog stick module may need replacement.',
    ],
    'touchpad freezing': [
      'Update the touchpad driver from the laptop manufacturer website.',
      'Check if the issue occurs with an external mouse (rules out software).',
      'Disable and re-enable the touchpad in Device Manager.',
      'Adjust touchpad sensitivity in Settings → Devices → Touchpad.',
      'Boot into Safe Mode to check if a third-party app is causing the freeze.',
    ],
    'usb hub overload': [
      'Unplug all devices from the hub and reconnect one at a time.',
      'Check if the hub has its own power adapter — use a powered hub for devices.',
      'Move high-power devices (external drives) to a motherboard USB port.',
      'Update the USB hub driver in Device Manager.',
      'Replace the hub if it continues to fail under normal load.',
    ],

    // ── Software (new) ─────────────────────────────────────────────────────
    'app won\'t open': [
      'Restart the computer and try opening the app again.',
      'Check Task Manager for a hanging process — end it and retry.',
      'Run the app as Administrator (right-click → Run as administrator).',
      'Reinstall the app after completely uninstalling it.',
      'Check Windows Event Viewer for the specific crash error.',
    ],
    'antivirus conflict': [
      'Check if two antivirus programs are installed — uninstall one.',
      'Add the conflicting program to the antivirus exclusion/whitelist.',
      'Update both the antivirus and the conflicting program.',
      'Temporarily disable the antivirus to test if it is the cause.',
      'Switch to Windows Defender if third-party AV causes persistent conflicts.',
    ],
    'windows store error': [
      'Run the Windows Store Apps troubleshooter (Settings → Troubleshoot).',
      'Reset the Microsoft Store cache: run "wsreset.exe" from the Run dialog.',
      'Sign out and sign back into your Microsoft account.',
      'Check that the Windows Update and BITS services are running.',
      'Re-register the Store app: run PowerShell command from Microsoft support.',
    ],
    'software permission denied': [
      'Right-click the program → Properties → Security tab → check permissions.',
      'Run the program as Administrator.',
      'Take ownership of the file/folder: right-click → Properties → Security → Advanced.',
      'Check if antivirus or UAC is blocking the program.',
      'Reinstall the program to a location where you have full permissions.',
    ],

    // ── Internet (new) ─────────────────────────────────────────────────────
    'ethernet cable unplugged': [
      'Check both ends of the Ethernet cable are firmly plugged in.',
      'Try a different Ethernet cable to rule out cable damage.',
      'Test a different port on the router or switch.',
      'Check Device Manager for the Ethernet adapter — reinstall driver if disabled.',
      'Run the Windows Network Troubleshooter.',
    ],
    'ip address conflict': [
      'Restart the router to release and renew all DHCP leases.',
      'On the affected PC, run "ipconfig /release" then "ipconfig /renew".',
      'Set the adapter to obtain an IP address automatically (DHCP).',
      'If using static IPs, ensure no two devices share the same address.',
      'Check the router DHCP scope to ensure it is not exhausted.',
    ],
    'packet loss detected': [
      'Run a continuous ping test: ping 8.8.8.8 -t and watch for drops.',
      'Restart the router and modem.',
      'Check for faulty Ethernet cables or loose connections.',
      'Test with a wired connection to rule out Wi-Fi interference.',
      'Contact your ISP if packet loss persists beyond your local network.',
    ],
    'proxy not working': [
      'Disable the proxy temporarily: Settings → Network → Proxy → turn off.',
      'Check the proxy address and port for typos.',
      'Test without proxy to confirm the proxy is the issue.',
      'Clear browser proxy settings and reconfigure if needed.',
      'Contact your network admin if this is a corporate proxy.',
    ],

    // ── Storage (new) ──────────────────────────────────────────────────────
    'ssd write protection': [
      'Check if the SSD has a physical write-protect switch (rare).',
      'Open Disk Management and check if the disk is read-only.',
      'Run "diskpart" → "list disk" → "select disk N" → "attributes disk clear readonly".',
      'Update the SSD firmware from the manufacturer website.',
      'If persistent, the SSD controller may be failing — back up and replace.',
    ],
    'partition not mounting': [
      'Open Disk Management and check if the partition has a drive letter.',
      'Right-click the partition → "Change Drive Letter and Paths" → assign one.',
      'If the partition is RAW, run "chkdsk /f" to repair the file system.',
      'Check if the partition is encrypted (BitLocker) and unlock it.',
      'Use disk repair software if the partition table is corrupted.',
    ],
    'raid array failed': [
      'Open the RAID controller BIOS or management software to check array status.',
      'Identify which disk is degraded or missing from the array.',
      'Reseat the failed disk — check SATA/SAS cables and power.',
      'Replace the failed disk and let the array rebuild.',
      'Restore from backup if the array is unrecoverable.',
    ],
    'disk read error': [
      'Run "chkdsk /f /r" from an elevated Command Prompt.',
      'Check SATA data cable — try a different port on the motherboard.',
      'Test the drive in another computer or an external enclosure.',
      'Check SMART status with CrystalDiskInfo for impending failure signs.',
      'Back up data immediately — read errors often precede total drive failure.',
    ],

    // ── Display (new) ──────────────────────────────────────────────────────
    'color calibration off': [
      'Open Settings → Display → Night light and ensure it is off.',
      'Run the built-in color calibration tool: search "dccw" in Start menu.',
      'Check if the monitor has a "Reset to factory" option in its OSD menu.',
      'Update the graphics driver and check color settings in the GPU control panel.',
      'Use a hardware color calibrator for professional accuracy.',
    ],
    'refresh rate stuck': [
      'Right-click desktop → Display settings → Advanced display → choose refresh rate.',
      'Update the graphics driver from the manufacturer website.',
      'Check the monitor OSD to ensure it supports the desired refresh rate.',
      'Use a different cable — some cables (HDMI 1.4) limit refresh rate.',
      'In GPU control panel (NVIDIA/AMD), set refresh rate manually.',
    ],
    'multiple monitor issue': [
      'Right-click desktop → Display settings → Detect to find the second monitor.',
      'Try a different cable or port on the GPU.',
      'Update the graphics driver.',
      'Check if the monitor is set to the correct input source.',
      'Extend or duplicate the display in Display settings → Multiple displays.',
    ],
    'monitor input lag': [
      'Enable "Game Mode" or "Low Latency Mode" in the monitor OSD.',
      'Disable V-Sync in the GPU control panel or game settings.',
      'Use a higher refresh rate monitor if available.',
      'Connect via DisplayPort instead of HDMI for lower latency.',
      'Check for "Signal Processing" or "Post-Processing" settings and disable them.',
    ],

    // ── Mobile (new) ───────────────────────────────────────────────────────
    'mobile data not working': [
      'Toggle Airplane mode on and off to reset the cellular connection.',
      'Check that mobile data is enabled in Settings → Network & Internet.',
      'Restart the phone to re-register with the cellular network.',
      'Check APN settings — reset to carrier defaults if changed.',
      'Contact your carrier if data is not working on all apps.',
    ],
    'fingerprint scanner error': [
      'Clean the fingerprint sensor with a dry microfiber cloth.',
      'Remove and re-register your fingerprint in Settings → Security.',
      'Ensure your finger is clean and dry when scanning.',
      'Update the phone software — fingerprint bugs are often fixed in updates.',
      'If persistent, the sensor may need professional repair.',
    ],
    'bluetooth pairing failed': [
      'Turn Bluetooth off and on again on both devices.',
      'Delete the pairing entry and pair from scratch.',
      'Ensure both devices are in pairing mode and within 3 meters.',
      'Restart both devices before retrying.',
      'Check for firmware updates on the Bluetooth accessory.',
    ],
    'battery health degraded': [
      'Check battery health in Settings → Battery → Battery health.',
      'Reduce charging speed — avoid fast charging if battery degrades quickly.',
      'Keep battery between 20% and 80% for optimal longevity.',
      'Avoid using the phone while charging to reduce heat.',
      'If health is below 80%, consider a battery replacement at a service center.',
    ],

    // ── Gaming (new) ───────────────────────────────────────────────────────
    'game freezing mid-play': [
      'Lower in-game graphics settings to reduce GPU/CPU load.',
      'Update graphics drivers to the latest version.',
      'Monitor temperatures — freezing often indicates thermal throttling.',
      'Close background apps to free RAM and CPU resources.',
      'Verify game files through the launcher (Steam → Properties → Local files).',
    ],
    'shader compilation error': [
      'Delete the game\'s shader cache folder and relaunch the game.',
      'Update graphics drivers — shader compilation bugs are often driver-related.',
      'Restart the PC and launch the game fresh.',
      'Lower graphics settings to reduce shader complexity.',
      'Reinstall the game if the error persists after cache deletion.',
    ],
    'anti-cheat false positive': [
      'Update the anti-cheat software (EasyAntiCheat, BattlEye) from the game folder.',
      'Add the game and anti-cheat folder to antivirus exclusions.',
      'Run the game as Administrator.',
      'Uninstall and reinstall the anti-cheat service via the game\'s repair option.',
      'Contact the game\'s support with the specific error code.',
    ],
    'game save corrupted': [
      'Check for cloud save sync conflicts in the game launcher.',
      'Look for manual backup saves in the game\'s save folder.',
      'Disable cloud sync, delete the corrupted save, and let it resync.',
      'Use file recovery software if the save was accidentally overwritten.',
      'Start a new game if the save cannot be recovered.',
    ],

    // ── Smart Home (new) ───────────────────────────────────────────────────
    'smart lock jammed': [
      'Check the battery level — low batteries cause mechanical jams.',
      'Manually lock/unlock with the physical key to reset the mechanism.',
      'Remove the battery pack for 30 seconds to hard-reset the lock.',
      'Ensure the deadbolt moves freely without the lock installed.',
      'Re-pair the lock in the manufacturer app after resetting.',
    ],
    'thermostat not syncing': [
      'Check that the thermostat is connected to Wi-Fi (check signal strength).',
      'Restart the thermostat by removing it from the wall plate for 30 seconds.',
      'Restart your router to refresh the network connection.',
      'Update the thermostat firmware through the companion app.',
      'Re-link the thermostat account in the app settings.',
    ],
    'zigbee network down': [
      'Check that the Zigbee hub/coordinator is powered on and connected.',
      'Restart the Zigbee hub by unplugging it for 30 seconds.',
      'Ensure Zigbee devices are within range of the hub (30-50 feet).',
      'Re-pair devices that show as offline in the Zigbee app.',
      'Check for interference from Wi-Fi, microwaves, or other 2.4 GHz devices.',
    ],
    'mqtt broker error': [
      'Check that the MQTT broker service is running on the server.',
      'Verify the broker IP address and port in the client configuration.',
      'Check firewall rules — ensure port 1883 (or 8883 for TLS) is open.',
      'Restart the MQTT broker service.',
      'Check broker logs for connection errors or authentication failures.',
    ],

    // ── Security (new) ─────────────────────────────────────────────────────
    'ransomware encryption': [
      'Disconnect the infected device from the internet and all networks immediately.',
      'Do NOT pay the ransom — recovery is not guaranteed.',
      'Boot into Safe Mode and run a full antivirus scan.',
      'Check if a decryptor tool exists for this ransomware variant (nomoreransom.org).',
      'Restore files from a clean backup if available.',
    ],
    'trojan detected': [
      'Disconnect from the internet to prevent the trojan from communicating.',
      'Boot into Safe Mode to prevent the trojan from running.',
      'Run a full scan with your antivirus in Safe Mode.',
      'Download and run Malwarebytes for a second-opinion scan.',
      'Remove all detected threats and restart normally.',
    ],
    'rootkit hidden process': [
      'Boot into Safe Mode with Networking.',
      'Download and run a rootkit-specific scanner (Kaspersky TDSSKiller or Malwarebytes).',
      'Run "sfc /scannow" and "DISM /Online /Cleanup-Image /RestoreHealth".',
      'Check Task Manager for processes with no name or unusual descriptions.',
      'Consider a full OS reinstall if the rootkit cannot be removed.',
    ],
    'security certificate expired': [
      'Check your system clock — incorrect date/time causes false certificate errors.',
      'Try a different browser to rule out browser-specific issues.',
      'Clear the browser\'s SSL cache (Settings → Privacy → Clear browsing data).',
      'If it is your own certificate, renew it through your certificate authority.',
      'For websites you do not control, the site owner must renew the certificate.',
    ],
    'two factor auth failed': [
      'Check that your device\'s time is synchronized (Settings → Date & Time → Automatic).',
      'Use a backup code if you have one saved.',
      'Try the authenticator app\'s manual code entry if QR scan fails.',
      'Contact the service\'s support to reset 2FA if you lost access.',
      'Set up 2FA again on a new device once access is restored.',
    ],
    'encryption key lost': [
      'Check if you have a backup of the encryption key or recovery key.',
      'Look for the key in your password manager or secure storage.',
      'Contact the service provider — some offer account recovery options.',
      'If BitLocker, check for the recovery key in your Microsoft account.',
      'If no recovery option exists, the encrypted data may be permanently inaccessible.',
    ],
    'app notification missing': [
      'Check that notifications are enabled for the app in Settings → Notifications.',
      'Ensure "Do Not Disturb" mode is not blocking the notifications.',
      'Check battery optimization settings — aggressive optimization may suppress alerts.',
      'Clear the app cache and data, then reconfigure notification preferences.',
      'Update the app and OS to the latest version.',
    ],

    // ── Security ───────────────────────────────────────────────────────────
    'virus or malware infection': [
      'Disconnect from the internet to prevent the malware from spreading or communicating.',
      'Boot into Safe Mode (hold Shift → Restart → Troubleshoot → Startup Settings → Safe Mode with Networking).',
      'Run a full scan with Windows Defender (or your installed antivirus) in Safe Mode.',
      'Download and run Malwarebytes Free for a second-opinion scan.',
      'Quarantine or delete all threats found, then restart normally.',
    ],
    'suspicious pop-ups and browser redirects': [
      'Close all browser tabs and windows immediately.',
      'Open Task Manager and end any unfamiliar browser processes.',
      'Go to your browser settings and remove suspicious extensions/add-ons.',
      'Reset the browser to its default settings (Settings → Reset settings).',
      'Run a full antivirus and Malwarebytes scan to remove any adware.',
    ],
    'computer running slow after virus scare': [
      'Open Task Manager (Ctrl + Shift + Esc) and check for unknown processes using high CPU or memory.',
      'Run a full antivirus scan and remove any detected threats.',
      'Run Malwarebytes to catch anything the antivirus may have missed.',
      'Uninstall any programs you did not install or recognize via Settings → Apps.',
      'Restart the computer and check if performance has improved.',
    ],
    'phishing email received': [
      'Do NOT click any links or download attachments from the email.',
      'Mark the email as spam or phishing in your email client.',
      'Delete the email from your inbox and trash folder.',
      'If you clicked a link, immediately change your passwords for any accounts you may have accessed.',
      'Run a full antivirus scan on your computer in case anything was downloaded.',
    ],
    'suspicious program installed without consent': [
      'Open Settings → Apps and sort by install date to find recently added programs.',
      'Uninstall any program you do not recognize or did not install.',
      'Run a full antivirus and Malwarebytes scan to check for bundled malware.',
      'Check your browser extensions and remove anything unfamiliar.',
      'Enable Windows SmartScreen and UAC to prevent future unwanted installations.',
    ],
    'wi-fi network showing unauthorized devices': [
      'Log in to your router admin page (usually 192.168.0.1 or 192.168.1.1 in a browser).',
      'Check the connected devices list and identify any unknown devices.',
      'Change your Wi-Fi password immediately from the router admin page.',
      'Use WPA3 or WPA2 encryption — avoid WEP or open networks.',
      'Enable MAC address filtering to only allow known devices.',
    ],
    'password not accepted after update': [
      'Ensure Caps Lock is off and you are typing the correct password.',
      'Try the password you used before the most recent password change.',
      'Use the "Forgot password" or "Reset password" option on the login screen.',
      'If on Windows, try logging in with a Microsoft account PIN instead.',
      'Boot into Safe Mode and try the previous password or use an admin account to reset it.',
    ],
    'firewall blocking legitimate apps': [
      'Open Windows Security → Firewall & network protection → Allow an app through firewall.',
      'Click "Change settings" and check the boxes for the app on Private and/or Public networks.',
      'If the app is not listed, click "Allow another app" and browse to the program.',
      'Verify the app works after adding the firewall exception.',
      'If using a third-party firewall, add the same exception in that firewall\'s settings.',
    ],

    // ── Boss Battles Easy/Medium/Hard ────────────────────────────────────────────
    'boss_bone_colossus_1': [
      'Prepare for the Bone Colossus — a skeleton made of PC cases.',
      'Target its weak joints with precise attacks.',
      'Avoid its crushing blows by staying mobile.',
      'Strike when it rears back to slam the ground.',
      'Defeat it with focused hardware knowledge.',
    ],
    'boss_memory_wraith_1': [
      'The Memory Wraith feeds on corrupted RAM.',
      'Use memory check spells to weaken it.',
      'Target its flickering form with data scans.',
      'Keep your own memory stable to avoid its drain.',
      'Purify it with a clean memory test.',
    ],
    'boss_lich_lord_1': [
      'The Lich Lord rises from corrupted boot files.',
      'Its touch freezes processes mid-execution.',
      'Use system restore incantations.',
      'Target its phylactery — the registry.',
      'Banish it with proper cleanup rituals.',
    ],
    'boss_static_specter_1': [
      'Static Specter crackles with audio interference.',
      'Sound waves distort into painful shrieks.',
      'Seek the frequency that disrupts its form.',
      'Target its resonance with proper tuning.',
      'Silence it with the right balance.',
    ],
    'boss_goblin_king_1': [
      'Goblin King sabotages all connected devices.',
      'Tangled cables whip out from its throne.',
      'Cut the magical connections cleanly.',
      'Avoid its trap-laden workshop.',
      'Strike its crown to break its control.',
    ],
    'boss_glitch_1': [
      'The Glitch corrupts reality itself.',
      'Spells fail and code breaks mid-cast.',
      'Use clean reinstall techniques.',
      'Target its fragmented existence.',
      'Patch it into submission.',
    ],
    'boss_dragon_whelp_1': [
      'Dragon Whelp hoards network packets.',
      'Its breath is pure bandwidth theft.',
      'Cut off its connection to the router.',
      'Use cable management to restrain it.',
      'Seal its hoard with proper config.',
    ],
    'boss_void_disk_1': [
      'Void Disk devours data on contact.',
      'Files disappear into its endless maw.',
      'Use backup restoration on the spot.',
      'Target its sectors before they corrupt.',
      'Close it with perfect partitioning.',
    ],
    'boss_beholder_1': [
      "Beholder's eye rays corrupt displays.",
      'Screen flickers under its gaze.',
      'Use display calibration to resist.',
      'Target each eye with proper settings.',
      'Blind it with correct resolution.',
    ],
    'boss_battery_wraith_1': [
      'Battery Wraith drains all power sources.',
      'Devices lose charge instantly.',
      'Use power management counterspells.',
      'Target its energy vampires.',
      'Restore power with proper cycling.',
    ],
    'boss_lag_dragon_1': [
      'Lag Dragon drops frames with each breath.',
      'Input delay grows exponentially.',
      'Use performance optimization.',
      'Target its processing bottleneck.',
      'Freeze it with perfect timing.',
    ],
    'boss_malware_beast_1': [
      'Malware Beast corrupts with viral code.',
      'Infection spreads to all files.',
      'Use antivirus quarantine walls.',
      'Target its main infection vector.',
      'Cleanse it with proper scan.',
    ],
  };

  /// Variant phrasings → canonical solution key.
  static final Map<String, String> _aliases = {
    // ── Core Components ──
    'motherboard cmos battery dead': 'computer not turning on',
    'pcie slot not working': 'cpu not detected in bios',
    'gpu not detected': 'cpu not detected in bios',
    'bios recovery needed': 'beep codes on startup',
    'hardware compatibility issue': 'cpu not detected in bios',
    'case airflow poor': 'cpu overheating',
    'memory overclock failed': 'ram not detected',
    'no power button response': 'computer not turning on',
    'motherboard speaker silent': 'beep codes on startup',
    'cpu upgrade needed': 'cpu not detected in bios',
    'cpu cooler rgb not lighting': 'cpu fan not spinning',
    'system freezes on boot': 'boot loop',

    // ── RAM ──
    'memory overclock unstable': 'ram not detected',
    'ram latency issues': 'ram compatibility issues',
    'memory module defective': 'ram not detected',
    'ram slot damaged': 'ram not detected',
    'memory test failed': 'ram not detected',
    'ram speed mismatch': 'ram compatibility issues',

    // ── Operating System ──
    'system restore failed': 'boot loop',
    'safe mode stuck': 'boot loop',
    'missing dll error': 'dll file missing error',
    'startup repair stuck': 'boot loop',
    'activation failed': 'windows not updating',
    'driver verifier crash': 'blue screen of death (bsod)',

    // ── Audio ──
    'realtek audio missing': 'audio device not found',
    'spatial sound not working': 'no sound output',
    'volume slider disabled': 'no sound output',
    'audio driver rollback': 'audio device not found',
    'dolby atmos not working': 'no sound output',
    'sound randomly cuts out': 'no sound output',

    // ── Peripherals ──
    'headset mic muted': 'microphone not working',
    'scanner not detected': 'printer not responding',
    'external drive slow': 'slow disk performance',
    'bluetooth mouse lag': 'mouse not responding',
    'wireless keyboard delay': 'wireless keyboard lag',

    // ── Software ──
    'license expired': 'program not compatible',
    'subscription not recognized': 'program not compatible',
    'cloud sync failed': 'program running slow',
    'auto updater stuck': 'program running slow',
    'portable app crash': 'program crashes on launch',
    'registry cleaner needed': 'dll file missing error',

    // ── Internet ──
    'router admin locked': 'no internet connection',
    'bandwidth throttling': 'slow internet speed',
    'ftp connection failed': 'no internet connection',
    'ssh timeout error': 'no internet connection',
    'ping high latency': 'slow internet speed',
    'port forwarding stuck': 'no internet connection',

    // ── Storage ──
    'disk defragmentation stuck': 'slow disk performance',
    'storage pool degraded': 'hard drive not detected',
    'file system error': 'corrupted files / sectors',
    'disk cleanup hanging': 'disk full — no space',
    'backup incomplete': 'hard drive not detected',
    'drive letter missing': 'hard drive not detected',

    // ── Display ──
    'hdr not working': 'wrong resolution',
    'oled burn in': 'dead pixels',
    'g-sync not working': 'flickering screen',

    // ── Mobile ──
    'nfc not working': 'bluetooth pairing failed',
    'face unlock failed': 'fingerprint scanner error',
    'over the air update failed': 'slow phone performance',
    'sim card not detected': 'phone not charging',
    'wifi calling failed': 'no internet connection',

    // ── Gaming ──
    'dlss not working': 'graphics driver crash',
    'ray tracing crash': 'graphics driver crash',
    'vram allocation error': 'low fps in games',
    'multiplayer connection failed': 'no internet connection',
    'achievement not unlocking': 'game crashing on startup',
    'game overlay conflict': 'game crashing on startup',

    // ── Smart Home ──
    'smart plug unresponsive': 'smart device offline',
    'hue bridge not found': 'smart device offline',
    'alexa routine failed': 'automation not triggering',
    'google home offline': 'smart device offline',
    'smart speaker muted': 'smart device offline',
    'ir blaster not working': 'smart device offline',

    // ── Security ──
    'spyware infection': 'virus or malware infection',
    'phishing attack blocked': 'phishing email received',
    'security scan hanging': 'virus or malware infection',
    'malware removal tool crash': 'virus or malware infection',
  };

  /// Find a solution for the given problem text.
  static ProblemSolution? solve(String problem) {
    if (problem.isEmpty) return null;
    final p = problem.toLowerCase().trim();

    // 1. Exact match
    if (_solutions.containsKey(p)) {
      return ProblemSolution(problem: problem, category: 'General', steps: _solutions[p]!);
    }

    // 2. Alias lookup
    final aliasTarget = _aliases[p];
    if (aliasTarget != null && _solutions.containsKey(aliasTarget)) {
      return ProblemSolution(problem: problem, category: 'General', steps: _solutions[aliasTarget]!);
    }

    // 3. Substring match in solutions
    for (final entry in _solutions.entries) {
      if (p.contains(entry.key) || entry.key.contains(p)) {
        return ProblemSolution(problem: problem, category: 'General', steps: entry.value);
      }
    }

    // 4. Substring match via aliases
    for (final alias in _aliases.entries) {
      if (p.contains(alias.key) || alias.key.contains(p)) {
        final target = alias.value;
        if (_solutions.containsKey(target)) {
          return ProblemSolution(problem: problem, category: 'General', steps: _solutions[target]!);
        }
      }
    }

    // 5. Keyword fallback
    if (p.contains('display') || p.contains('screen')) {
      return ProblemSolution(problem: problem, category: 'Display', steps: _solutions['no display output']!);
    }
    if (p.contains('cpu') || p.contains('processor')) {
      return ProblemSolution(problem: problem, category: 'CPU', steps: _solutions['high cpu usage']!);
    }
    if (p.contains('wifi') || p.contains('internet')) {
      return ProblemSolution(problem: problem, category: 'Internet', steps: _solutions['no internet connection']!);
    }
    if (p.contains('boot')) {
      return ProblemSolution(problem: problem, category: 'Boot & OS', steps: _solutions["pc won't boot"]!);
    }
    if (p.contains('mouse')) {
      return ProblemSolution(problem: problem, category: 'Peripherals', steps: _solutions['mouse not responding']!);
    }
    if (p.contains('keyboard')) {
      return ProblemSolution(problem: problem, category: 'Peripherals', steps: _solutions['keyboard not responding']!);
    }
    if (p.contains('printer') || p.contains('print')) {
      return ProblemSolution(problem: problem, category: 'Peripherals', steps: _solutions['printer not responding']!);
    }
    if (p.contains('sound') || p.contains('audio')) {
      return ProblemSolution(problem: problem, category: 'Audio', steps: _solutions['no sound output']!);
    }
    if (p.contains('disk') || p.contains('drive') || p.contains('storage')) {
      return ProblemSolution(problem: problem, category: 'Storage', steps: _solutions['slow disk performance']!);
    }
    if (p.contains('network') || p.contains('router') || p.contains('ethernet')) {
      return ProblemSolution(problem: problem, category: 'Internet', steps: _solutions['no internet connection']!);
    }
    if (p.contains('battery') || p.contains('phone') || p.contains('mobile')) {
      return ProblemSolution(problem: problem, category: 'Mobile', steps: _solutions['battery draining too fast']!);
    }
    if (p.contains('game') || p.contains('fps') || p.contains('gpu') || p.contains('graphics')) {
      return ProblemSolution(problem: problem, category: 'Gaming', steps: _solutions['game crashing on startup']!);
    }
    if (p.contains('smart') || p.contains('hub') || p.contains('automation')) {
      return ProblemSolution(problem: problem, category: 'Smart Home', steps: _solutions['smart device offline']!);
    }
    if (p.contains('virus') || p.contains('malware') || p.contains('security') || p.contains('trojan') || p.contains('ransomware')) {
      return ProblemSolution(problem: problem, category: 'Security', steps: _solutions['virus or malware infection']!);
    }
    if (p.contains('password') || p.contains('login') || p.contains('auth')) {
      return ProblemSolution(problem: problem, category: 'Security', steps: _solutions['password not accepted after update']!);
    }

    // Boss battles - partial match
    for (final entry in _solutions.entries) {
      if (entry.key.startsWith('boss_') && (p.contains(entry.key.replaceAll('_', ' ')) || p.contains(entry.key))) {
        return ProblemSolution(problem: problem, category: 'Boss', steps: entry.value);
      }
    }

    return null;
  }

}
