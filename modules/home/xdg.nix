{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  xdg = {
    enable = true;
    mimeApps = {
      enable = true;
    };
    portal = {
      enable = lib.mkForce true;
      extraPortals = [
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland
      ];
      configPackages = [ inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland ];
    };
  };
}
