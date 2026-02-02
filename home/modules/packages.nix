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
    enable = mkEnableOption "herd packages";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      bambu-studio
      wpilib.roborioteamnumbersetter
    ];
  };
}
