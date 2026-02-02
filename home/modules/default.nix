{ config, lib, ... }:
let
  cfg = config.herd;
  inherit (lib)
    mkEnableOption
    mkIf
    mkOverride
    ;

  /**
    This creates a default "true" value that can be overridden by `lib.mkDefault true`, as:
    ```nix
    lib.mkDefault = lib.mkOverride 1000;
    lib.mkForce = lib.mkOverride 50;
    ```
  */
  mkTrue = mkOverride 1100 true;
in
{
  imports = [
    ./packages.nix
    ./standalone.nix
    ./vscode.nix
  ];

  options.herd.defaults = mkEnableOption "herd defaults" // {
    default = true;
  };

  config = {
    herd = mkIf cfg.defaults {
      vscode.enable = mkTrue;
      packages.enable = mkTrue;
    };

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
  };
}
