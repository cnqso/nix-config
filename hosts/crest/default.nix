{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ../../modules/common.nix
    ../../modules/desktop.nix
    ../../modules/media.nix
    ../../modules/dev.nix
    ../../modules/stylix.nix
    ../../modules/waybar.nix
    ../../modules/server.nix
    ../../modules/home
  ];

  # Host-specific hardware configuration
  hardware.enableRedistributableFirmware = true;

  # NTFS support for external drives
  boot.supportedFilesystems = [ "ntfs" ];

  # External drive mounts
  fileSystems."/mnt/sda" = {
    device = "/dev/disk/by-uuid/04E623B5E623A5C0";
    fsType = "ntfs-3g";
    options = [ "rw" "uid=1000" "gid=100" "dmask=022" "fmask=133" ];
  };

  fileSystems."/mnt/sdb" = {
    device = "/dev/disk/by-uuid/74C62BC6C62B8806";
    fsType = "ntfs-3g";
    options = [ "rw" "uid=1000" "gid=100" "dmask=022" "fmask=133" ];
  };

  # At one point this was helpful for RTL8125 ethernet
  # boot.blacklistedKernelModules = [ "r8169" ];
  # boot.extraModulePackages = [ config.boot.kernelPackages.r8125 ];
  # boot.kernelModules = [ "r8125" ];

  # Host identification and networking
  networking.hostName = "crest";

  # Force specific DNS servers (bypassing router DNS)
  networking.networkmanager.insertNameservers = [ "1.1.1.1" "8.8.8.8" ];

  # NVIDIA GPU configuration
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.graphics.enable = true;
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # NVIDIA-specific environment variables
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

  # Host-specific home-manager configuration (dual monitor setup)
  home-manager.users.cnqso = {
    programs.niri.settings = {
      outputs = {
        "HDMI-A-2" = {
          mode = {
            width = 2560;
            height = 1440;
            refresh = 59.951;
          };
          position = {
            x = 0;
            y = 0;
          };
        };
        "DP-1" = {
          mode = {
            width = 2560;
            height = 1440;
            refresh = 143.912;
          };
          position = {
            x = 2560;
            y = 0;
          };
        };
      };
    };
  };

  system.stateVersion = "24.11";
}
