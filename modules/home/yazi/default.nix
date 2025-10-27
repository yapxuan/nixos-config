{
  pkgs,
  ...
}:
let
  settings = import ./yazi.nix;
  keymap = import ./keymap.nix;
  theme = import ./theme.nix;
in
{
  programs.yazi = {
    enable = true;
    package = pkgs.yazi.override {
      _7zz = pkgs._7zz-rar;
    };
    enableZshIntegration = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    shellWrapperName = "yy";
    inherit settings keymap theme;
    plugins = {
      inherit (pkgs.yaziPlugins)
        lazygit
        full-border
        git
        smart-enter
        mount
        ;
    };

    initLua = ''
      require("full-border"):setup()
         require("git"):setup()
         require("smart-enter"):setup {
           open_multi = true,
         }
    '';
  };
}
