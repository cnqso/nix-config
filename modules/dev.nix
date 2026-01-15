{ pkgs, ... }:

{
  # Docker for Immich
  virtualisation.docker.enable = true;

  # nix-ld so your Go binaries "just work"
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    zlib
    fuse3
    openssl
    # Add other libs if your Go server links to them (e.g., sqlite)
  ];

  # Python for data analysis
  environment.systemPackages = with pkgs; [
    (python3.withPackages (ps: with ps; [
      pandas
      plotly
      requests
      numpy
    ]))
  ];
}
