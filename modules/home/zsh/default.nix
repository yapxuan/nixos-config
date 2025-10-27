{
  pkgs,
  lib,
  osConfig,
  ...
}:
{
  home.shell.enableZshIntegration = true;
  programs = {
    carapace.enable = true;
    nix-your-shell = {
      enable = true;
      nix-output-monitor.enable = true;
    };
    atuin = {
      enable = true;
      flags = [ "--disable-ctrl-r" ];
      settings = {
        style = "auto";
        command_chaining = true;
        enter_accept = true;
        prefers_reduced_motion = true;
        auto_sync = true;
        sync.records = true;
        sync_frequency = "5m";
        sync_address = "https://api.atuin.sh";
        search_mode = "fuzzy";
        session_path = osConfig.age.secrets."atuin_session".path;
        key_path = osConfig.age.secrets."atuin_key".path;
      };
    };
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting = {
        enable = true;
        highlighters = [
          "main"
          "brackets"
          "pattern"
          "regexp"
          "root"
          "line"
        ];
      };
      historySubstringSearch.enable = true;

      history = {
        ignoreDups = true;
        save = 10000;
        size = 10000;
      };

      oh-my-zsh = {
        enable = true;
      };

      plugins = [
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
        {
          name = "powerlevel10k-config";
          src = lib.cleanSource ./p10k-config;
          file = "p10k.zsh";
        }
      ];

      initContent = ''
        bindkey "\eh" backward-word
        bindkey "\ej" down-line-or-history
        bindkey "\ek" up-line-or-history
        bindkey "\el" forward-word
        nix() {
                case "$1" in
                shell | develop | build)
                        nom "$@"
                        ;;
                *)
                        command nix "$@"
                        ;;
                esac
        }
      '';

      shellAliases = {
        sv = "sudo nvim";
        v = "nvim";
        c = "clear";
        f = "c && fastfetch";
        fr = "nh os switch";
        ncg = "nh clean all";
        man = "batman";
        curl = "curlie";
        nix-shell = "nom-shell";
        nix-build = "nom-build";
      };
    };
  };
}
