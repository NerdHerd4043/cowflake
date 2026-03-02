{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.herd.vscode;
  inherit (lib)
    mkEnableOption
    mkIf
    ;

  java' = pkgs.temurin-bin-17;
in
{
  options.herd.vscode = {
    enable = mkEnableOption "herd vscode";
  };

  config = mkIf cfg.enable {
    # Install and configure Visual Studio Code
    programs.vscode = {
      enable = true;
      # Add extra packages that VS Code might need
      package =
        (pkgs.vscode.fhsWithPackages (
          ps: with ps; [
            # rustup
            nil
            nixfmt
            openssl.dev
            pkg-config
            java'
            zlib
            wpilib.wpilib-utility
          ]
        )).overrideAttrs
          (oa: {
            extraBwrapArgs = (oa.extraBwrapArgs or [ ]) ++ [ "--setenv JAVA_HOME ${java'}" ];
          });

      # Define some extensions to install by default
      profiles.default = {
        extensions = with pkgs.vscode-extensions; [
          jnoortheen.nix-ide # Nix syntax highlighting and formatting
          redhat.java # Java support
          vscjava.vscode-java-debug # Java support
          vscjava.vscode-java-dependency # Java support
          vscodevim.vim # Vim keybindings
          wpilibsuite.vscode-wpilib # wpilib
          yzhang.markdown-all-in-one # Markdown?
        ];
        userSettings = {
          "[nix]"."editor.tabSize" = 2;
          "chat.disableAIFeatures" = true;
          "update.mode" = "none";
        };
      };
    };

    home.packages = with pkgs; [
      wpilib.wpilib-utility
    ];
  };
}
