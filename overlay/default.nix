{ inputs, ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      qt6Packages = prev.qt6Packages.overrideScope (
        _final': prev': {
          # HACK: no more qt5
          fcitx5-with-addons = prev'.fcitx5-with-addons.override { libsForQt5.fcitx5-qt = null; };

          # HACK: no more kde stuff
          fcitx5-configtool = prev'.fcitx5-configtool.override { kcmSupport = false; };

          # HACK: no more qtwebengine, opencc
          fcitx5-chinese-addons =
            (prev'.fcitx5-chinese-addons.override {
              curl = null;
              opencc = null;
              qtwebengine = null;
            }).overrideAttrs
              (oldAttrs: {
                buildInputs = oldAttrs.buildInputs ++ [
                  prev.gettext
                  prev'.qtbase
                ];
                cmakeFlags = oldAttrs.cmakeFlags ++ [
                  (prev.lib.cmakeBool "ENABLE_BROWSER" false)
                  (prev.lib.cmakeBool "ENABLE_CLOUDPINYIN" false)
                  (prev.lib.cmakeBool "ENABLE_OPENCC" false)
                ];
              });
        }
      );

      # HACK: no more gtk2
      gnome-themes-extra = (prev.gnome-themes-extra.override { gtk2 = null; }).overrideAttrs {
        configureFlags = [ "--disable-gtk2-engine" ];
      };

      # HACK:
      xdg-desktop-portal-gtk =
        (prev.xdg-desktop-portal-gtk.override {
          gnome-desktop = null;
          gsettings-desktop-schemas = null;
        }).overrideAttrs
          {
            mesonFlags = [ (prev.lib.mesonEnable "wallpaper" false) ];
          };
      bat-extras = prev.bat-extras.overrideScope (
        _finalBatExtras: prevBatExtras: {
          # Override the core package
          core = prevBatExtras.core.overrideAttrs (oldAttrs: {
            version = "2024.08.24-unstable-2025-02-22";

            src = final.fetchFromGitHub {
              owner = "eth-p";
              repo = "bat-extras";
              rev = "3860f0f1481f1d0e117392030f55ef19cc018ee4";
              hash = "sha256-9TEq/LzE1Pty1Z3WFWR/TaNNKPp2LGBr0jzGBkOEGQo=";
              fetchSubmodules = true;
            };

            patches = [
              # Remove the old disable-theme-tests.patch
            ];

            nativeCheckInputs = oldAttrs.nativeCheckInputs ++ [ final.nushell ];

            passthru = oldAttrs.passthru // {
              updateScript = final.nix-update-script { extraArgs = [ "--version=branch" ]; };
            };
          });

          # Override batpipe
          batpipe = prevBatExtras.batpipe.overrideAttrs (oldAttrs: {
            buildInputs = (oldAttrs.buildInputs or [ ]) ++ [ final.procps ];

            patches = [
              ./batpipe-skip-outdated-test.patch
            ]
            ++ final.lib.optional final.stdenv.hostPlatform.isDarwin ./batpipe-skip-detection-tests.patch;
          });

          # Override batgrep to disable tests
          batgrep = prevBatExtras.batgrep.overrideAttrs (oldAttrs: {
            doCheck = false;
          });

          # Override buildBatExtrasPkg function
          buildBatExtrasPkg =
            args:
            prevBatExtras.buildBatExtrasPkg (
              args
              // {
                nativeCheckInputs = (args.nativeCheckInputs or [ ]) ++ [ final.nushell ];
              }
            );
        }
      );
    })
    inputs.rust-overlay.overlays.default
    inputs.ghostty.overlays.default
    inputs.zig.overlays.default
    inputs.yazi.overlays.default
  ];
}
