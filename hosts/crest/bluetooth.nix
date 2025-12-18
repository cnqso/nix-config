{ pkgs, ... }:

{
  # Core Bluetooth stack (BlueZ)
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # GUI tray + pairing agent (handy on desktops). Safe to remove if you prefer CLI-only.
  services.blueman.enable = true;

  environment.systemPackages = with pkgs; [
    bluez
    bluez-tools
  ];

  # For Bluetooth audio (A2DP headsets, etc). If you already configured PipeWire elsewhere,
  # keep only one copy of this block.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };
  hardware.pulseaudio.enable = false;
}

