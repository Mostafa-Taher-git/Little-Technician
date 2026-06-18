import 'package:flutter/material.dart';

class LevelDef {
  final String id;
  final String title;
  final String description;
  final List<String> steps;
  final int points;
  final String? imageUrl;

  const LevelDef({
    required this.id,
    required this.title,
    required this.description,
    required this.steps,
    this.points = 100,
    this.imageUrl,
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
        name: 'The Bone Colossus',
        lore: 'A towering skeleton giant assembled from broken PC cases and failed hardware. It guards the gate with a crushing grip.',
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
        name: 'The Lich Lord',
        lore: 'An undead sorcerer of corrupted system files. Its phylactery is hidden deep within the OS kernel, resurrecting itself from every crash.',
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
        name: 'The Goblin King',
        lore: 'A cunning goblin warlord that sabotages your peripherals with trick arrows and ensnaring cables. His lair is a maze of tangled wires.',
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
        name: 'The Dragon Whelp',
        lore: 'A young crimson dragon that hoards network packets in its cave-like router. It breathes fire at passing data streams and grows stronger with every stolen byte.',
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
        name: 'The Beholder',
        lore: 'A floating eye tyrant whose many gaze rays corrupt your display. Each eye casts a different visual curse — dead pixels, flickering, and color decay.',
        hp: 7,
        points: 1000,
      ),
    ),
    WorldDef(
      id: 6,
      name: 'Mobile Troubleshooting',
      description: 'Phone, tablet, and mobile device issues',
      icon: Icons.phone_android,
      levels: [
        LevelDef(
          id: 'battery_draining',
          title: 'Battery Draining Fast',
          description: 'Phone battery dies in hours',
          steps: [
            'Check battery usage stats in Settings to find power-hungry apps.',
            'Reduce screen brightness and set a short screen timeout.',
            'Disable background app refresh for non-essential apps.',
            'Turn off Bluetooth, GPS, and Wi-Fi when not in use.',
          ],
          points: 100,
        ),
        LevelDef(
          id: 'phone_overheating',
          title: 'Phone Overheating',
          description: 'Device gets uncomfortably hot',
          steps: [
            'Remove the phone case and avoid direct sunlight.',
            'Close all background apps and games.',
            'Stop charging the phone until it cools down.',
            'Check for stuck apps using excessive CPU in battery stats.',
          ],
          points: 100,
        ),
        LevelDef(
          id: 'phone_apps_crashing',
          title: 'Apps Crashing on Phone',
          description: 'Apps close unexpectedly',
          steps: [
            'Clear the app cache from Settings > Apps.',
            'Update the app from the Play Store or App Store.',
            'Restart the phone to clear temporary glitches.',
            'Uninstall and reinstall the problematic app.',
          ],
          points: 100,
        ),
        LevelDef(
          id: 'phone_not_charging',
          title: 'Phone Not Charging',
          description: 'No charging indicator when plugged in',
          steps: [
            'Check the charging cable and brick for damage.',
            'Try a different power outlet and cable.',
            'Clean the charging port gently with a toothpick.',
            'Restart the phone while plugged in.',
            'Check for moisture in the port (if water damage suspected).',
          ],
          points: 150,
        ),
        LevelDef(
          id: 'slow_phone',
          title: 'Slow Phone Performance',
          description: 'Phone is sluggish and laggy',
          steps: [
            'Clear cached data from all apps in Settings.',
            'Uninstall unused apps to free up storage space.',
            'Restart the phone to clear memory leaks.',
            'Check for software updates in system settings.',
          ],
          points: 100,
        ),
      ],
      boss: BossDef(
        name: 'The Phantom Battery',
        lore: 'A ghostly energy-draining entity that latches onto your phone like a spectral leech. It feeds on battery life and vanishes into the background process list.',
        hp: 5,
        points: 500,
      ),
    ),
    WorldDef(
      id: 7,
      name: 'Gaming Rig',
      description: 'Gaming PC and console troubleshooting',
      icon: Icons.sports_esports,
      levels: [
        LevelDef(
          id: 'game_crashing',
          title: 'Game Crashing on Startup',
          description: 'Game closes immediately',
          steps: [
            'Verify game file integrity via Steam or launcher.',
            'Update GPU drivers to the latest version.',
            'Disable overlays (Discord, Steam, GeForce Experience).',
            'Run the game as Administrator.',
          ],
          points: 100,
        ),
        LevelDef(
          id: 'low_fps',
          title: 'Low FPS in Games',
          description: 'Unplayably low frame rates',
          steps: [
            'Lower in-game graphics settings (shadows, textures, AA).',
            'Close background apps (browser, streaming, Discord).',
            'Update GPU drivers and check for thermal throttling.',
            'Reduce render resolution to 1080p or lower.',
            'Enable GPU scheduling in Windows Graphics settings.',
          ],
          points: 150,
        ),
        LevelDef(
          id: 'controller_not_connecting',
          title: 'Controller Not Connecting',
          description: 'Wireless controller won\'t pair',
          steps: [
            'Put the controller into pairing mode (hold pair button).',
            'Remove the device from Bluetooth settings and re-pair.',
            'Replace controller batteries or charge fully.',
            'Connect via USB cable to test if it works wired.',
          ],
          points: 100,
        ),
        LevelDef(
          id: 'game_audio_stutter',
          title: 'Game Audio Stuttering',
          description: 'Audio cuts out during gameplay',
          steps: [
            'Reduce audio quality to 16-bit 44100Hz in Sound settings.',
            'Disable audio enhancements in speaker properties.',
            'Update audio and GPU drivers.',
            'Close browser tabs that use hardware acceleration.',
          ],
          points: 100,
        ),
        LevelDef(
          id: 'gpu_driver_crash',
          title: 'Graphics Driver Crash',
          description: 'Driver stops responding during games',
          steps: [
            'Use DDU (Display Driver Uninstaller) in Safe Mode to clean drivers.',
            'Install the latest stable driver (avoid beta drivers).',
            'Underclock GPU using MSI Afterburner if overclocked.',
            'Check GPU temperatures; repaste if over 85°C under load.',
            'Lower in-game graphics settings to reduce GPU load.',
          ],
          points: 150,
        ),
      ],
      boss: BossDef(
        name: 'The Lag Spikes',
        lore: 'A corrupted game entity that spawns frame drops like barbed vines. It injects stutter into every animation and laughs as your FPS counter plummets.',
        hp: 6,
        points: 600,
      ),
    ),
    WorldDef(
      id: 8,
      name: 'Smart Home',
      description: 'IoT device and smart home setup',
      icon: Icons.home_max,
      levels: [
        LevelDef(
          id: 'smart_device_offline',
          title: 'Smart Device Offline',
          description: 'Device shows as offline in app',
          steps: [
            'Check that the device is powered on and within Wi-Fi range.',
            'Restart the device by unplugging it for 30 seconds.',
            'Reboot your Wi-Fi router to refresh the network.',
            'Re-add the device in the manufacturer\'s app.',
          ],
          points: 100,
        ),
        LevelDef(
          id: 'voice_assistant_not_responding',
          title: 'Voice Assistant Not Responding',
          description: 'Smart speaker doesn\'t answer',
          steps: [
            'Check the microphone is not muted (physical switch).',
            'Restart the smart speaker by unplugging it.',
            'Ensure the speaker is connected to Wi-Fi.',
            'Update the speaker firmware in its companion app.',
          ],
          points: 100,
        ),
        LevelDef(
          id: 'smart_light_not_connecting',
          title: 'Smart Light Not Connecting',
          description: 'Bulb won\'t pair with hub',
          steps: [
            'Turn the light switch off and on three times to reset the bulb.',
            'Move the bulb closer to the hub during pairing.',
            'Check that the hub firmware is up to date.',
            'Use the manufacturer\'s app in pairing mode only.',
          ],
          points: 100,
        ),
        LevelDef(
          id: 'home_hub_setup_failed',
          title: 'Home Hub Setup Failed',
          description: 'Hub gets stuck during setup',
          steps: [
            'Factory reset the hub using the pinhole button.',
            'Ensure your phone and hub are on the same 2.4GHz network.',
            'Temporarily disable mobile data and VPN during setup.',
            'Update the hub firmware via a wired Ethernet connection.',
            'Contact manufacturer support if the hub remains bricked.',
          ],
          points: 150,
        ),
        LevelDef(
          id: 'automation_not_triggering',
          title: 'Automation Not Triggering',
          description: 'Routines don\'t execute automatically',
          steps: [
            'Check that all devices in the routine respond manually.',
            'Verify the automation conditions (time, sensor, location) are met.',
            'Re-save the routine to refresh it on the hub.',
            'Reboot the smart home hub to clear stale state.',
          ],
          points: 100,
        ),
      ],
      boss: BossDef(
        name: 'The Rogue Hub',
        lore: 'A possessed smart home hub that rewrites its own firmware. It turns lights on at 3 AM, locks doors unpredictably, and ignores every voice command you throw at it.',
        hp: 5,
        points: 600,
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
    'battery_draining': ['Background app refresh is a hidden battery hog', 'Screen brightness is often the biggest drain'],
    'phone_overheating': ['Direct sunlight can overheat a phone in minutes', 'Thick cases trap heat inside the device'],
    'phone_apps_crashing': ['An outdated app version is the most common cause', 'Clearing the cache fixes most temporary crashes'],
    'phone_not_charging': ['Lint in the charging port is more common than a broken port', 'Try a different cable before replacing the phone'],
    'slow_phone': ['A phone that hasn\'t restarted in weeks accumulates memory leaks', 'Low storage space directly causes lag'],
    'game_crashing': ['Verify game files before reinstalling', 'GPU driver updates often list game crash fixes'],
    'low_fps': ['Ray tracing and shadows are the biggest FPS killers', 'Thermal throttling is common in gaming laptops'],
    'controller_not_connecting': ['Remove the controller from Bluetooth list and re-pair fresh', 'A dead battery looks like a pairing failure'],
    'game_audio_stutter': ['Set audio quality to 16-bit 44100Hz as the universal fix', 'Hardware acceleration in browsers can conflict with game audio'],
    'gpu_driver_crash': ['DDU in Safe Mode removes every trace of old drivers', 'An unstable overclock is the #1 cause of driver crashes'],
    'smart_device_offline': ['Power cycling the device fixes 90% of offline issues', 'A recent router reboot can resolve IP conflicts'],
    'voice_assistant_not_responding': ['Check the physical mute switch before anything else', 'A Wi-Fi disconnect can make the speaker appear broken'],
    'smart_light_not_connecting': ['Most bulbs need to be reset by flipping the switch 3 times', '2.4GHz network is required — 5GHz won\'t work'],
    'home_hub_setup_failed': ['Factory reset via the pinhole button clears all bad config', 'Both devices must be on the same 2.4GHz band'],
    'automation_not_triggering': ['Check if location permissions are granted to the hub app', 'Re-saving the routine forces a refresh on the hub'],
  };

  static const Map<String, String> solutionIdMap = {
    'cpu_high_usage': 'High CPU usage',
    'cpu_overheating': 'CPU overheating',
    'computer_not_turning_on': 'Computer not turning on',
    'beep_codes': 'Beep codes on startup',
    'ram_not_detected': 'RAM not detected',
    'pc_wont_boot': "PC won't boot",
    'boot_loop': 'Boot loop',
    'bsod': 'Blue screen of death (BSOD)',
    'os_running_slow': 'OS running slow',
    'no_sound': 'No sound output',
    'mouse_not_responding': 'Mouse not responding',
    'cursor_lagging': 'Cursor lagging',
    'keyboard_not_responding': 'Keyboard not responding',
    'printer_offline': 'Printer offline',
    'paper_jam': 'Paper jam',
    'program_crashes': 'Program crashes on launch',
    'no_internet': 'No internet connection',
    'slow_internet': 'Slow internet speed',
    'dns_issues': 'DNS server not responding',
    'vpn_not_connecting': 'VPN not connecting',
    'hard_drive_not_detected': 'Hard drive not detected',
    'disk_full': 'Disk full — no space',
    'no_display_output': 'No display output',
    'flickering_screen': 'Flickering screen',
    'dead_pixels': 'Dead pixels',
    'battery_draining': 'Battery draining fast',
    'phone_overheating': 'Phone overheating',
    'phone_apps_crashing': 'Apps crashing on phone',
    'phone_not_charging': 'Phone not charging',
    'slow_phone': 'Slow phone performance',
    'game_crashing': 'Game crashing on startup',
    'low_fps': 'Low FPS in games',
    'controller_not_connecting': 'Controller not connecting',
    'game_audio_stutter': 'Game audio stuttering',
    'gpu_driver_crash': 'Graphics driver crash',
    'smart_device_offline': 'Smart device offline',
    'voice_assistant_not_responding': 'Voice assistant not responding',
    'smart_light_not_connecting': 'Smart light not connecting',
    'home_hub_setup_failed': 'Home hub setup failed',
    'automation_not_triggering': 'Automation not triggering',
  };

  static String? solutionForLevel(String levelId) => solutionIdMap[levelId];

  static bool isWorldComplete(WorldDef world, List<String> completedLevelIds) {
    return world.levels.every((level) => completedLevelIds.contains(level.id));
  }
}
