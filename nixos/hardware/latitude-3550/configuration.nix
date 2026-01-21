{
  inputs,
  self,
  pkgs,
  ...
}:
{
  imports = [
    inputs.disko.nixosModules.disko
    ./disk-configuration.nix
    ./hardware-configuration.nix
  ];

  herd = {
    desktop.enable = true;
    home-manager.enable = true;
    packages.unfree.predicate = [
      "intel-ocl"
      "code"
      "vscode"
    ];
  };

  users = {
    mutableUsers = false;
    users = {
      nerdherd4043 = {
        isNormalUser = true;
        extraGroups = [
          "networkmanager"
          "video"
          "wheel"
        ];
        hashedPassword = "$y$j9T$BN5fvfmYxHqJVGoHUmle.0$fxCfLjaVXeRYRBB1Zju5OEQN.tNic88jyLq.wYbaqZD";
        openssh.authorizedKeys.keys = [ ];
      };
    };
  };

  # Home Manager Config:
  home-manager.users = {
    nerdherd4043 = import "${self}/home/hosts/nerdherd4043.nix";
  };

  # For i3-4005U:
  hardware.intel-gpu-tools.enable = true;
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-vaapi-driver
      intel-ocl
    ];
  };
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "i965";
    VDPAU_DRIVER = "va_gl";
  };
}
