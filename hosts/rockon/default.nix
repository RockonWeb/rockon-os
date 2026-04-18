{ config, ... }:
{
  imports = [
    ./hardware.nix
    ./host-packages.nix
    ../shared/default.nix
    ./secure-boot.nix
  ];

  # GTX 1070 (Pascal) requires the 580.xx legacy branch; 595.xx no longer supports it.
  drivers.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
}
