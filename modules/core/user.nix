{
  pkgs,
  username,
  host,
  profile,
  flake_dir,
  inputs,
  system,
  config,
  ...
}:
let
  inherit (import ../../hosts/${host}/variables.nix) gitUsername;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];
  home-manager = {
    useGlobalPkgs = true;
    backupFileExtension = "backup";
    overwriteBackup = true;
    extraSpecialArgs = {
      inherit
        username
        host
        profile
        flake_dir
        inputs
        system
        ;
    };
    users.${username} = {
      imports = [ ./../home ];
      home = {
        username = "${username}";
        homeDirectory = "/home/${username}";
        stateVersion = "25.05";
      };
    };
  };
  users.mutableUsers = true;
  users.users.${username} = {
    isNormalUser = true;
    description = "${gitUsername}";
    extraGroups = [
      "adbusers"
      "libvirtd"
      "networkmanager"
      "wheel"
      "render"
      "video"
    ];
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
  };
  nix = {
    settings = {
      #cores = 8;
      max-jobs = 2;
      allowed-users = [ "${username}" ];
      system-features = [
        "benchmark"
        "big-parallel"
        "kvm"
        "nixos-test"
        "gccarch-znver4"
      ];
    };
    extraOptions = ''
      !include ${config.age.secrets.github_token.path}
    '';
  };
  #specialisation = {
  # heavywork.configuration = {
  #   nix.settings = {
  #     cores = 0;
  #     max-jobs = 1;
  #   };
  # };
  #};
}
