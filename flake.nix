{
  description = "ZaneyOS";

  inputs = {
    # Core dependencies
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Placeholders
    flake-utils.follows = "yazi/flake-utils";
    gitignore.follows = "hyprland/pre-commit-hooks/gitignore";

    # System configuration
    systems.url = "github:nix-systems/x86_64-linux";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
      inputs = {
        rust-overlay.follows = "rust-overlay";
        home-manager.follows = "home-manager";
        jovian.follows = "";
      };
    };
    stylix = {
      url = "github:danth/stylix/master";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        systems.follows = "systems";
        # nur.follows = "nur";
      };
    };

    # Window manager and related
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        pre-commit-hooks.inputs.flake-compat.follows = "";
        systems.follows = "systems";
      };
    };
    swww = {
      url = "github:LGFae/swww";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        rust-overlay.follows = "rust-overlay";
        flake-compat.follows = "";
      };
    };

    # Development tools - Editors and LSP
    nvf = {
      url = "github:notashelf/nvf";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        flake-parts.follows = "flake-parts";
      };
    };
    zls = {
      url = "github:zigtools/zls";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        zig-overlay.follows = "zig";
        gitignore.follows = "gitignore";
      };
    };

    # Development tools - Language toolchains
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zig = {
      #block untill https://github.com/zigtools/zls/pull/2457 merged
      #url = "github:silversquirl/zig-flake";
      url = "github:mitchellh/zig-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "";
        flake-utils.follows = "flake-utils";
      };
    };

    # Applications
    yazi = {
      url = "github:sxyazi/yazi";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        rust-overlay.follows = "rust-overlay";
      };
    };
    ghostty = {
      url = "github:ghostty-org/ghostty";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        zig.follows = "zig";
        zon2nix.follows = "";
        flake-compat.follows = "";
        flake-utils.follows = "flake-utils";
      };
    };
    prismlauncher = {
      url = "github:PrismLauncher/PrismLauncher";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };

    # Secrets management
    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
        systems.follows = "systems";
        darwin.follows = "";
      };
    };
    ragenix = {
      url = "github:yaxitech/ragenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        rust-overlay.follows = "rust-overlay";
        flake-utils.follows = "flake-utils";
        agenix.follows = "agenix";
      };
    };
    mysecrets = {
      url = "git+ssh://git@github.com/yapxuan/nix-secret.git?shallow=1";
      flake = false;
    };

    # Utilities
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Alternative package managers
    #lix = {
    #  url = "https://git.lix.systems/lix-project/lix/archive/main.tar.gz";
    #  flake = false;
    #};
    #lix-module = {
    # url = "https://git.lix.systems/lix-project/nixos-module/archive/main.tar.gz";
    # inputs = {
    #    nixpkgs.follows = "nixpkgs";
    #   lix.follows = "lix";
    #   flake-utils.inputs.systems.follows = "systems";
    # };
    #};

    #nur = {
    # url = "github:nix-community/NUR";
    # inputs.nixpkgs.follows = "nixpkgs";
    # inputs.flake-parts.follows = "flake-parts";
    #};
  };
  outputs =
    {
      self,
      nixpkgs,
      treefmt-nix,
      rust-overlay,
      zig,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      host = "nixos";
      username = "puiyq";
      flake_dir = "/home/${username}/zaneyos";
      pkgs = import nixpkgs {
        inherit system;
        config = {
          rocmSupport = true;
          allowUnfree = true;
        };
        overlays = [
          (final: _prev: {
            animeko = final.callPackage ./pkgs/animeko { };
          })
          rust-overlay.overlays.default
          zig.overlays.default
        ];
      };
    in
    {
      packages.${system} = {
        inherit (pkgs) animeko;
      };
      templates.treefmt = {
        path = ./templates/treefmt;
        description = "Minimal treefmt-nix";
      };
      formatter.${system} = treefmt-nix.lib.mkWrapper pkgs ./treefmt.nix;
      checks.${system} = {
        treefmt = self.formatter.${system};
      };
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit
              inputs
              username
              host
              flake_dir
              system
              ;
            profile = "amd";
          };
          modules = [
            ./profiles/amd
          ];
        };
      };
      devShells.${system} = {
        ts = pkgs.mkShell {
          nativeBuildInputs = [ pkgs.bun ];
        };
        fortran = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            gfortran
          ];
        };
        zig = pkgs.mkShell.override { stdenv = pkgs.clangStdenv; } {
          nativeBuildInputs = with pkgs; [
            zigpkgs.master
          ];
        };
        go = pkgs.mkShell.override { stdenv = pkgs.clangStdenv; } {
          nativeBuildInputs = with pkgs; [
            go
          ];
          shellHook = ''
            export CC=clang
            export CXX=clang++
            export CGO_CFLAGS="-O2 -march=znver4 -g"
            export CGO_CXXFLAGS="-O2 -march=znver4 -g"
            export GOAMD64=v4
          '';
        };
        python = pkgs.mkShell.override { stdenv = pkgs.clangStdenv; } {
          nativeBuildInputs = with pkgs; [
            (python3.override {
              enableOptimizations = true;
              reproducibleBuild = false;
            })
          ];
          shellHook = ''export LD_LIBRARY_PATH=$NIX_LD_LIBRARY_PATH:$LD_LIBRARY_PATH'';
        };
        rust = pkgs.mkShell.override { stdenv = pkgs.clangStdenv; } {
          buildInputs = [
            pkgs.rustlings
          ];
          nativeBuildInputs = [
            (pkgs.rust-bin.selectLatestNightlyWith (
              toolchain: toolchain.default
              #.override {
              #  extensions = [
              #   "llvm-tools"
              #   "rust-src"
              # ];
              #}
            ))
          ];
        };
      };
    };
}
