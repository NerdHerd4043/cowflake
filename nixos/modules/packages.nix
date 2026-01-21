{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.herd.packages;
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    ;
in
{
  options.herd.packages = {
    enable = mkEnableOption "common herd packages";
    unfree = {
      allow = mkEnableOption "allowing unfree packages";
      predicate = mkOption {
        type = with lib.types; listOf str;
        default = [ ];
        description = ''
          List of package names to be allowed unfree, directly used for
          nixpkgs.config.allowUnfreePredicate

          nixpkgs.config.allowUnfreePredicate doesn't appear to be mergable via
          modules, so we define our own option here to use instead.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      curl
      git
      lazygit
      neovim
      nh
      tmux
      usbutils
    ];

    nixpkgs = {
      overlays = [
        inputs.frc-nix.overlays.default
      ];
      config = {
        allowUnfreePredicate = mkIf (cfg.unfree.predicate != [ ]) (
          pkg: builtins.elem (lib.getName pkg) cfg.unfree.predicate
        );
        allowUnfree = cfg.unfree.allow;
      };
    };
  };
}
