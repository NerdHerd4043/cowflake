{ config, lib, ... }:

let
  cfg = config.herd.plymouth;
  inherit (lib)
    mkEnableOption
    mkIf
    ;
in
{
  options.herd.plymouth = {
    enable = mkEnableOption "herd plymouth";
  };

  config = mkIf cfg.enable {
    boot = {
      plymouth = {
        enable = true;
        theme = "bgrt";
      };
      consoleLogLevel = 0;
      initrd.verbose = false;
      kernelParams = [
        "quiet"
        "splash"
        "boot.shell_on_fail"
        "udev.log_priority=3"
        "rd.systemd.show_status=auto"
      ];

      # Hides the boot menu, but the boot menu can still be accessed by
      # holding down the spacebar.
      loader.timeout = 0;
    };
  };
}
