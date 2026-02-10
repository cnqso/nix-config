{ config, pkgs, lib, ... }:

{
  # ============================================================================
  # Server Configuration
  # All self-hosted services and servers live here
  # ============================================================================

  # Ensure Docker is available (already enabled in dev.nix)

  # Allow Plex to read media on /mnt/sdb (mounted with gid=users).
  users.users.plex.extraGroups = [ "users" ];
  
  # Create server data directories with proper permissions
  systemd.tmpfiles.rules = [
    "d /home/cnqso/immich 0755 cnqso users -"
    "d /home/cnqso/code 0755 cnqso users -"
    "d /home/cnqso/code/server 0755 cnqso users -"
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


  systemd.services.cnqso-web = {
    description = "Cnqso Personal Website Server (Native Go)";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    
    serviceConfig = {
      Type = "simple";
      WorkingDirectory = "/home/cnqso/code/server/go";
      ExecStart = "${pkgs.go}/bin/go run .";
      Restart = "on-failure";
      RestartSec = "5s";
      User = "cnqso";
      Group = "users";
      
      # Environment variables
      Environment = [
        "PATH=${pkgs.go}/bin:${pkgs.nodejs}/bin:${pkgs.gcc}/bin:/run/current-system/sw/bin"
        "TZ=America/Detroit"
      ];
    };
  };

  # ============================================================================
  # Caddy Reverse Proxy (HTTPS on port 443)
  # ============================================================================
  
  services.caddy = {
    enable = true;
    virtualHosts."cnqso.com" = {
      extraConfig = ''
        reverse_proxy localhost:1738
      '';
    };
  };

  # ============================================================================
  # Plex Media Server
  # ============================================================================

  services.plex = {
    enable = true;
    openFirewall = true; # TCP/32400
  };

  # ============================================================================
  # Firewall Rules
  # ============================================================================
  
  networking.firewall.allowedTCPPorts = [
    80    # HTTP (for Let's Encrypt challenges & redirect to HTTPS)
    443   # HTTPS (Caddy reverse proxy)
    2283  # Immich web interface
    32400 # Plex
  ];
}
