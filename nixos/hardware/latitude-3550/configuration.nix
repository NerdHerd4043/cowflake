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
    boot.grub.enable = false;
    boot.systemd.enable = true;
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
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJIjvv25XXwfztlBSEnQRT6f/27wmc/6R+rMRnUaqneY"
        ];
      };
    };
  };

  # Home Manager Config:
  home-manager.users = {
    nerdherd4043 = import "${self}/home/hosts/nerdherd4043.nix";
  };

  services.displayManager.autoLogin = {
    enable = true;
    user = "nerdherd4043";
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

  services.libinput.touchpad.naturalScrolling = true;
}
