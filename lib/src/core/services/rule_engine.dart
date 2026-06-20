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

  /// Find a solution for the given problem text.
  static ProblemSolution? solve(String problem) {
    if (problem.isEmpty) return null;
    final p = problem.toLowerCase().trim();

    // 1. Exact match
    if (_solutions.containsKey(p)) {
      return ProblemSolution(problem: problem, category: 'General', steps: _solutions[p]!);
    }

    // 2. Partial match
    for (final entry in _solutions.entries) {
      if (p.contains(entry.key) || entry.key.contains(p)) {
        return ProblemSolution(problem: problem, category: 'General', steps: entry.value);
      }
    }

    // 3. Keyword fallback
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

    // Boss battles - direct match
    if (_solutions.containsKey(p)) {
      return ProblemSolution(problem: problem, category: 'Boss', steps: _solutions[p]!);
    }

    // Boss battles - partial match
    for (final entry in _solutions.entries) {
      if (entry.key.startsWith('boss_') && (p.contains(entry.key.replaceAll('_', ' ')) || p.contains(entry.key))) {
        return ProblemSolution(problem: problem, category: 'Boss', steps: entry.value);
      }
    }

    return null;
  }

  static List<String>? solutionsForProblem(String problem) {
    final result = solve(problem);
    return result?.steps;
  }
}
