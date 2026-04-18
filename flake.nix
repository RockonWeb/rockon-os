{
  description = "Rockon OS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    quickshell = {
      url = "github:outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    helium-browser = {
      url = "github:fpletz/flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ flake-parts, nixpkgs, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" ];

      flake = {
        nixosConfigurations =
          let
            mkHost = { hostname, profile, username }: nixpkgs.lib.nixosSystem {
              system = "x86_64-linux"; # Using standard x86_64 system for all hosts
              specialArgs = {
                inherit inputs;
                host = hostname;
                inherit profile;
                inherit username;
                zen-browser = inputs.zen-browser.packages."x86_64-linux".default;
                helium-browser = inputs.helium-browser.packages."x86_64-linux".helium-browser;
              };
              modules = [
                ./profiles/${profile}
                inputs.nix-index-database.nixosModules.nix-index
              ];
            };
          in
          {
            default = mkHost { hostname = "default"; profile = "nvidia"; username = "user"; };
            rockon = mkHost { hostname = "rockon"; profile = "nvidia"; username = "rockon"; };
            nix-tester = mkHost { hostname = "nix-tester"; profile = "intel"; username = "don"; };
            nix-test = mkHost { hostname = "nix-test"; profile = "intel"; username = "don"; };
          };
      };

      perSystem = { system, pkgs, self', ... }:
        let
          treefmtEval = inputs.treefmt-nix.lib.evalModule pkgs {
            programs.nixfmt.enable = true;
          };
        in
        {
          formatter = treefmtEval.config.build.wrapper;

          checks =
            let
              # Verify all NixOS configurations evaluate correctly
              nixosChecks = nixpkgs.lib.mapAttrs' (name: config:
                nixpkgs.lib.nameValuePair "nixos-${name}" (
                  pkgs.runCommand "eval-${name}" {} ''
                    echo "Evaluating ${name}: ${builtins.unsafeDiscardStringContext config.config.system.build.toplevel.drvPath}"
                    touch $out
                  ''
                )
              ) (nixpkgs.lib.filterAttrs (_: config: config.pkgs.system == system) inputs.self.nixosConfigurations);
            in
            nixosChecks // {
              formatting = treefmtEval.config.build.check inputs.self;
            };
        };


    };
}
