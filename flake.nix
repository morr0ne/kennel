{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-compat = {
      url = "github:NixOS/flake-compat";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };

    chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixcord = {
      url = "github:FlameFlag/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-parts.follows = "flake-parts";
    };

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helix = {
      url = "github:helix-editor/helix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri-nix = {
      url = "git+https://codeberg.org/BANanaD3V/niri-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ironbar = {
      url = "github:JakeStanger/ironbar/v0.19.0";
      inputs.flake-compat.follows = "flake-compat";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };

    weston-demos = {
      url = "github:rosymati/weston-demos-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixos-hardware,
      ...
    }:
    let
      overlays = with inputs; {
        nixpkgs.overlays = [
          helix.overlays.default
          weston-demos.overlays.default

          (final: prev: llm-agents.packages.${prev.stdenv.hostPlatform.system} or { })

          (final: prev: {
            zen-browser = zen-browser.packages.${prev.stdenv.hostPlatform.system}.default;
            ironbar = ironbar.packages.${prev.stdenv.hostPlatform.system}.default;

            linux-firmware = prev.linux-firmware.overrideAttrs (old: {
              version = "unstable-2026-07-06";
              src = prev.fetchgit {
                url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
                rev = "2c35b1ed46f661baaf14b08cebb9201ca802f939";
                hash = "sha256-omvuU48DpQ+KCxTU4JWj9ivzgFwrykuCBMCGGpa6kKM=";
              };
            });
          })
        ];
      };

      commonModules = with inputs; [
        overlays
        hjem.nixosModules.default
        chaotic.nixosModules.default
        nixcord.nixosModules.nixcord
      ];
    in
    {
      devShells = import ./modules/devshell.nix { inherit nixpkgs; };

      nixosConfigurations.ahnashawn = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/ahnashawn/default.nix
        ]
        ++ commonModules;
      };

      nixosConfigurations.frameyboy = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          nixos-hardware.nixosModules.framework-amd-ai-300-series
          ./hosts/frameyboy/default.nix
        ]
        ++ commonModules;
      };
    };
}
