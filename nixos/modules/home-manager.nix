{
  inputs,
  self,
  config,
  lib,
  ...
}:
let
  cfg = config.herd.home-manager;
  inherit (lib)
    mkEnableOption
    mkIf
    ;
in
{
  imports = [
    inputs.home-manager.nixosModules.default
  ];

  options.herd.home-manager = {
    enable = mkEnableOption "home-manager module";
  };

  config = mkIf cfg.enable {
    home-manager = {
      extraSpecialArgs = {
        inherit inputs self;
      };
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "backup";
      sharedModules = [
        inputs.agenix.homeManagerModules.default
      ];
    };
  };
}
