{ config, pkgs, lib, ... }:

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

  # If your router DNS is flaky, force known-good resolvers (same approach as `crest`).
  networking.networkmanager.insertNameservers = [ "1.1.1.1" "8.8.8.8" ];

  # MacBookPro12,1 typically needs nonfree firmware for Wi-Fi/Bluetooth.
  hardware.enableRedistributableFirmware = true;

  # Robust Wi-Fi defaults (especially helpful on older laptops):
  # - Disable Wi-Fi power saving (common cause of drops)
  # - Prefer wpa_supplicant by default (works with Broadcom "wl"/broadcom-sta)
  networking.networkmanager.wifi = {
    backend = lib.mkDefault "wpa_supplicant";
    powersave = false;
  };

  # Better DNS behavior with NetworkManager.
  services.resolved.enable = true;
  networking.networkmanager.dns = "systemd-resolved";

  # Helpful tools for install/debug on laptops.
  environment.systemPackages = with pkgs; [
    pciutils
    usbutils
    iw
    networkmanagerapplet
    networkmanager_dmenu
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

      networking.networkmanager.wifi.backend = "wpa_supplicant";
    };

    wifi-brcmfmac.configuration = {
      boot.blacklistedKernelModules = [ "wl" ];
    };

    # Optional: try iwd backend (often great with in-kernel drivers, but
    # generally NOT compatible with Broadcom "wl"/broadcom-sta).
    wifi-iwd.configuration = {
      networking.wireless.iwd.enable = true;
      networking.networkmanager.wifi.backend = "iwd";
      networking.networkmanager.wifi.powersave = false;
      boot.blacklistedKernelModules = [ "wl" ];
    };
  };

  # Autostart the Wi-Fi tray applet so you always have a GUI.
  home-manager.users.cnqso.programs.niri.settings.spawn-at-startup = [
    { command = [ "nm-applet" ]; }
  ];

  system.stateVersion = "24.11";
}


