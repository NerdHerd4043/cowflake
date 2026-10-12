let
  # Systems
  poppy = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILhJ0QdHoDe0agOMZwpF6uEn3LwEUeYFGAAh50fptosL";
  caveserver = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHYPeJmSKp9WHnu1u+lB/s7v6uB6fN6lbaDHPHQePfKR";

  # Users (for acccess)
  nullcube = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ8qUgVoBKq5DdokVxzqQmIbrpkvp09s8o3PjAO3HuLr";
  ravenshade = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE3F17CzT8wMG367EPHGnEamv9pvZ61YXaFdoOuDKHWC";

  keys = [
    # Systems
    poppy
    caveserver

    # Users (for access)
    nullcube
    ravenshade
  ];
in
{
  "attic-env.age".publicKeys = keys;
  "bryan-pass.age".publicKeys = keys;
  "cf-dns-token.age".publicKeys = keys;
  "nullcube-pass.age".publicKeys = keys;
  "ravenshade-pass.age".publicKeys = keys;
  "tailscale-auth-key.age".publicKeys = keys;
}
