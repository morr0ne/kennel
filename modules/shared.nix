{ lib, pkgs, ... }:

{
  imports = [
    ./packages.nix
    ./niri.nix
    ./ironbar.nix
    ./awww.nix
  ];

  nixpkgs.config.allowUnfree = true;

  time.timeZone = "Europe/Rome";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    keyMap = "it";
  };

  users.users.matilde = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "gamemode"
    ];
    shell = pkgs.zsh;
  };

  hjem.users = {
    matilde = {
      enable = true;
      directory = "/home/matilde";
      user = "matilde";

      xdg.config.files = {
        "git/config" = {
          generator = lib.generators.toGitINI;

          value = {
            user = {
              name = "Matilde Morrone";
              email = "contact@matilde.pet";
              signingkey = "8BCD8313AED05D32";
            };
            commit.gpgsign = true;
            init.defaultBranch = "main";
          };
        };
      };
    };
  };

  programs = {
    foot.enable = true;
    vscode.enable = true;
    nix-ld.enable = true;
    gamemode.enable = true;

    gnupg.agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-qt;
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    steam = {
      enable = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };

    zsh = {
      enable = true;
      enableCompletion = true;

      ohMyZsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = [
          "git"
        ];
      };

      shellInit = ''
        eval "$(fnm env --use-on-cd --shell zsh)"
      '';
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    obs-studio = {
      enable = true;

      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-vkcapture
        obs-pipewire-audio-capture
        obs-vaapi
        obs-gstreamer
      ];
    };

    nixcord =
      let
        enablePlugins =
          plugins:
          lib.mergeAttrsList (
            map (
              name:
              if builtins.isString name then
                { ${name}.enable = true; }
              else
                lib.mapAttrs (_: opts: opts // { enable = true; }) name
            ) plugins
          );
      in
      {
        enable = true;
        user = "matilde";

        discord.enable = false;

        legcord = {
          enable = true;
          equicord.enable = true;
          settings = {
            mods = [ "equicord" ];
            tray = true;
            hardwareAcceleration = true;
            doneSetup = true;
          };
        };

        config.plugins = enablePlugins [
          "userMessagesPronouns"
          "questify"
          "betterGifPicker"
          { lastFmRichPresence.apiKey = ""; }
        ];
      };
  };

  fonts.packages =
    with pkgs;
    [
      noto-fonts
      noto-fonts-color-emoji
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      liberation_ttf
    ]
    ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

  virtualisation.docker = {
    enable = true;

    rootless = {
      enable = true;
      setSocketVariable = true;
    };

    storageDriver = "btrfs";
  };

  environment = {
    localBinInPath = true;
    etc."xdg/autostart/foot-server.desktop" = lib.mkOverride 0 { enable = false; };
    sessionVariables.NIXOS_OZONE_WL = "1";
  };

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    extra-substituters = [
      "https://helix.cachix.org"
      "https://cache.numtide.com" # llm-agents
      "https://niri-nix.cachix.org"
      "https://jakestanger.cachix.org"
    ];
    extra-trusted-public-keys = [
      "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=" # llm-agents
      "niri-nix.cachix.org-1:SvFtqpDcf7Sm1SMJdby1/+Y+6f3Yt3/3PMcSTKPJNJ0="
      "jakestanger.cachix.org-1:VWJE7AWNe5/KOEvCQRxoE8UsI2Xs2nHULJ7TEjYm7mM="
    ];
  };
}
