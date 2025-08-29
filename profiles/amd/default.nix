{ host, ... }:
{
  imports = [
    ../../hosts/${host}
    ../../modules/drivers
    ../../modules/core
    ../../overlay
  ];
  # Enable GPU Drivers
  drivers.amdgpu.enable = true;
}
