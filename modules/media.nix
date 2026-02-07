{ pkgs, ... }:

{
  # Audio (PipeWire)
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;  # PulseAudio compatibility
    alsa.enable = true;
    alsa.support32Bit = true;  # For 32-bit games/apps
  };

  # Disable legacy PulseAudio
  services.pulseaudio.enable = false;

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.blueman.enable = true;

  environment.systemPackages = with pkgs; [
    bluez
    bluez-tools
  ];
}
