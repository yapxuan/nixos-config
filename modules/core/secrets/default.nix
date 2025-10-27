# import & decrypt secrets in `mysecrets` in this module
{
  pkgs,
  inputs,
  ...
}:
let
  inherit (inputs) ragenix mysecrets;
in
{
  imports = [ ragenix.nixosModules.default ];
  environment.systemPackages = [ inputs.ragenix.packages.${pkgs.stdenv.hostPlatform.system}.default ];
  age = {
    ageBin = "${pkgs.rage}/bin/rage";
    # if you changed this key, you need to regenerate all encrypt files from the decrypt contents!
    identityPaths = [
      # using the host key for decryption
      # the host key is generated on every host locally by openssh, and will never leave the host.
      "/etc/ssh/ssh_host_ed25519_key"
    ];

    secrets = {
      "primary-key" = {
        # whether secrets are symlinked to age.secrets.<name>.path
        symlink = true;
        # encrypted file path
        file = "${mysecrets}/puiyq-primary-key.priv.age"; # refer to ./xxx.age located in `mysecrets` repo
        mode = "0400";
        owner = "root";
        group = "root";
      };
      "gpg-subkeys" = {
        symlink = true;
        file = "${mysecrets}/puiyq-gpg-subkeys.priv.age";
        mode = "0400";
        owner = "root";
        group = "root";
      };
      "revoke-cert" = {
        symlink = true;
        file = "${mysecrets}/revoke.asc.age";
        mode = "0400";
        owner = "root";
        group = "root";
      };
      "cachix" = {
        symlink = true;
        file = "${mysecrets}/cachix.age";
        mode = "0400";
        owner = "root";
        group = "root";
      };
      "maxmind_license_key" = {
        symlink = true;
        file = "${mysecrets}/maxmind_license_key.age";
        mode = "0400";
        owner = "root";
        group = "root";
      };
      "duckdns" = {
        symlink = true;
        file = "${mysecrets}/duckdns.age";
        mode = "0400";
        owner = "root";
        group = "root";
      };
      "atuin_key" = {
        symlink = true;
        file = "${mysecrets}/atuin_key.age";
        mode = "0400";
        owner = "puiyq";
        group = "users";
      };
      "atuin_session" = {
        symlink = true;
        file = "${mysecrets}/atuin_session.age";
        mode = "0400";
        owner = "puiyq";
        group = "users";
      };
      "github_token" = {
        symlink = true;
        file = "${mysecrets}/github_token.age";
        mode = "0400";
        owner = "root";
        group = "root";
      };
      "gmail_app_password" = {
        symlink = true;
        file = "${mysecrets}/gmail_app_password.age";
        mode = "0400";
        owner = "puiyq";
        group = "users";
      };
    };
  };
}
