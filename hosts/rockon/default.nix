{ pkgs, lib, inputs, ... }:
{
  imports = [
    ./hardware.nix
    ./host-packages.nix
    ./secure-boot.nix
  ];
		
  # Enable sddm display manager
  services.displayManager.sddm.enable = true;

  networking.nftables.enable = true;
  services.v2raya.enable = true;  

  services.udev.extraRules = ''
    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="342d", ATTRS{idProduct}=="e40f", TAG+="uaccess"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="342d", ATTRS{idProduct}=="e40f", TAG+="uaccess"
    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="2442", ATTRS{idProduct}=="b071", TAG+="uaccess"
    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="342d", ATTRS{idProduct}=="e410", TAG+="uaccess"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="342d", ATTRS{idProduct}=="e410", TAG+="uaccess"
  '';

  # Sysc-greet display manager
  services.sysc-greet.enable = false;

  # Keep niri available at system level for ly display manager to detect it
  programs.niri.package = pkgs.niri;
  
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

  # Ensure niri session is available to display manager
  services.displayManager.sessionPackages = [ pkgs.niri ];
}

