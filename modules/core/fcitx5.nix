{ pkgs, ... }:
{
  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        (fcitx5-rime.override {
          rimeDataPkgs = [
            rime-ice
            rime-zhwiki
            rime-moegirl
          ];
        })
        qt6Packages.fcitx5-configtool
        fcitx5-nord
      ];
    };
  };
}
