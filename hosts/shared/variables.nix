{
  # Git Configuration
  gitUsername = "rockon";
  gitEmail = "rockon@rockon";

  # System Configuration
  timeZone = "Asia/Irkutsk";

  # Leave empty to let Niri auto-detect monitors on new machines.
  extraMonitorSettings = "";
  dockMonitors = [ ];

  # Waybar / shell settings
  clock24h = false;

  # Default Applications
  browser = "google-chrome";
  terminal = "ghostty";
  keyboardLayout = "us, ru";
  consoleKeyMap = "us";

  # Nvidia Prime bus IDs can be overridden per host when needed.
  intelID = "PCI:0:2:0";
  nvidiaID = "PCI:1:0:0";

  # Core Features
  enableNFS = false;
  printEnable = false;
  thunarEnable = true;
  stylixEnable = true;

  # Optional Features
  gamingSupportEnable = true;
  flutterdevEnable = false;
  syncthingEnable = false;
  enableCommunicationApps = false;
  enableExtraBrowsers = false;
  enableProductivityApps = false;
  aiCodeEditorsEnable = false;

  # Bar/Shell Choice
  barChoice = "noctalia";
  defaultShell = "zsh";

  # Theming
  stylixImage = ../../wallpapers/clouds.jpg;

  # Startup Applications
  startupApps = [ ];
  startupCommands = [
    "sleep 1; env -u http_proxy -u https_proxy -u all_proxy -u HTTP_PROXY -u HTTPS_PROXY -u ALL_PROXY yandex-music --no-sandbox --no-proxy-server >/dev/null 2>&1 & Telegram >/dev/null 2>&1 &"
    "sleep 3; antigravity >/dev/null 2>&1 & google-chrome >/dev/null 2>&1 &"
  ];
}
