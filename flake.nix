{
  description = "ZaneyOS";

  inputs = {
    # Core dependencies
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable?shallow=1";

    # Placeholders
    flake-utils.follows = "yazi/flake-utils";
    gitignore.follows = "hyprland/pre-commit-hooks/gitignore";

    # System configuration
    systems.url = "github:nix-systems/x86_64-linux?shallow=1";
    flake-parts = {
      url = "github:hercules-ci/flake-parts?shallow=1";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable?shallow=1";
      inputs = {
        rust-overlay.follows = "rust-overlay";
        home-manager.follows = "home-manager";
        jovian.follows = "";
      };
    };
    stylix = {
      url = "github:nix-community/stylix/master?shallow=1";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        systems.follows = "systems";
        # nur.follows = "nur";
      };
    };

    # Window manager and related
    hyprland = {
      url = "github:hyprwm/Hyprland?shallow=1";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        pre-commit-hooks.inputs.flake-compat.follows = "";
        systems.follows = "systems";
      };
    };

    # Development tools - Editors and LSP
    nvf = {
      url = "github:notashelf/nvf?shallow=1";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        flake-parts.follows = "flake-parts";
      };
    };
    zls = {
      url = "github:zigtools/zls?shallow=1";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        zig-overlay.follows = "zig";
        gitignore.follows = "gitignore";
      };
    };

    # Development tools - Language toolchains
    rust-overlay = {
      url = "github:oxalica/rust-overlay?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zig = {
      #block untill https://github.com/zigtools/zls/pull/2457 merged
      #url = "github:silversquirl/zig-flake?shallow=1";
      url = "github:mitchellh/zig-overlay/ae1fddbb9bce72065b67331efff583651bd1b123?shallow=1";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "";
        flake-utils.follows = "flake-utils";
      };
    };

    # Applications
    yazi = {
      url = "github:sxyazi/yazi?shallow=1";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        rust-overlay.follows = "rust-overlay";
      };
    };
    ghostty = {
      url = "github:ghostty-org/ghostty?shallow=1";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        zig.follows = "zig";
        zon2nix.follows = "";
        flake-compat.follows = "";
        flake-utils.follows = "flake-utils";
      };
    };
    nix-gaming = {
      url = "github:fufexan/nix-gaming?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };

    # Secrets management
    agenix = {
      url = "github:ryantm/agenix?shallow=1";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
        systems.follows = "systems";
        darwin.follows = "";
      };
    };
    ragenix = {
      url = "github:yaxitech/ragenix?shallow=1";
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
      url = "github:nix-community/nix-index-database?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix?shallow=1";
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
    # url = "github:nix-community/NUR?shallow=1";
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
      flake_dir = "/home/${username}/nixos-config";
      pkgs = nixpkgs.legacyPackages.${system}.extend (
        final: prev:
        (nixpkgs.lib.composeManyExtensions [
          rust-overlay.overlays.default
          zig.overlays.default
        ] final prev)
      );
    in
    {
      templates.treefmt = {
        path = ./templates/treefmt;
        description = "Minimal treefmt-nix";
      };
      formatter.${pkgs.stdenv.hostPlatform.system} = treefmt-nix.lib.mkWrapper pkgs ./treefmt.nix;
      checks.${pkgs.stdenv.hostPlatform.system} = {
        treefmt = self.formatter.${pkgs.stdenv.hostPlatform.system};
      };
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit
              inputs
              username
              host
              flake_dir
              ;
            profile = "amd";
          };
          modules = [
            ./profiles/amd
          ];
        };
      };
      devShells.${pkgs.stdenv.hostPlatform.system} = {
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
              packageOverrides = _final: prev: {
                blas = prev.toPythonModule (prev.pkgs.blas.override { blasProvider = prev.pkgs.amd-blis; });
                lapack = prev.toPythonModule (
                  prev.pkgs.lapack.override { lapackProvider = prev.pkgs.amd-libflame; }
                );
              };
            })
          ];
          shellHook = ''export LD_LIBRARY_PATH=$NIX_LD_LIBRARY_PATH:$LD_LIBRARY_PATH'';
        };
        rust = pkgs.mkShell.override { stdenv = pkgs.clangStdenv; } {
          buildInputs = with pkgs; [
            (rustlings.overrideAttrs {
              extraRustcOpts = "-C target-cpu=znver4 -C lto -C link-arg=-fuse-ld=lld -C codegen-units=1 -C target-feature=+avx512f,+avx512dq,+avx512cd,+avx512bw,+avx512vl";
              postFixup = '''';
            })
          ];
          nativeBuildInputs = [
            pkgs.rust-bin.stable.latest.default
            #.override {
            #  extensions = [
            #   "llvm-tools"
            #   "rust-src"
            # ];
            #}
          ];
        };
      };
    };
}
