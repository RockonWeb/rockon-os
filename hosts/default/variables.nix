{
  # Git Configuration ( For Pulling Software Repos )
  gitUsername = "user";
  gitEmail = "user@example.com";

  # System Configuration
  timeZone = "America/New_York";

  # Monitor Settings
  # ex "monitor=HDMI-A-1, 1920x1080@60,auto,1"
  # Configure your monitors here - this is host-specific
  extraMonitorSettings = ''
    monitor=,preferred,auto,1
  '';

  # Waybar Settings
  clock24h = false;

  # Program Options
  browser = "zen"; # Set Default Browser (google-chrome-stable for google-chrome)
  terminal = "kitty"; # Set Default System Terminal
  keyboardLayout = "us";
  consoleKeyMap = "us";

  # For Nvidia Prime support
  # Run 'lspci | grep VGA' to find your actual GPU IDs
  intelID = "PCI:0:2:0"; # Update with your integrated GPU ID
  nvidiaID = "PCI:1:0:0"; # Update with your NVIDIA GPU ID

  # Enable Nvidia cudaSupport for specific applications (obs-studio)
  useNvidia = false;

  # Enable NFS
  enableNFS = true;

  # Enable Printing Support
  printEnable = false;

  # Enable Thunar GUI File Manager
  thunarEnable = true;

  # Enable Gaming Support (controllers, gamescope, protonup-qt)
  gamingSupportEnable = false;

  # Enable Flutter Development Environment
  flutterdevEnable = false;

  # Enable Stylix System Theming
  stylixEnable = true;

  # Enable Syncthing File Synchronization
  syncthingEnable = false;

  # Enable Communication Apps (Teams, Zoom, Telegram, Discord)
  enableCommunicationApps = false;

  # Enable Extra Browsers (Chromium, Google Chrome)
  enableExtraBrowsers = false;

  # Enable Productivity Apps (Obsidian, GNOME Boxes, QuickEmu)
  enableProductivityApps = false;

  # Enable AI Code Editors (cursor, claude-code, gemini-cli)
  aiCodeEditorsEnable = false;



  # Bar/Shell Choice
  barChoice = "noctalia"; # Options: "dms" or "noctalia"
  # NOTE: If you change barChoice to "dms", you must run 'dms-install' after rebuilding

  # Shell Choice
  defaultShell = "zsh"; # Options: "fish" or "zsh"

  # Set Stylix Image
  #stylixImage = ../../wallpapers/AnimeGirlNightSky.jpg;
  #stylixImage = ../../wallpapers/nix-wallpaper-stripes-logo.png;
  #stylixImage = ../../wallpapers/beautifulmountainscape.png;
  #stylixImage = ../../wallpapers/mountainscapedark.jpg;
  #stylixImage = ../../wallpapers/Rainnight.jpg;
  #stylixImage = ../../wallpapers/zaney-wallpaper.jpg;
  stylixImage = ../../wallpapers/55.png;

  # Startup Applications
  # This is the authoritative per-host autostart list for user apps in Niri.
  startupApps = [
  ];
}
