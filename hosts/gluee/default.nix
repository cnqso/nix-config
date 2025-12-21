{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ../../modules/common.nix
    ../../modules/desktop.nix
    ../../modules/dev.nix
    ../../modules/audio.nix
    ../../modules/bluetooth.nix
    ../../modules/home.nix
    ../../modules/stylix.nix
    ../../modules/waybar.nix
  ];

  networking.hostName = "gluee";

  # MacBookPro12,1 typically needs nonfree firmware for Wi-Fi/Bluetooth.
  hardware.enableRedistributableFirmware = true;

  # Helpful tools for install/debug on laptops.
  environment.systemPackages = with pkgs; [
    pciutils
    usbutils
    iw
  ];

  # If Wi-Fi is Broadcom and doesn't come up automatically, you can pick a
  # specialisation from the boot menu and reboot.
  #
  # - `wifi-broadcom-sta`: uses Broadcom's "wl" (broadcom-sta) driver
  # - `wifi-brcmfmac`: explicitly avoids wl and relies on in-kernel brcmfmac
  specialisation = {
    wifi-broadcom-sta.configuration = {
      boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
      boot.kernelModules = [ "wl" ];
      boot.blacklistedKernelModules = [ "b43" "bcma" "brcmsmac" "brcmfmac" "ssb" ];
    };

    wifi-brcmfmac.configuration = {
      boot.blacklistedKernelModules = [ "wl" ];
    };
  };

  system.stateVersion = "24.11";
}


