{ config, pkgs, lib, ... }:

{
  # ============================================================================
  # Server Configuration
  # All self-hosted services and servers live here
  # ============================================================================

  # Ensure Docker is available (already enabled in dev.nix)
  
  # Create server data directories with proper permissions
  systemd.tmpfiles.rules = [
    "d /home/cnqso/immich 0755 cnqso users -"
  ];

  # ============================================================================
  # Immich - Photo Management Server
  # ============================================================================
  
  systemd.services.immich = {
    description = "Immich Photo Management Server";
    after = [ "docker.service" "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      WorkingDirectory = "/home/cnqso/immich";
      ExecStart = "${pkgs.docker}/bin/docker compose up -d";
      ExecStop = "${pkgs.docker}/bin/docker compose down";
      User = "cnqso";
      Group = "users";
    };

    path = [ pkgs.docker ];
  };

  # ============================================================================
  # Firewall Rules
  # ============================================================================
  
  networking.firewall.allowedTCPPorts = [
    2283  # Immich web interface
  ];
}
