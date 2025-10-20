{
  host,
  pkgs,
  config,
  flake_dir,
  ...
}:
let
  inherit (import ../../hosts/${host}/variables.nix) gitUsername gitEmail;
in
{
  programs = {
    delta = {
      enable = true;
      enableGitIntegration = true;
      options = {
        line-numbers = true;
        navigate = true;
        hyperlinks = true;
      };
    };
    jujutsu = {
      enable = true;
      package = pkgs.jujutsu_git;
      settings = {
        user = {
          email = "${gitEmail}";
          name = "${gitUsername}";
        };
        ui = {
          pager = "delta";
          editor = "nvim";
          default-command = [ "log" ];
          diff-formatter = ":git";
        };
        signing = {
          behavior = "own";
          backend = "gpg";
          key = "CCDCA20D4A5F54D004F088A8272D4F26832F8EF8";
        };
        git.sign-on-push = true;
      };
    };
    git = {
      enable = true;
      package = pkgs.gitFull;

      settings = {
        user = {
          name = "${gitUsername}";
          email = "${gitEmail}";
        };
        credential.helper = "libsecret"; # For store gmail app password
        # FOSS-friendly settings
        push.default = "simple"; # Match modern push behavior
        init.defaultBranch = "main"; # Set default new branches to 'main'
        log.decorate = "full"; # Show branch/tag info in git log
        log.date = "iso"; # ISO 8601 date format
        # Conflict resolution style for readable diffs
        merge.conflictStyle = "diff3";
        diff.colorMoved = "default";
        sendemail = {
          smtpserver = "smtp.gmail.com";
          smtpserverport = "587";
          smtpencryption = "tls";
          smtpuser = "${gitEmail}";
        };
      };

      signing = {
        format = "openpgp";
        key = "CCDCA20D4A5F54D004F088A8272D4F26832F8EF8";
        signByDefault = true;
        signer = "${pkgs.gnupg}/bin/gpg";
      };
      maintenance = {
        enable = true;
        repositories = [
          "${config.home.homeDirectory}/nixpkgs"
          "${flake_dir}"
        ];
      };
      ignores = [
        ".direnv"
        ".venv"
        "target"
        "result"
        ".Trash-1000"
      ];
    };
  };
}
