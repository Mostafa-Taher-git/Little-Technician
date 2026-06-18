import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:littletech/src/core/navigation/nav.dart';
import 'package:littletech/src/features/game/constants/game_data.dart';
import 'package:littletech/src/features/game/domain/cubit/game_cubit.dart';
import 'package:littletech/src/features/game/presentation/screens/ordering_screen.dart';

class QuizScreen extends StatefulWidget {
  final WorldDef world;
  final LevelDef level;

  const QuizScreen({super.key, required this.world, required this.level});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestion = 0;
  int? _selectedAnswer;
  int _correctCount = 0;
  bool _isAnswered = false;
  int _lives = 3;
  bool _gameOver = false;
  bool _showResults = false;
  final List<int> _userAnswers = [];

  static const _questions = {
    'cpu_high_usage': [
      {
        'question': 'Which tool do you use to check CPU usage in Windows?',
        'options': ['Task Manager', 'File Explorer', 'Control Panel', 'Notepad'],
        'correct': 0,
      },
      {
        'question': 'What keyboard shortcut opens Task Manager?',
        'options': ['Ctrl+Alt+Del and select Task Manager', 'Ctrl+C', 'Alt+F4', 'Windows+R'],
        'correct': 0,
      },
    ],
    'cpu_overheating': [
      {
        'question': 'What is the most common cause of CPU overheating?',
        'options': ['Dust buildup', 'Too much RAM', 'Old monitor', 'Slow internet'],
        'correct': 0,
      },
    ],
    'computer_not_turning_on': [
      {
        'question': 'What should you check FIRST when a PC won\'t turn on?',
        'options': ['Power cable connection', 'Replace the CPU', 'Reinstall Windows', 'Buy a new PC'],
        'correct': 0,
      },
    ],
    'battery_draining': [
      {
        'question': 'Which setting drains phone battery the most?',
        'options': ['Screen brightness', 'Wallpaper color', 'Ringtone volume', 'Notification sound'],
        'correct': 0,
      },
    ],
    'slow_phone': [
      {
        'question': 'What is the quickest way to speed up a slow phone?',
        'options': ['Restart the phone', 'Buy a new phone', 'Remove the SIM card', 'Factory reset'],
        'correct': 0,
      },
    ],
    'no_internet': [
      {
        'question': 'What should you restart first when troubleshooting no internet?',
        'options': ['Router and modem', 'Computer only', 'All light bulbs', 'The power company'],
        'correct': 0,
      },
    ],
    'beep_codes': [
      {
        'question': 'What do beep codes when your PC first turns on usually indicate?',
        'options': ['Hardware problem during startup', 'Software virus', 'Internet issue', 'Printer error'],
        'correct': 0,
      },
      {
        'question': 'How can you look up what a specific beep pattern means?',
        'options': ['Check your motherboard manual or search the beep code online', 'Call Microsoft', 'Reinstall Windows', 'Buy a new keyboard'],
        'correct': 0,
      },
      {
        'question': 'If your PC beeps once and then boots normally, is that usually a problem?',
        'options': ['No, a single short beep often means everything is fine', 'Yes, it means the hard drive is failing', 'Yes, it means RAM is broken', 'Yes, it means the monitor is dead'],
        'correct': 0,
      },
    ],
    'ram_not_detected': [
      {
        'question': 'What should you check first if your PC does not detect new RAM?',
        'options': ['Whether the RAM sticks are fully seated in the slots', 'Whether the monitor is plugged in', 'Whether the keyboard works', 'Whether the mouse is connected'],
        'correct': 0,
      },
      {
        'question': 'Can you mix different brands of RAM in the same PC?',
        'options': ['Sometimes, but it is better to use matching sticks for reliability', 'Never, it will explode', 'Only if you pay extra', 'Only on laptops'],
        'correct': 0,
      },
    ],
    'pc_wont_boot': [
      {
        'question': 'What should you check first when your PC will not boot at all?',
        'options': ['Power cable and power outlet', 'Your email', 'Social media', 'The weather forecast'],
        'correct': 0,
      },
      {
        'question': 'If you hear the fans spinning but get no display, what should you try?',
        'options': ['Reseat the RAM and check the monitor cable', 'Throw the PC away', 'Buy a new router', 'Call your ISP'],
        'correct': 0,
      },
      {
        'question': 'What does it mean if you press the power button and absolutely nothing happens?',
        'options': ['There may be a power supply or connection issue', 'The internet is down', 'Windows needs an update', 'The webcam is broken'],
        'correct': 0,
      },
    ],
    'boot_loop': [
      {
        'question': 'What is a boot loop?',
        'options': ['The PC keeps restarting before reaching the desktop', 'The PC runs slowly', 'The monitor flickers', 'The mouse stops working'],
        'correct': 0,
      },
      {
        'question': 'What can you try to fix a Windows boot loop?',
        'options': ['Boot into Safe Mode and uninstall recent changes', 'Buy a new hard drive immediately', 'Reinstall the mouse driver', 'Clean the monitor'],
        'correct': 0,
      },
      {
        'question': 'If Safe Mode does not work, what Windows feature might help?',
        'options': ['System Restore to roll back to an earlier point', 'Paint', 'Calculator', 'File Explorer'],
        'correct': 0,
      },
    ],
    'bsod': [
      {
        'question': 'What does BSOD stand for?',
        'options': ['Blue Screen of Death', 'Big System Offline Download', 'Blue Software Operating Device', 'Basic Screen Output Display'],
        'correct': 0,
      },
      {
        'question': 'What is a common first step after a BSOD?',
        'options': ['Write down the error code and restart the PC', 'Immediately replace the hard drive', 'Unplug the monitor', 'Delete System32'],
        'correct': 0,
      },
      {
        'question': 'If BSOD keeps happening, what safe mode task might help?',
        'options': ['Uninstall recent driver or software updates', 'Play a game', 'Watch a video', 'Increase screen brightness'],
        'correct': 0,
      },
    ],
    'os_running_slow': [
      {
        'question': 'What is an easy first step to speed up a slow operating system?',
        'options': ['Restart the computer', 'Buy more monitors', 'Unplug the keyboard', 'Change the wallpaper'],
        'correct': 0,
      },
      {
        'question': 'Which built-in tool helps free up space on Windows?',
        'options': ['Disk Cleanup', 'Paint', 'Calculator', 'WordPad'],
        'correct': 0,
      },
      {
        'question': 'Too many programs running at startup can slow your PC. How do you fix that?',
        'options': ['Disable unnecessary startup programs in Task Manager', 'Buy more RAM stickers', 'Remove the CPU fan', 'Turn off the monitor'],
        'correct': 0,
      },
    ],
    'no_sound': [
      {
        'question': 'What should you check first when you have no sound?',
        'options': ['Volume is not muted and speakers/headphones are plugged in', 'The monitor cable', 'The internet cable', 'The power supply'],
        'correct': 0,
      },
      {
        'question': 'If the volume is fine but there is still no sound, what should you check?',
        'options': ['That the correct playback device is selected in sound settings', 'The printer connection', 'The mouse settings', 'The calendar'],
        'correct': 0,
      },
      {
        'question': 'What simple step often fixes audio driver problems?',
        'options': ['Restart the computer', 'Replace the speakers', 'Buy a new monitor', 'Delete all files'],
        'correct': 0,
      },
    ],
    'mouse_not_responding': [
      {
        'question': 'What should you check first when your mouse stops responding?',
        'options': ['Is it plugged in or is the wireless receiver connected', 'Is the monitor on', 'Is the printer online', 'Is the internet working'],
        'correct': 0,
      },
      {
        'question': 'For a wireless mouse, what is a common fix when it stops working?',
        'options': ['Replace or recharge the batteries', 'Reinstall Windows', 'Buy a new monitor', 'Restart the router'],
        'correct': 0,
      },
      {
        'question': 'If plugging the mouse into a different USB port works, what was likely the problem?',
        'options': ['The original USB port was not working properly', 'The mouse was broken', 'The hard drive failed', 'The screen was cracked'],
        'correct': 0,
      },
    ],
    'cursor_lagging': [
      {
        'question': 'What is the most common cause of a lagging mouse cursor?',
        'options': ['Dirty sensor on the bottom of the mouse', 'Too many browser tabs', 'Weak Wi-Fi signal', 'Printer running out of ink'],
        'correct': 0,
      },
      {
        'question': 'What should you try if your wireless mouse cursor lags?',
        'options': ['Move the USB receiver closer or remove interference', 'Buy a new keyboard', 'Reinstall the operating system', 'Clean the monitor'],
        'correct': 0,
      },
    ],
    'keyboard_not_responding': [
      {
        'question': 'What should you try first when your keyboard stops responding?',
        'options': ['Unplug and replug it or re-pair the wireless connection', 'Reinstall the operating system', 'Buy a new monitor', 'Call the police'],
        'correct': 0,
      },
      {
        'question': 'If only some keys are not working, what might be the problem?',
        'options': ['Dirt or debris under those keys', 'The monitor is broken', 'The internet is down', 'The printer is offline'],
        'correct': 0,
      },
      {
        'question': 'What can you do to clean sticky keyboard keys at home?',
        'options': ['Turn the keyboard upside down and use compressed air', 'Pour water on it', 'Use a hammer', 'Replace the motherboard'],
        'correct': 0,
      },
    ],
    'printer_offline': [
      {
        'question': 'What should you check first when a printer shows as offline?',
        'options': ['That it is powered on and connected to the same network', 'The monitor settings', 'The mouse battery', 'The CPU temperature'],
        'correct': 0,
      },
      {
        'question': 'What simple fix often resolves a printer showing as offline in Windows?',
        'options': ['Restart the print spooler service or restart the printer', 'Replace the monitor', 'Buy a new keyboard', 'Reinstall the operating system'],
        'correct': 0,
      },
      {
        'question': 'If your printer is wireless, what should you verify?',
        'options': ['That the printer and computer are on the same Wi-Fi network', 'That the monitor is on', 'That the speakers work', 'That the webcam is connected'],
        'correct': 0,
      },
    ],
    'paper_jam': [
      {
        'question': 'What should you do when you get a paper jam error?',
        'options': ['Open the printer and gently remove the stuck paper', 'Pour water on it', 'Restart Windows', 'Buy a new computer'],
        'correct': 0,
      },
      {
        'question': 'How can you prevent future paper jams?',
        'options': ['Fan the paper before loading and do not overfill the tray', 'Use thicker paper than recommended', 'Leave the printer off', 'Turn off the lights'],
        'correct': 0,
      },
      {
        'question': 'After clearing a paper jam, what should you do?',
        'options': ['Check for small torn pieces left inside before closing', 'Replace the entire printer', 'Buy new ink', 'Reinstall the OS'],
        'correct': 0,
      },
    ],
    'program_crashes': [
      {
        'question': 'What is a good first step when a program keeps crashing?',
        'options': ['Restart the program and save work frequently', 'Buy a new computer', 'Unplug the printer', 'Restart the router'],
        'correct': 0,
      },
      {
        'question': 'If a program crashes every time you open it, what should you try?',
        'options': ['Reinstall the program or check for updates', 'Buy more RAM', 'Replace the monitor', 'Clean the keyboard'],
        'correct': 0,
      },
      {
        'question': 'Where can you often find why a program crashed in Windows?',
        'options': ['Event Viewer or the program\'s error log', 'The calculator', 'The calendar', 'The clock'],
        'correct': 0,
      },
    ],
    'slow_internet': [
      {
        'question': 'What should you try first when your internet is slow?',
        'options': ['Restart your router and modem', 'Buy a new computer', 'Replace the monitor', 'Buy more RAM'],
        'correct': 0,
      },
      {
        'question': 'How can you check if your internet speed matches what you pay for?',
        'options': ['Run an online speed test', 'Check the weather app', 'Open the calculator', 'Look at the calendar'],
        'correct': 0,
      },
      {
        'question': 'What can slow down Wi-Fi even when you have a good internet plan?',
        'options': ['Being too far from the router or having too many devices connected', 'Having a new keyboard', 'Using a wired mouse', 'Having a bright monitor'],
        'correct': 0,
      },
    ],
    'dns_issues': [
      {
        'question': 'What is a simple first fix when you suspect DNS problems?',
        'options': ['Restart your router and modem', 'Replace the keyboard', 'Buy a new monitor', 'Clean the mouse'],
        'correct': 0,
      },
      {
        'question': 'If you can ping an IP address but not open a website, what might be the issue?',
        'options': ['DNS is not resolving domain names properly', 'The monitor is too dim', 'The printer is offline', 'The keyboard is broken'],
        'correct': 0,
      },
      {
        'question': 'What does flushing the DNS cache do?',
        'options': ['Clears outdated DNS records so fresh ones can be fetched', 'Deletes your browser history', 'Formats the hard drive', 'Reinstalls Windows'],
        'correct': 0,
      },
    ],
    'vpn_not_connecting': [
      {
        'question': 'What should you check first when a VPN will not connect?',
        'options': ['That your regular internet connection is working', 'The printer status', 'The monitor settings', 'The keyboard layout'],
        'correct': 0,
      },
      {
        'question': 'What simple fix often resolves VPN connection issues?',
        'options': ['Restart the VPN app or restart your computer', 'Buy a new router', 'Replace the hard drive', 'Reinstall the operating system'],
        'correct': 0,
      },
      {
        'question': 'What can block a VPN from connecting?',
        'options': ['Firewall settings or antivirus blocking the connection', 'A dirty monitor', 'Low printer ink', 'Weak phone signal'],
        'correct': 0,
      },
    ],
    'hard_drive_not_detected': [
      {
        'question': 'What should you check first when your hard drive is not detected?',
        'options': ['That the cables are firmly connected', 'The monitor brightness', 'The keyboard keys', 'The mouse sensor'],
        'correct': 0,
      },
      {
        'question': 'If an external drive is not detected, what should you try?',
        'options': ['Try a different USB port or cable', 'Reinstall Windows', 'Buy a new monitor', 'Clean the keyboard'],
        'correct': 0,
      },
      {
        'question': 'What Windows tool lets you check if a drive is visible but not assigned a letter?',
        'options': ['Disk Management', 'Paint', 'Calculator', 'Notepad'],
        'correct': 0,
      },
    ],
    'disk_full': [
      {
        'question': 'What is a quick way to free up disk space on Windows?',
        'options': ['Empty the Recycle Bin and run Disk Cleanup', 'Buy more RAM', 'Replace the keyboard', 'Buy a new monitor'],
        'correct': 0,
      },
      {
        'question': 'Where do large temporary files often pile up on Windows?',
        'options': ['The Temp folder and browser cache', 'The desktop background', 'The printer spooler', 'The mouse driver'],
        'correct': 0,
      },
      {
        'question': 'What built-in Windows feature helps you see what is taking up space?',
        'options': ['Storage Sense in Settings', 'The calculator', 'The calendar', 'Paint'],
        'correct': 0,
      },
    ],
    'no_display_output': [
      {
        'question': 'What should you check first when your monitor shows no display?',
        'options': ['That the video cable is securely connected', 'The printer paper', 'The keyboard layout', 'The mouse battery'],
        'correct': 0,
      },
      {
        'question': 'If the PC is on but the monitor stays black, what should you check?',
        'options': ['That the monitor is powered on and set to the correct input', 'The internet speed', 'The printer ink level', 'The CPU temperature'],
        'correct': 0,
      },
      {
        'question': 'What could cause no display even though the PC seems to turn on?',
        'options': ['A loose or damaged video cable', 'A dirty mouse sensor', 'A paper jam', 'Low keyboard batteries'],
        'correct': 0,
      },
    ],
    'flickering_screen': [
      {
        'question': 'What is a common cause of screen flickering?',
        'options': ['A loose cable connection or driver issue', 'Low internet speed', 'Too many browser tabs', 'A paper jam'],
        'correct': 0,
      },
      {
        'question': 'What should you try if your screen keeps flickering?',
        'options': ['Check cable connections and update your display driver', 'Buy more RAM', 'Restart the printer', 'Reinstall the operating system'],
        'correct': 0,
      },
      {
        'question': 'If flickering happens only in one app, what is likely the problem?',
        'options': ['That specific app has a compatibility issue', 'The entire PC is broken', 'The internet is down', 'The printer is offline'],
        'correct': 0,
      },
    ],
    'dead_pixels': [
      {
        'question': 'What is a dead pixel?',
        'options': ['A pixel that stays one color and does not change', 'A pixel that is too bright', 'A pixel that flickers', 'A pixel that moves around'],
        'correct': 0,
      },
      {
        'question': 'Can you reliably fix dead pixels at home?',
        'options': ['No, dead pixels usually require professional repair or screen replacement', 'Yes, just restart the PC', 'Yes, blow on the screen', 'Yes, press any key'],
        'correct': 0,
      },
      {
        'question': 'What should you do to check for dead pixels on a new monitor?',
        'options': ['Display solid colors and look for spots that stay stuck', 'Run a speed test', 'Check the printer', 'Clean the keyboard'],
        'correct': 0,
      },
    ],
    'phone_overheating': [
      {
        'question': 'What is a common cause of a phone overheating?',
        'options': ['Running too many apps or using it while charging', 'The wallpaper color', 'The ringtone volume', 'The clock time'],
        'correct': 0,
      },
      {
        'question': 'What should you do if your phone gets too hot?',
        'options': ['Remove the case and let it cool down naturally', 'Put it in the freezer', 'Keep using it harder', 'Pour water on it'],
        'correct': 0,
      },
      {
        'question': 'Which activity heats up a phone the most?',
        'options': ['Playing graphics-heavy games for a long time', 'Checking the time', 'Sending a text message', 'Using the calculator'],
        'correct': 0,
      },
    ],
    'phone_apps_crashing': [
      {
        'question': 'What should you try first when an app keeps crashing on your phone?',
        'options': ['Close and reopen the app or restart the phone', 'Buy a new phone', 'Remove the SIM card', 'Factory reset immediately'],
        'correct': 0,
      },
      {
        'question': 'What can you do if a specific app crashes but others are fine?',
        'options': ['Update or reinstall that specific app', 'Replace the battery', 'Buy a new phone case', 'Get a new SIM card'],
        'correct': 0,
      },
      {
        'question': 'What should you check if many apps are crashing at the same time?',
        'options': ['Available storage space and whether the OS needs updating', 'The wallpaper', 'The clock settings', 'The calculator app'],
        'correct': 0,
      },
    ],
    'phone_not_charging': [
      {
        'question': 'What should you check first when your phone will not charge?',
        'options': ['Try a different cable and power adapter', 'The wallpaper', 'The keyboard', 'The internet'],
        'correct': 0,
      },
      {
        'question': 'What can block a phone from charging properly?',
        'options': ['Dirt or lint in the charging port', 'The screen brightness', 'The ringtone', 'The calendar'],
        'correct': 0,
      },
      {
        'question': 'If your phone charges slowly, what might help?',
        'options': ['Use a cable and charger that match the phone\'s fast-charge support', 'Turn the screen off', 'Remove the SIM card', 'Restart the router'],
        'correct': 0,
      },
    ],
    'game_crashing': [
      {
        'question': 'What should you check first when a game keeps crashing?',
        'options': ['That your PC meets the game\'s minimum requirements', 'The printer settings', 'The keyboard layout', 'The mouse sensor'],
        'correct': 0,
      },
      {
        'question': 'What simple fix often stops games from crashing?',
        'options': ['Update your graphics drivers', 'Buy more storage boxes', 'Restart the router', 'Clean the monitor'],
        'correct': 0,
      },
      {
        'question': 'If a game crashes during a cutscene, what should you try?',
        'options': ['Lower the graphics settings in the game', 'Buy a new keyboard', 'Replace the mouse', 'Restart the printer'],
        'correct': 0,
      },
    ],
    'low_fps': [
      {
        'question': 'What does low FPS mean in gaming?',
        'options': ['The game is running with choppy, non-smooth motion', 'The internet is slow', 'The printer is offline', 'The keyboard is broken'],
        'correct': 0,
      },
      {
        'question': 'What is a quick way to improve FPS in a game?',
        'options': ['Lower the in-game graphics settings', 'Buy a new keyboard', 'Restart the printer', 'Clean the monitor'],
        'correct': 0,
      },
      {
        'question': 'What background process can steal FPS from games?',
        'options': ['Too many other programs running at the same time', 'Having the lights on', 'The clock running', 'The calculator being open'],
        'correct': 0,
      },
    ],
    'controller_not_connecting': [
      {
        'question': 'What should you try first when a game controller will not connect?',
        'options': ['Charge it or replace the batteries', 'Reinstall Windows', 'Buy a new monitor', 'Restart the router'],
        'correct': 0,
      },
      {
        'question': 'For a wireless controller, what can interfere with the connection?',
        'options': ['Other wireless devices nearby or being too far from the PC', 'The room temperature', 'The wallpaper', 'The clock'],
        'correct': 0,
      },
      {
        'question': 'What should you check if a wired controller does not work?',
        'options': ['That the USB cable is not damaged and the port works', 'The monitor cable', 'The printer paper', 'The internet speed'],
        'correct': 0,
      },
    ],
    'game_audio_stutter': [
      {
        'question': 'What is a common cause of game audio stuttering?',
        'options': ['Too many background programs using system resources', 'A dirty mouse sensor', 'A paper jam', 'Weak Wi-Fi'],
        'correct': 0,
      },
      {
        'question': 'What can you try to fix game audio stuttering?',
        'options': ['Lower in-game audio quality or close other programs', 'Buy a new keyboard', 'Restart the printer', 'Clean the monitor'],
        'correct': 0,
      },
      {
        'question': 'If game audio stutters only during intense moments, what is likely the issue?',
        'options': ['The PC is struggling to keep up with processing demands', 'The internet is slow', 'The printer is out of ink', 'The monitor is too dim'],
        'correct': 0,
      },
    ],
    'gpu_driver_crash': [
      {
        'question': 'What usually causes a GPU driver to crash?',
        'options': ['Outdated or corrupted graphics driver', 'Low printer ink', 'Weak Wi-Fi signal', 'Dirty keyboard'],
        'correct': 0,
      },
      {
        'question': 'What should you do when your GPU driver crashes?',
        'options': ['Restart the PC and update or reinstall the graphics driver', 'Buy a new monitor', 'Replace the keyboard', 'Restart the printer'],
        'correct': 0,
      },
      {
        'question': 'If your screen goes black and then recovers, what might have happened?',
        'options': ['The GPU driver crashed and restarted automatically', 'The printer jammed', 'The internet went down', 'The keyboard died'],
        'correct': 0,
      },
    ],
    'smart_device_offline': [
      {
        'question': 'What should you check first when a smart device shows as offline?',
        'options': ['That it is connected to the same Wi-Fi network as your phone', 'The printer status', 'The keyboard batteries', 'The monitor cable'],
        'correct': 0,
      },
      {
        'question': 'What simple fix often brings a smart device back online?',
        'options': ['Restart the device and restart your router', 'Buy a new phone', 'Replace the monitor', 'Reinstall Windows'],
        'correct': 0,
      },
      {
        'question': 'What can make a smart device lose connection to Wi-Fi?',
        'options': ['Being too far from the router or the router was restarted', 'A dirty screen', 'A paper jam', 'Low printer ink'],
        'correct': 0,
      },
    ],
    'voice_assistant_not_responding': [
      {
        'question': 'What should you check first when your voice assistant does not respond?',
        'options': ['That the device\'s microphone is not muted and it is online', 'The printer paper', 'The keyboard layout', 'The monitor cable'],
        'correct': 0,
      },
      {
        'question': 'What simple step can fix a voice assistant that stopped hearing you?',
        'options': ['Restart the device or check its microphone settings', 'Buy a new keyboard', 'Reinstall Windows', 'Restart the printer'],
        'correct': 0,
      },
      {
        'question': 'What can prevent a voice assistant from hearing your commands?',
        'options': ['Background noise or the device being too far away', 'A dirty monitor', 'Low printer ink', 'A paper jam'],
        'correct': 0,
      },
    ],
    'smart_light_not_connecting': [
      {
        'question': 'What should you check first when a smart light will not connect?',
        'options': ['That the light bulb is screwed in and powered on', 'The keyboard batteries', 'The monitor cable', 'The printer paper'],
        'correct': 0,
      },
      {
        'question': 'What can cause a smart light to lose its connection?',
        'options': ['Wi-Fi changes like a new router or password', 'The monitor brightness', 'The keyboard layout', 'The clock settings'],
        'correct': 0,
      },
      {
        'question': 'How can you fix a smart light that won\'t pair with the app?',
        'options': ['Reset the light by turning it on and off several times', 'Buy a new phone', 'Reinstall Windows', 'Restart the printer'],
        'correct': 0,
      },
    ],
    'home_hub_setup_failed': [
      {
        'question': 'What should you verify first when a smart home hub fails to set up?',
        'options': ['That your phone is connected to the correct Wi-Fi network', 'The printer status', 'The keyboard layout', 'The monitor cable'],
        'correct': 0,
      },
      {
        'question': 'What can interfere with hub setup?',
        'options': ['Being too far from the router or network congestion', 'A dirty screen', 'Low printer ink', 'A paper jam'],
        'correct': 0,
      },
      {
        'question': 'What simple step might fix a hub that won\'t complete setup?',
        'options': ['Restart the hub and your phone, then try again', 'Buy a new keyboard', 'Reinstall Windows', 'Clean the monitor'],
        'correct': 0,
      },
    ],
    'automation_not_triggering': [
      {
        'question': 'What should you check first when an automation does not trigger?',
        'options': ['That the trigger condition and time settings are correct', 'The printer paper', 'The keyboard layout', 'The monitor cable'],
        'correct': 0,
      },
      {
        'question': 'What can stop a smart home automation from running?',
        'options': ['A device in the automation is offline', 'The monitor is too dim', 'The keyboard is dirty', 'The printer is out of ink'],
        'correct': 0,
      },
      {
        'question': 'How can you test if an automation is working correctly?',
        'options': ['Manually trigger it or check the activity log in the app', 'Buy a new phone', 'Restart the printer', 'Reinstall Windows'],
        'correct': 0,
      },
    ],
  };

  List<Map<String, dynamic>> get _levelQuestions {
    return _questions[widget.level.id] ?? [
      {
        'question': 'What is the first step in troubleshooting any tech problem?',
        'options': ['Identify the symptoms', 'Replace the device', 'Call for help', 'Ignore the problem'],
        'correct': 0,
      },
    ];
  }

  void _answer(int index) {
    if (_isAnswered || _gameOver) return;
    setState(() {
      _selectedAnswer = index;
      _isAnswered = true;
      _userAnswers.add(index);
      if (index == _levelQuestions[_currentQuestion]['correct']) {
        _correctCount++;
      } else {
        _lives--;
        if (_lives <= 0) _gameOver = true;
      }
    });
  }

  void _next() {
    if (_currentQuestion < _levelQuestions.length - 1) {
      setState(() {
        _currentQuestion++;
        _selectedAnswer = null;
        _isAnswered = false;
      });
    } else {
      setState(() => _showResults = true);
    }
  }

  void _continueToOrdering() {
    final passed = _correctCount >= _levelQuestions.length ~/ 2 + 1;
    context.read<GameCubit>().saveQuizResult(widget.level.id, _correctCount, _levelQuestions.length, _lives);
    if (passed) context.read<GameCubit>().addPoints(20);
    Nav.pushReplacement(
      context,
      OrderingScreen(world: widget.world, level: widget.level),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    if (_showResults) return _buildResults(scheme);

    final q = _levelQuestions[_currentQuestion];
    final options = List<String>.from(q['options'] as List);

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: const Text('Sage\'s Trial'),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Question ${_currentQuestion + 1}/${_levelQuestions.length}',
                  style: TextStyle(
                    color: scheme.onSurface.withValues(alpha: 0.5),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: scheme.secondary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$_correctCount correct',
                    style: TextStyle(
                      color: scheme.secondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const Gap(24),
            Row(
              children: List.generate(3, (i) {
                final filled = i < _lives;
                return Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Icon(
                    filled ? Icons.favorite : Icons.favorite_border,
                    color: filled ? Colors.red.shade400 : scheme.onSurface.withValues(alpha: 0.2),
                    size: 20,
                  ),
                );
              }),
            ),
            const Gap(24),
            Text(
              q['question'] as String,
              style: TextStyle(
                color: scheme.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                height: 1.3,
              ),
            ),
            const Gap(24),
            ...options.asMap().entries.map((entry) {
              final i = entry.key;
              final option = entry.value;
              final isSelected = _selectedAnswer == i;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _answer(i),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? scheme.primary.withValues(alpha: 0.1)
                            : scheme.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected
                              ? scheme.primary
                              : scheme.outline.withValues(alpha: 0.3),
                          width: isSelected ? 2 : 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? scheme.primary
                                  : scheme.primary.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              String.fromCharCode(65 + i),
                              style: TextStyle(
                                color: isSelected
                                    ? scheme.onPrimary
                                    : scheme.onSurface.withValues(alpha: 0.5),
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          const Gap(14),
                          Expanded(
                            child: Text(
                              option,
                              style: TextStyle(
                                color: isSelected
                                    ? scheme.primary
                                    : scheme.onSurface,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: (100 * i).ms).slideX(begin: 0.05);
            }),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: (_isAnswered || _gameOver) ? _next : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: scheme.secondary,
                  foregroundColor: scheme.onSecondary,
                  disabledBackgroundColor: scheme.outline.withValues(alpha: 0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  _currentQuestion < _levelQuestions.length - 1 ? 'Next' : 'Review Results',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResults(ColorScheme scheme) {
    final passed = _correctCount >= _levelQuestions.length ~/ 2 + 1;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: const Text('Sage\'s Trial Complete'),
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: passed
                    ? [Colors.green.shade800, Colors.green.shade600]
                    : [Colors.red.shade800, Colors.red.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Icon(
                  passed ? Icons.emoji_events : Icons.info_outline,
                  color: Colors.white,
                  size: 48,
                ),
                const Gap(12),
                Text(
                  '$_correctCount / ${_levelQuestions.length} Correct',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Gap(4),
                Text(
                  passed ? 'Passed!' : 'Failed — continue anyway',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const Gap(8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (i) {
                    final filled = i < _lives;
                    return Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Icon(
                        filled ? Icons.favorite : Icons.favorite_border,
                        color: Colors.white,
                        size: 18,
                      ),
                    );
                  }),
                ),
              ],
            ),
          ).animate().fadeIn().scale(begin: const Offset(0.9, 0.9)),
          const Gap(24),
          ..._levelQuestions.asMap().entries.map((entry) {
            final i = entry.key;
            final q = entry.value;
            final userAnswer = i < _userAnswers.length ? _userAnswers[i] : -1;
            final correctAns = q['correct'] as int;
            final isCorrect = userAnswer == correctAns;
            final options = List<String>.from(q['options'] as List);

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isCorrect
                    ? Colors.green.withValues(alpha: 0.05)
                    : Colors.red.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isCorrect
                      ? Colors.green.withValues(alpha: 0.3)
                      : Colors.red.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        isCorrect ? Icons.check_circle : Icons.cancel,
                        color: isCorrect ? Colors.green : Colors.red,
                        size: 18,
                      ),
                      const Gap(8),
                      Expanded(
                        child: Text(
                          q['question'] as String,
                          style: TextStyle(
                            color: scheme.onSurface,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(8),
                  Text(
                    'Your answer: ${userAnswer >= 0 ? options[userAnswer] : '—'}',
                    style: TextStyle(
                      color: isCorrect ? Colors.green.shade300 : Colors.red.shade300,
                      fontSize: 12,
                    ),
                  ),
                  if (!isCorrect)
                    Text(
                      'Correct: ${options[correctAns]}',
                      style: TextStyle(
                        color: Colors.green.shade300,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            );
          }),
          const Gap(24),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: _continueToOrdering,
              icon: const Icon(Icons.arrow_forward, size: 20),
              label: const Text(
                'Continue to Ordering',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: scheme.secondary,
                foregroundColor: scheme.onSecondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2),
        ],
      ),
    );
  }
}
