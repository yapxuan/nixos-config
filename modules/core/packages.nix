{
  pkgs,
  inputs,
  ...
}:
{
  programs = {
    zsh.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
    };
    firefox.enable = false; # Firefox is not installed by default
    dconf.enable = true;
    seahorse.enable = true;
    hyprland = {
      enable = true; # create desktop file and depedencies if you switch to GUI login MGR
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage =
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };
    hyprlock.enable = true;
    fuse.userAllowOther = true;
    trippy.enable = true;
    #adb.enable = true;
    gnupg.agent = {
      enable = true;
    };
  };
  nix.package = pkgs.nixVersions.git;
  nixpkgs.config.allowUnfree = true;

  environment.sessionVariables = {
    SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/gcr/ssh";
  };

  environment.systemPackages = with pkgs; [
    (lazyjj.override { jujutsu = pkgs.jujutsu_git; })
    firedragon-catppuccin-bin
    inputs.self.packages.${system}.animeko
    discord
    xarchiver
    teams-for-linux
    #blender-hip
    rage
    (pkgs.bilibili.override {
      commandLineArgs = "--ozone-platform-hint=wayland --enable-wayland-ime --enable-features=UseOzonePlatform";
    })
    cryptsetup
    adwaita-icon-theme
    onlyoffice-desktopeditors
    varia
    #winetricks
    #wineWowPackages.stagingFull
    (pkgs.element-desktop.override { commandLineArgs = "--password-store=gnome-libsecret"; })
    bottom # btop like util
    brightnessctl # For Screen Brightness Control
    curlie
    duf # Utility For Viewing Disk Usage In Terminal
    dysk # disk usage util
    eza # Beautiful ls Replacement
    fd
    ffmpeg # Terminal Video / Audio Editing
    gdu # graphical disk usage
    glow
    loupe # For Image Viewing
    jq
    killall # For Killing All Instances Of Programs
    libnotify # For Notifications
    mpv # Incredible Video Player
    nix-output-monitor
    (nixpkgs-review.override { withNom = true; })
    pavucontrol # For Editing Audio Levels & Devices
    pciutils # Collection Of Tools For Inspecting PCI Devices
    pkg-config # Wrapper Script For Allowing Packages To Get Info On Others
    playerctl # Allows Changing Media Volume Through Scripts
    ripgrep # Improved Grep
    socat # Needed For Screenshots
    sox # audio support for FFMPEG
    swww
    unrar # Tool For Handling .rar Files
    unzip # Tool For Handling .zip Files
    usbutils # Good Tools For USB Devices
    # v4l-utils # Used For Things Like OBS Virtual Camera
    # waypaper # backup wallpaper GUI
    wget # Tool For Fetching Files With Links
    zapzap # Alternative of Whatsapp
    (prismlauncher.override {
      # Add binary required by some mod
      additionalPrograms = [ ffmpeg ];

      # Change Java runtimes available to Prism Launcher
      jdks = [
        zulu8
        zulu17
        zulu
      ];
    })
  ];
}
