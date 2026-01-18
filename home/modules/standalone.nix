{ config, lib, ... }:

let
  cfg = config.herd.standalone;
  inherit (lib)
    mkEnableOption
    mkIf
    ;
in
{
  options.herd.standalone = {
    enable = mkEnableOption "herd standalone";
  };

  config = mkIf cfg.enable {
    # Allow installing any non-free (not fully open source) packages
    nixpkgs.config.allowUnfree = true;
  };
}
