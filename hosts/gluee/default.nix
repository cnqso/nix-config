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

  # Broadcom STA ("wl") is required for Wi‑Fi on this machine.
  # This is marked insecure upstream; we accept the risk on this host because it is
  # the only reliable way to get network connectivity.
  nixpkgs.config.allowInsecurePredicate = pkg: lib.getName pkg == "broadcom-sta";
  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
  boot.kernelModules = [ "wl" ];
  boot.blacklistedKernelModules = [ "b43" "bcma" "brcmsmac" "brcmfmac" "ssb" ];

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

  # Autostart the Wi-Fi tray applet so you always have a GUI.
  home-manager.users.cnqso.programs.niri.settings.spawn-at-startup = lib.mkAfter [
    { command = [ "nm-applet" ]; }
  ];

  system.stateVersion = "24.11";
}


