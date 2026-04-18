(import ../shared/variables.nix) // {
  extraMonitorSettings = ''
    monitor=DP-2,2560x1440@165.001,0x0,1.25
  '';

  dockMonitors = [ "DP-2" ];

  intelID = "PCI:0:2:0";
  nvidiaID = "PCI:1:0:0";
}
