{ pkgs, ... }:

{
  # Docker for Immich
  virtualisation.docker.enable = true;

  # nix-ld so your Go binaries "just work" + Python C extensions + Playwright browsers
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    stdenv.cc.cc.lib  # libstdc++.so.6 for Python packages like greenlet/playwright
    zlib
    fuse3
    openssl
    
    # Playwright browser dependencies
    glib
    nss
    nspr
    dbus
    atk
    at-spi2-atk
    cups
    libdrm
    gtk3
    pango
    cairo
    expat
    libxcb
    libxkbcommon
    mesa
    alsa-lib
    xorg.libX11
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXrandr
    systemd  # libudev
  ];

  # Go development with hot-reload
  environment.systemPackages = with pkgs; [
    go
    air  # Hot-reload for Go
    nodejs  # For any TypeScript/JS transpilation
    gcc  # For CGO (sqlite)

    # Python development
    uv  # Modern Python package manager (pip replacement)
    python3
    poetry  # Alternative Python package manager
    ruff  # Fast Python linter/formatter
    (python3.withPackages (ps: with ps; [
      # Data science
      pandas
      plotly
      requests
      numpy
      
      # Development tools
      pip
      virtualenv
      ipython
    ]))

    # AI coding assistants
    codex  # OpenAI Codex CLI
  ];
}
