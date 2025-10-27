{ pkgs, ... }:
{
  fonts = {
    packages = with pkgs; [
      noto-fonts-color-emoji
      noto-fonts-cjk-sans
      font-awesome
      #symbola  Fails to build 7/16/25 waiting on fix
      # https://github.com/nixos/nixpkgs/issues/425166
      material-icons
      fira-code
      fira-code-symbols
      corefonts
    ];
  };
}
