{ pkgs, ... }:
{
  # Only enable either docker or podman -- Not both
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu.swtpm.enable = true;
    };
    spiceUSBRedirection.enable = true;
    docker.enable = false;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true; # Required for containers under podman-compose to be able to talk to each other.
      autoPrune.enable = true;
    };
    #waydroid.enable = true;
  };
  programs.virt-manager.enable = true;

  environment.systemPackages = with pkgs; [
    virt-viewer # View Virtual Machines
    podman-compose # start group of containers for dev
    #nur.repos.ataraxiasjel.waydroid-script
    #waydroid-helper
  ];
}
