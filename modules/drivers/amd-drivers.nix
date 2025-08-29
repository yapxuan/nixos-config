{
  lib,
  pkgs,
  config,
  rocm64,
  ...
}:
with lib;
let
  cfg = config.drivers.amdgpu;
in
{
  options.drivers.amdgpu = {
    enable = mkEnableOption "Enable AMD Drivers";
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules =
      let
        rocmEnv = pkgs.symlinkJoin {
          name = "rocm-combined";
          paths = with rocm64.rocmPackages; [
            rocblas
            hipblas
            clr
            hiprt
            rocfft
            hipcc
            rocrand
            hipsparse
            migraphx
            miopen
          ];
        };
      in
      [
        "L+    /opt/rocm   -    -    -     -    ${rocmEnv}"
      ];
    services.xserver.videoDrivers = [ "amdgpu" ];
  };
}
