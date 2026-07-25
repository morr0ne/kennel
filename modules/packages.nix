{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    (pkgs.makeDesktopItem {
      name = "legcord-scorchy";
      desktopName = "Scorchy";
      comment = "Lightweight, alternative desktop client for Discord";
      exec = "legcord --user-data-dir=/home/matilde/.config/legcord-scorchy %U";
      icon = "legcord";
      terminal = false;
      categories = [
        "Network"
        "InstantMessaging"
        "Chat"
      ];
      keywords = [
        "discord"
        "vencord"
        "electron"
        "chat"
      ];
      genericName = "Internet Messenger";
      startupWMClass = "legcord-scorchy";
      extraConfig = {
        Version = "1.5";
      };
    })
    neovim
    fuzzel
    xwayland-satellite
    signal-desktop
    hyfetch
    fastfetch
    efibootmgr
    seahorse
    nixfmt
    git
    nautilus
    zellij
    mako
    teams-for-linux
    fnm
    uv
    wl-clipboard
    bun
    nil
    pavucontrol
    bubblewrap
    slack
    brightnessctl
    bottom
    file
    lsd
    spotify
    filezilla
    qbittorrent
    feishin
    android-studio
    theclicker
    prismlauncher
    jdk21_headless
    claude-code
    opencode
    codex
    pi
    pnpm
    zen-browser
    deno
    b3sum
    telegram-desktop
    # poetry
    dbeaver-bin
    postgresql
    yt-dlp
    android-tools
    unzip
    qdirstat
    usbutils
    ffmpeg-full
    tutanota-desktop
    p7zip
    screen
    pandoc
    inkscape
    helix
    awww
    eigenwallet
    veracrypt
    libreoffice-fresh
    hunspell
    hunspellDicts.en_US
    hunspellDicts.it_IT
    obsidian
    libarchive
    vlc
    easyeffects
    pulseaudio
    bruno
    xh
    jq
    tor-browser
    snapshot
    geeqie
    gallery-dl
    weston-demos
    todoist-electron
    python3
    tree
    ntfs3g
    ntfsprogs
    (pkgs.symlinkJoin {
      name = "sweethome3d";
      paths = [ pkgs.sweethome3d.application ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/sweethome3d \
          --set _JAVA_AWT_WM_NONREPARENTING 1
      '';
    })
    (vscode.override {
      commandLineArgs = [
        "--password-store=gnome-libsecret"
      ];
    })
  ];
}
