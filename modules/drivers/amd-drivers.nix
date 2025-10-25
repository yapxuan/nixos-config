{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.drivers.amdgpu;
in
{
  options.drivers.amdgpu = {
    enable = lib.mkEnableOption "Enable AMD Drivers";
    rocm.enable = lib.mkEnableOption "Enable ROCM";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      services.xserver.videoDrivers = [ "amdgpu" ];
    })

    (lib.mkIf cfg.rocm.enable {
      systemd.tmpfiles.rules =
        let
          rocmEnv = pkgs.symlinkJoin {
            name = "rocm-combined";
            paths = with pkgs.rocmPackages; [
              rocblas
              hipblas
              clr
              hiprt
              rocfft
              hipcc
              rocrand
              hipsparse
              half
              hsakmt
              rccl
              amdsmi
              rocm-smi
            ];
          };
        in
        [
          "L+    /opt/rocm   -    -    -     -    ${rocmEnv}"
        ];

      nixpkgs.config.rocmSupport = true;

      environment.variables = {
        HSA_OVERRIDE_GFX_VERSION = "11.0.0";
        PATH = lib.mkAfter "/opt/rocm/bin";
        LD_LIBRARY_PATH = lib.mkAfter "/opt/rocm/lib";
      };
    })
  ];
}
