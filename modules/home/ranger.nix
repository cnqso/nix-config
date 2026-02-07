{ pkgs, lib, ... }:

{
  home-manager.users.cnqso = { config, ... }: {
    # Ranger config files
    xdg.configFile."ranger/rc.conf".source = ../../configs/ranger/rc.conf;
    xdg.configFile."ranger/rifle.conf".source = ../../configs/ranger/rifle.conf;
    xdg.configFile."ranger/commands.py".source = ../../configs/ranger/commands.py;
    xdg.configFile."ranger/commands_full.py".source = ../../configs/ranger/commands_full.py;
    xdg.configFile."ranger/scope.sh" = {
      source = ../../configs/ranger/scope.sh;
      executable = true;
    };

    # Ranger previews (kitty image protocol + ffmpeg thumbnailer).
    home.packages = with pkgs; [
      ffmpegthumbnailer
      imagemagick
      (symlinkJoin {
        name = "ranger";
        paths = [ ranger ];
        buildInputs = [ makeWrapper ];
        postBuild = ''
          wrapProgram "$out/bin/ranger" \
            --prefix PYTHONPATH : "${python3Packages.pillow}/${python3.sitePackages}"
        '';
      })
    ];
  };
}
