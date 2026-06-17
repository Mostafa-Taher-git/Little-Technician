import 'package:flutter/material.dart';

class LevelDef {
  final String id;
  final String title;
  final String description;
  final List<String> steps;
  final int points;

  const LevelDef({
    required this.id,
    required this.title,
    required this.description,
    required this.steps,
    this.points = 100,
  });
}

class BossDef {
  final String name;
  final String lore;
  final int hp;
  final int points;

  const BossDef({
    required this.name,
    required this.lore,
    required this.hp,
    this.points = 500,
  });
}

class WorldDef {
  final int id;
  final String name;
  final String description;
  final IconData icon;
  final List<LevelDef> levels;
  final BossDef boss;

  const WorldDef({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.levels,
    required this.boss,
  });
}

class GameData {
  static const List<WorldDef> worlds = [
    WorldDef(
      id: 1,
      name: 'Core Components',
      description: 'CPU, RAM, and motherboard basics',
      icon: Icons.memory,
      levels: [
        LevelDef(
          id: 'cpu_high_usage',
          title: 'High CPU Usage',
          description: 'Your processor is running at 100% constantly',
          steps: [
            'Open Task Manager (Ctrl + Shift + Esc) and sort by CPU column.',
            'Identify and end tasks consuming abnormally high CPU.',
            'Run a full malware scan with Windows Defender or your antivirus.',
            'Disable unnecessary startup programs in Task Manager.',
            'Update drivers and Windows to the latest version.',
          ],
          points: 100,
        ),
        LevelDef(
          id: 'cpu_overheating',
          title: 'CPU Overheating',
          description: 'Processor temperatures are too high',
          steps: [
            'Ensure all case fans are spinning and not blocked by dust.',
            'Re-apply thermal paste between the CPU and cooler.',
            'Check that the CPU cooler is properly seated and mounted.',
            'Improve case airflow with additional fans if needed.',
            'Monitor temperatures with HWMonitor; keep below 85°C.',
          ],
          points: 100,
        ),
        LevelDef(
          id: 'computer_not_turning_on',
          title: 'Computer Not Turning On',
          description: 'No power, no lights, no fans',
          steps: [
            'Verify the power cable is firmly plugged into the PSU and wall outlet.',
            'Check the PSU switch at the back is set to "I" (on).',
            'Try a different power cable and outlet.',
            'Disconnect all peripherals and try powering on again.',
            'If still no power, test with a known-good PSU.',
          ],
          points: 150,
        ),
        LevelDef(
          id: 'beep_codes',
          title: 'Beep Codes on Startup',
          description: 'Motherboard is beeping and won\'t start',
          steps: [
            'Note the beep pattern (e.g., 1 long, 2 short).',
            'Consult your motherboard manual to decode the beep code.',
            'Reseat RAM sticks firmly in their slots.',
            'Reseat the GPU and all expansion cards.',
            'Clear CMOS by removing the battery for 30 seconds.',
          ],
          points: 150,
        ),
        LevelDef(
          id: 'ram_not_detected',
          title: 'RAM Not Detected',
          description: 'System shows less RAM than installed',
          steps: [
            'Reseat the RAM stick firmly until you hear clips snap.',
            'Try a different DIMM slot on the motherboard.',
            'Verify RAM type is compatible with your motherboard.',
            'Clean the gold contacts gently with a pencil eraser.',
            'Test the RAM stick in another computer to confirm it works.',
          ],
          points: 100,
        ),
      ],
      boss: BossDef(
        name: 'The Boot Guardian',
        lore: 'A corrupted BIOS entity that prevents your system from starting. It feeds on configuration errors and loose connections.',
        hp: 5,
        points: 500,
      ),
    ),
    WorldDef(
      id: 2,
      name: 'Operating System',
      description: 'Boot issues, crashes, and OS problems',
      icon: Icons.desktop_windows,
      levels: [
        LevelDef(
          id: 'pc_wont_boot',
          title: 'PC Won\'t Boot',
          description: 'System powers on but no OS loads',
          steps: [
            'Ensure the power cable is properly connected.',
            'Check if the PSU switch is turned on.',
            'Disconnect all external devices and try again.',
            'Enter BIOS and verify the boot drive is detected.',
            'Try booting from a USB recovery drive.',
          ],
          points: 150,
        ),
        LevelDef(
          id: 'boot_loop',
          title: 'Boot Loop',
          description: 'PC keeps restarting before reaching desktop',
          steps: [
            'Boot into Safe Mode (hold Shift while restarting).',
            'Uninstall recently installed drivers or updates.',
            'Run "sfc /scannow" from an elevated Command Prompt.',
            'Disable automatic restart on system failure.',
            'Perform a System Restore to a known-good restore point.',
          ],
          points: 150,
        ),
        LevelDef(
          id: 'bsod',
          title: 'Blue Screen of Death',
          description: 'System crashes with a blue error screen',
          steps: [
            'Note the stop code shown on the BSOD screen.',
            'Boot into Safe Mode and uninstall recently installed drivers.',
            'Run "sfc /scannow" and DISM restore health commands.',
            'Check RAM with Windows Memory Diagnostic.',
            'Update all device drivers from manufacturer websites.',
          ],
          points: 150,
        ),
        LevelDef(
          id: 'os_running_slow',
          title: 'OS Running Slow',
          description: 'Windows feels sluggish and unresponsive',
          steps: [
            'Restart your computer to clear temporary issues.',
            'Run Disk Cleanup and delete temporary files.',
            'Disable visual effects in Performance settings.',
            'Check for malware with a full system scan.',
            'Defragment HDD (not SSD) via Optimize Drives.',
          ],
          points: 100,
        ),
        LevelDef(
          id: 'no_sound',
          title: 'No Sound Output',
          description: 'Speakers or headphones produce no audio',
          steps: [
            'Check that speakers/headphones are plugged in and powered on.',
            'Select the correct output device from the speaker icon.',
            'Run the Windows Audio Troubleshooter.',
            'Reinstall the audio driver from Device Manager.',
            'Check if audio is muted in the application itself.',
          ],
          points: 100,
        ),
      ],
      boss: BossDef(
        name: 'The Kernel Phantom',
        lore: 'A fragmented OS core that corrupts system files on contact. It manifests as a swirling mass of error codes.',
        hp: 6,
        points: 600,
      ),
    ),
    WorldDef(
      id: 3,
      name: 'Peripherals',
      description: 'Mice, keyboards, and printers',
      icon: Icons.keyboard,
      levels: [
        LevelDef(
          id: 'mouse_not_responding',
          title: 'Mouse Not Responding',
          description: 'Cursor won\'t move at all',
          steps: [
            'Try a different USB port.',
            'Check the mouse on another computer to rule out hardware failure.',
            'Update or reinstall the mouse driver in Device Manager.',
            'For wireless mice, replace the battery.',
            'Try a different mouse surface.',
          ],
          points: 100,
        ),
        LevelDef(
          id: 'cursor_lagging',
          title: 'Cursor Lagging',
          description: 'Mouse movement is delayed or stuttering',
          steps: [
            'Update the mouse driver.',
            'Reduce mouse polling rate if using a gaming mouse.',
            'Close CPU-intensive background applications.',
            'Try a different mouse pad surface.',
            'Check for wireless interference.',
          ],
          points: 100,
        ),
        LevelDef(
          id: 'keyboard_not_responding',
          title: 'Keyboard Not Responding',
          description: 'Keys don\'t register when pressed',
          steps: [
            'Try a different USB port or cable.',
            'Check the keyboard on another computer.',
            'Reinstall the keyboard driver in Device Manager.',
            'For PS/2 keyboards, restart the PC after reconnecting.',
            'Check for physical debris under the keys.',
          ],
          points: 100,
        ),
        LevelDef(
          id: 'printer_offline',
          title: 'Printer Offline',
          description: 'Printer shows as offline in Windows',
          steps: [
            'Check the printer power and connection (USB or Wi-Fi).',
            'Set printer as default and use "Use Printer Online".',
            'Restart the Print Spooler service (services.msc).',
            'Reinstall the printer driver.',
            'Restart both printer and computer.',
          ],
          points: 150,
        ),
        LevelDef(
          id: 'paper_jam',
          title: 'Paper Jam',
          description: 'Paper is stuck inside the printer',
          steps: [
            'Turn off the printer and unplug it.',
            'Gently pull the jammed paper in the direction of paper path.',
            'Check for small torn paper pieces inside the printer.',
            'Reload paper correctly and ensure it is not damp.',
            'Run a printer test page to confirm it\'s clear.',
          ],
          points: 100,
        ),
      ],
      boss: BossDef(
        name: 'The I/O Gremlin',
        lore: 'A mischievous entity that swaps your key bindings and inverts your cursor. It thrives on driver conflicts.',
        hp: 5,
        points: 600,
      ),
    ),
    WorldDef(
      id: 4,
      name: 'Software & Network',
      description: 'Programs, internet, and connectivity',
      icon: Icons.wifi,
      levels: [
        LevelDef(
          id: 'program_crashes',
          title: 'Program Crashes on Launch',
          description: 'Application closes immediately after opening',
          steps: [
            'Run the program as Administrator.',
            'Update the program to the latest version.',
            'Check for missing Visual C++ Redistributable or .NET Framework.',
            'Run "sfc /scannow" to repair system files.',
            'Reinstall the program.',
          ],
          points: 100,
        ),
        LevelDef(
          id: 'no_internet',
          title: 'No Internet Connection',
          description: 'Can\'t access websites or online services',
          steps: [
            'Restart your router and modem (unplug for 30 seconds).',
            'Check if other devices on the same network work.',
            'Run the Windows Network Troubleshooter.',
            'Reset network settings via Command Prompt (admin).',
            'Contact your ISP if the issue persists.',
          ],
          points: 150,
        ),
        LevelDef(
          id: 'slow_internet',
          title: 'Slow Internet Speed',
          description: 'Web pages load very slowly',
          steps: [
            'Run a speed test to confirm actual speeds.',
            'Restart your router and check for firmware updates.',
            'Limit bandwidth-heavy apps (streaming, torrents).',
            'Move closer to the router or use Ethernet.',
            'Contact your ISP if speeds are consistently below plan.',
          ],
          points: 100,
        ),
        LevelDef(
          id: 'dns_issues',
          title: 'DNS Server Not Responding',
          description: 'Websites don\'t load but internet seems connected',
          steps: [
            'Change DNS to Google DNS (8.8.8.8) or Cloudflare (1.1.1.1).',
            'Flush DNS: ipconfig /flushdns in Command Prompt.',
            'Restart your router.',
            'Disable IPv6 temporarily in adapter settings.',
            'Reset Winsock: netsh winsock reset.',
          ],
          points: 100,
        ),
        LevelDef(
          id: 'vpn_not_connecting',
          title: 'VPN Not Connecting',
          description: 'VPN client fails to establish connection',
          steps: [
            'Check your internet connection works without VPN.',
            'Try a different VPN server location.',
            'Update the VPN client to the latest version.',
            'Change the VPN protocol (OpenVPN, WireGuard, IKEv2).',
            'Temporarily disable firewall/antivirus to test.',
          ],
          points: 100,
        ),
      ],
      boss: BossDef(
        name: 'The Packet Pirate',
        lore: 'A rogue AI that intercepts your network packets and redirects them to a void. It grows stronger with every misconfigured router.',
        hp: 6,
        points: 700,
      ),
    ),
    WorldDef(
      id: 5,
      name: 'Storage & Display',
      description: 'Hard drives, monitors, and visuals',
      icon: Icons.storage,
      levels: [
        LevelDef(
          id: 'hard_drive_not_detected',
          title: 'Hard Drive Not Detected',
          description: 'Drive doesn\'t appear in File Explorer',
          steps: [
            'Check SATA/data cable connections inside the PC.',
            'Try a different SATA port on the motherboard.',
            'Enter BIOS and check if the drive is listed.',
            'Try the drive in another computer or external enclosure.',
            'Initialize the drive in Disk Management if new.',
          ],
          points: 150,
        ),
        LevelDef(
          id: 'disk_full',
          title: 'Disk Full — No Space',
          description: 'Drive has run out of storage space',
          steps: [
            'Run Disk Cleanup and remove temporary files.',
            'Use WinDirStat to find large files and folders.',
            'Move media files to an external drive.',
            'Uninstall unused programs.',
            'Empty the Recycle Bin.',
          ],
          points: 100,
        ),
        LevelDef(
          id: 'no_display_output',
          title: 'No Display Output',
          description: 'Monitor shows black screen with power on',
          steps: [
            'Ensure monitor is powered on and correct input is selected.',
            'Check the video cable connection at both ends.',
            'Try a different cable or port.',
            'Connect to motherboard port (if iGPU) to test GPU.',
            'Reseat the GPU and check power cables.',
          ],
          points: 150,
        ),
        LevelDef(
          id: 'flickering_screen',
          title: 'Flickering Screen',
          description: 'Monitor display flickers intermittently',
          steps: [
            'Update or reinstall the graphics driver.',
            'Try a different video cable.',
            'Lower the refresh rate in Display settings.',
            'Test with a different monitor to isolate the issue.',
            'Disable hardware acceleration in affected apps.',
          ],
          points: 100,
        ),
        LevelDef(
          id: 'dead_pixels',
          title: 'Dead Pixels',
          description: 'Black or stuck pixels on the screen',
          steps: [
            'Use a stuck pixel fixer tool (JScreenFix) for stuck pixels.',
            'Apply gentle pressure with a soft cloth on the area.',
            'Check monitor warranty — many cover dead pixels.',
            'True dead pixels (black) may require panel replacement.',
            'Consider using the monitor as-is if pixels are minimal.',
          ],
          points: 100,
        ),
      ],
      boss: BossDef(
        name: 'The Visual Void',
        lore: 'A display-level corruption that creates dead zones on your screen. It absorbs light and distorts everything you see.',
        hp: 7,
        points: 1000,
      ),
    ),
  ];

  static const Map<String, List<String>> levelHints = {
    'cpu_high_usage': ['Check Task Manager for suspicious processes', 'Malware can hide as system processes'],
    'cpu_overheating': ['Dust is the #1 cause of overheating', 'Check if the CPU fan spins at all'],
    'computer_not_turning_on': ['Start with the simplest: check the wall outlet', 'A flipped PSU switch is more common than you think'],
    'beep_codes': ['One long beep usually means RAM issues', 'Clear CMOS as a last resort, not first'],
    'ram_not_detected': ['Try one stick at a time to isolate', 'The clips must snap on both sides'],
    'pc_wont_boot': ['USB drives can interfere with boot order', 'Check if you see the BIOS splash screen'],
    'boot_loop': ['Safe Mode is your best friend', 'Recent driver updates are often the culprit'],
    'bsod': ['The stop code tells you exactly what failed', 'MEMORY_MANAGEMENT means RAM is likely faulty'],
    'os_running_slow': ['A simple restart fixes 80% of slowdowns', 'Too many startup programs slow boot time'],
    'no_sound': ['Check the volume mixer, not just the main volume', 'Windows often switches to a different output device'],
    'mouse_not_responding': ['Try the back USB ports — they connect directly to the motherboard'],
    'cursor_lagging': ['Wireless mice are sensitive to USB 3.0 interference', 'A dirty sensor causes stuttering'],
    'keyboard_not_responding': ['Check if Num Lock light turns on', 'PS/2 requires a restart after connection'],
    'printer_offline': ['The Print Spooler service loves to stop on its own', 'Set the printer as default after reinstall'],
    'paper_jam': ['Always pull paper in the direction it feeds', 'Check for tiny torn pieces deep inside'],
    'program_crashes': ['Event Viewer logs the exact crash reason', 'Missing VC++ Redistributable is extremely common'],
    'no_internet': ['Reboot the modem AND router — both', 'Windows can reset its entire network stack'],
    'slow_internet': ['Test with Ethernet to rule out Wi-Fi issues', 'Your router might need a firmware update'],
    'dns_issues': ['Google DNS (8.8.8.8) works on any network', 'Flushing DNS clears corrupted cache entries'],
    'vpn_not_connecting': ['Try switching from UDP to TCP protocol', 'Some public Wi-Fi blocks VPN ports'],
    'hard_drive_not_detected': ['Listen for the drive spinning up', 'A new drive needs to be initialized in Disk Management'],
    'disk_full': ['The Recycle Bin doesn\'t empty itself', 'Temporary files can accumulate gigabytes'],
    'no_display_output': ['Try the motherboard video port first', 'A loose GPU can cause no display'],
    'flickering_screen': ['Bad HDMI cables are the easiest fix', 'Try lowering the refresh rate to 60Hz'],
    'dead_pixels': ['Stuck pixels (colored) are fixable; dead pixels (black) usually aren\'t'],
  };
}
