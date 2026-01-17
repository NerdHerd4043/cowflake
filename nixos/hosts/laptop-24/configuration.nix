{ ... }:
{
  imports = [
    ./disk-configuration.nix
    # ./hardware-configuration.nix
  ];

  herd = {
    desktop.enable = true;
  };

  networking.hostName = "laptop-24";

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
