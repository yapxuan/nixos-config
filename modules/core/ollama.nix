{ pkgs, ... }:
{
  services = {
    open-webui.enable = true;
    ollama = {
      enable = true;
      package = pkgs.ollama-rocm;
      acceleration = "rocm";
      rocmOverrideGfx = "11.0.0";
    };
  };
  boot.kernelModules = [ "amdgpu" ]; # workaround of race condition (see issue #422355 on nixpkgs)
}
