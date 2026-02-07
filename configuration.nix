{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  nixpkgs.config.allowUnfree = true;

  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = false; # Disable systemd-boot explicitly
    limine.enable = true;
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "mati-nixing";
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Rome";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    keyMap = "it";
  };

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  services.displayManager.ly.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;
  security.polkit.enable = true;

  systemd.user.services.polkit-kde-authentication-agent-1 = {
    description = "polkit-kde-authentication-agent-1";
    wantedBy = [ "niri.service" ]; # This creates the niri.wants relationship
    after = [ "niri.service" ]; # Start after niri starts
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
  systemd.user.services.ironbar = {
    description = "ironbar";
    wantedBy = [ "niri.service" ]; # This creates the niri.wants relationship
    after = [ "niri.service" ]; # Start after niri starts
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.ironbar}/bin/ironbar";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  users.users.matilde = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      tree
    ];
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;

    ohMyZsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "git"
      ];
    };
  };

  programs.zoxide.enableZshIntegration = true;

  programs.firefox.enable = true;
  programs.niri.enable = true;
  programs.foot.enable = true;
  programs.vscode.enable = true;
  programs.zoxide.enable = true;

  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-qt;
  };

  services.udisks2.enable = true;

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

  environment.systemPackages = with pkgs; [
    neovim
    fuzzel
    niri
    foot
    discord
    xwayland-satellite
    signal-desktop
    hyfetch
    fastfetch
    xdg-desktop-portal-gtk
    xdg-desktop-portal-gnome
    gnome-keyring
    efibootmgr
    seahorse
    kdePackages.polkit-kde-agent-1
    nixfmt
    git
    gnupg
    zoxide
    nautilus
    udiskie
    ironbar
    claude-code
    zellij
    mako
    (vscode.override {
      commandLineArgs = [
        "--enable-features=UseOzonePlatform,WaylandWindowDecorations"
        "--ozone-platform=wayland"
        "--password-store=gnome-libsecret"
      ];
    })
  ];

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?
}
