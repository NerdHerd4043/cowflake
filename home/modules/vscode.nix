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
in
{
  options.herd.vscode = {
    enable = mkEnableOption "herd vscode";
  };

  config = mkIf cfg.enable {
    # Install and configure Visual Studio Code
    programs.vscode = {
      enable = true;
      # Define some extensions to install by default
      profiles.default = {
        extensions = with pkgs.vscode-extensions; [
          # Vim keybindings
          vscodevim.vim
          # Markdown?
          yzhang.markdown-all-in-one
          # Nix syntax highlighting and formatting
          jnoortheen.nix-ide
        ];
      };
      # Add extra packages that VS Code might need
      package = pkgs.vscode.fhsWithPackages (
        ps: with ps; [
          # rustup
          zlib
          openssl.dev
          pkg-config
          nil
          nixfmt
        ]
      );
    };
  };
}
