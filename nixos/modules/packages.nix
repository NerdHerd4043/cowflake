{
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
    ;
in
{
  options.herd.packages = {
    enable = mkEnableOption "common herd packages";
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
  };
}
