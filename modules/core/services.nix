{
  pkgs,
  config,
  ...
}:
{
  # Services to start
  services = {
    ntpd-rs = {
      enable = true;
      useNetworkingTimeServers = true;
    };
    geoipupdate = {
      enable = true;
      settings = {
        AccountID = 1231707;
        DatabaseDirectory = "/var/lib/GeoIP";
        LicenseKey = config.age.secrets.maxmind_license_key.path;
        EditionIDs = [
          "GeoLite2-ASN"
          "GeoLite2-City"
          "GeoLite2-Country"
        ];
      };
    };
    fwupd.enable = true;
    btrfs.autoScrub = {
      enable = true;
      interval = "weekly";
    };
    beesd.filesystems = {
      "root" = {
        spec = "/";
        hashTableSizeMB = 2048;
        verbosity = "crit";
        extraOptions = [
          "--loadavg-target"
          "5.0"
        ];
      };
    };
    cachix-watch-store = {
      enable = true;
      verbose = true;
      cacheName = "puiyq";
      cachixTokenFile = config.age.secrets.cachix.path;
    };
    ananicy = {
      enable = true;
      package = pkgs.ananicy-cpp;
      rulesProvider = pkgs.ananicy-rules-cachyos_git;
    };
    #onedrive.enable = true;
    dbus = {
      implementation = "broker";
      packages = [ pkgs.gcr_4 ];
    };
    pipewire.lowLatency.enable = true;
    swapspace.enable = true;
    speechd.enable = false;
    libinput.enable = true; # Input Handling
    fstrim.enable = true; # SSD Optimizer
    gvfs.enable = true; # For Mounting USB & More
    openssh.enable = false; # Enable SSH
    blueman.enable = true; # Bluetooth Support
    tumbler.enable = true; # Image/video preview
    scx = {
      enable = true; # by default uses scx_rustland scheduler
      scheduler = "scx_rusty";
      package = pkgs.scx_git.rustscheds;
      extraArgs = [
        "--slice-us-underutil"
        "30000"
        "--slice-us-overutil"
        "1500"
        "--interval"
        "1.5"
        "--direct-greedy-under"
        "70"
        "--kick-greedy-under"
        "90"
        "--perf"
        "512"
      ];
    };
    gnome.gnome-keyring.enable = true;
    power-profiles-daemon.enable = true;
    envfs.enable = true;
    smartd = {
      enable = true;
      notifications = {
        mail = {
          enable = true;
          sender = "puiyongqing@gmail.com";
          recipient = "puiyongqing@gmail.com";
        };
      };
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

  powerManagement.cpuFreqGovernor = "performance";

  zramSwap = {
    enable = true;
    writebackDevice = "/dev/nvme0n1p5";
  };
  systemd.oomd.enable = false;

  systemd.services.set-battery-threshold = {
    description = "Set battery charge limit to 90%";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/run/current-system/sw/bin/bash -c 'echo 90 > /sys/class/power_supply/BAT0/charge_control_end_threshold'";
    };
  };
}
