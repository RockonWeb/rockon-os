{
  # Git Configuration
  gitUsername = "rockon";
  gitEmail = "rockon@rockon";

  # System Configuration
  timeZone = "Asia/Irkutsk";

  # Monitor Settings (update after installation for your displays)
  extraMonitorSettings = ''
    monitor=DP-2,2560x1440@165.001,0x0,1.25
  '';

  # Waybar Settings
  clock24h = false;

  # Default Applications
  browser = "google-chrome";
  terminal = "ghostty";
  keyboardLayout = "us, ru";
  consoleKeyMap = "us";

  # For Nvidia Prime support (update if using nvidia-laptop profile)
  # Run 'lspci | grep VGA' to find your actual GPU IDs
  intelID = "PCI:0:2:0";
  nvidiaID = "PCI:1:0:0";

  # Core Features
  enableNFS = false;
  printEnable = false;
  thunarEnable = true;
  stylixEnable = true;

  # Optional Features (disabled for faster initial install)
  # You can enable these later by setting to true and rebuilding
  gamingSupportEnable = true; # Gaming controllers, gamescope, protonup-qt
  flutterdevEnable = false; # Flutter development environment
  syncthingEnable = false; # Syncthing file synchronization
  enableCommunicationApps = false; # Discord, Teams, Zoom, Telegram
  enableExtraBrowsers = false; # Vivaldi, Brave, Firefox, Chromium, Helium
  enableProductivityApps = false; # Obsidian, GNOME Boxes, QuickEmu
  aiCodeEditorsEnable = false; # Claude-code, gemini-cli, cursor

  # Desktop Environment
  enableHyprlock = false; # Set to false if using DMS/Noctalia lock screens

  # Bar/Shell Choice
  barChoice = "noctalia"; # Options: "dms" or "noctalia"
  # NOTE: If you change barChoice to "dms", you must run 'dms-install' after rebuilding

  # Shell Choice
  defaultShell = "zsh"; # Options: "fish" or "zsh"

  # Theming
  stylixImage = ../../wallpapers/clouds.jpg;
  #waybarChoice = ../../modules/home/waybar/waybar-ddubs.nix;  # Waybar temporarily disabled
  animChoice = ../../modules/home/hyprland/animations-end4.nix;

  # Startup Applications
  startupApps = [ ];
  startupCommands = [
    "sleep 1; env -u http_proxy -u https_proxy -u all_proxy -u HTTP_PROXY -u HTTPS_PROXY -u ALL_PROXY yandex-music --no-sandbox --no-proxy-server >/dev/null 2>&1 & Telegram >/dev/null 2>&1 &"
    "sleep 3; antigravity >/dev/null 2>&1 & google-chrome >/dev/null 2>&1 &"
  ];
}
