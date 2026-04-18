{ pkgs, ... }:
{
  # Shared host-level defaults that should follow you across machines.
  services.displayManager.sddm.enable = true;

  networking.nftables.enable = true;
  services.v2raya.enable = true;

  zramSwap = {
    enable = true;
    memoryPercent = 25;
  };

  services.udev.extraRules = ''
    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="342d", ATTRS{idProduct}=="e40f", TAG+="uaccess"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="342d", ATTRS{idProduct}=="e40f", TAG+="uaccess"
    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="2442", ATTRS{idProduct}=="b071", TAG+="uaccess"
    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="342d", ATTRS{idProduct}=="e410", TAG+="uaccess"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="342d", ATTRS{idProduct}=="e410", TAG+="uaccess"
  '';

  # Keep niri available at system level for the display manager.
  programs.niri.package = pkgs.niri;
  services.displayManager.sessionPackages = [ pkgs.niri ];

  environment.systemPackages = with pkgs; [
    gedit
  ];

  environment.variables = {
    EDITOR = "nano";
    VISUAL = "gedit";
  };

  xdg.mime.enable = true;
  xdg.mime.defaultApplications = {
    "text/plain" = [ "org.gnome.gedit.desktop" ];
  };
}
