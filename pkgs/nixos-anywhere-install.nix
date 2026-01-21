{
  writeShellApplication,
  nixos-anywhere,
  coreutils-full,
  openssh,
  agenix,
  ...
}:
writeShellApplication {
  name = "nixos-anywhere-install";
  runtimeInputs = [
    nixos-anywhere
    coreutils-full
    openssh
    agenix
  ];

  text = # bash
    ''
      if [ -z "$1" ] || [ -z "$2" ]; then echo "var is unset"; exit; fi

      # Create a temporary directory
      temp=$(mktemp -d)

      # Function to cleanup temporary directory on exit
      cleanup() {
        rm -rf "$temp"
      }
      trap cleanup EXIT

      # Create the directory where sshd expects to find the host keys
      install -d -m755 "$temp/etc/ssh"

      ssh-keygen -t ed25519 -f "$temp/etc/ssh/ssh_host_ed25519_key" -N "" -C "root@$1"

      pub=$(cat "$temp/etc/ssh/ssh_host_ed25519_key.pub")

      # Set the correct permissions so sshd will accept the key
      chmod 600 "$temp/etc/ssh/ssh_host_ed25519_key"

      # Manually do re-keying stuff
      echo "The public key is:"
      echo "$pub"

      read -p "Press y to continue" -n 1 -r
      if [[ $REPLY =~ ^[Yy]$ ]]
      then
        # Install NixOS to the host system with our secrets
        nixos-anywhere \
        --extra-files "$temp" \
        --flake .#"$1" \
        --target-host "$2"
      fi
    '';
}
