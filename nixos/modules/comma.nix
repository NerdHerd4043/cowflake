{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.herd.comma;
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
in
{

  imports = [
    inputs.nix-index-database.nixosModules.default
  ];

  options.herd.comma = {
    enable = mkEnableOption "herd comma";
    nix-index-package = mkOption {
      type = types.package;
      default =
        inputs.nix-index-database.packages.${pkgs.stdenv.hostPlatform.system}.nix-index-with-small-db;
    };
  };

  config = mkIf cfg.enable {
    programs.nix-index-database.comma.enable = true;
    programs.nix-index.package = cfg.nix-index-package;
  };
}
