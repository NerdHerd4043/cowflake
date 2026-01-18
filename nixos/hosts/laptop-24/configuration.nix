{ pkgs, ... }:
{
  imports = [
    ./disk-configuration.nix
    # ./hardware-configuration.nix
  ];

  herd = {
    desktop.enable = true;
  };

  networking.hostName = "laptop-24";

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

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
