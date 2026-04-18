{ ... }:
{
  # Use nix-index-database for instant nix-locate
  # Replaces the default command-not-found with nix-index
  programs.nix-index = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.command-not-found.enable = false;
}
