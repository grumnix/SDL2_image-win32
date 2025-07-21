{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-25.05";

    tinycmmc.url = "github:grumbel/tinycmmc";
    tinycmmc.inputs.nixpkgs.follows = "nixpkgs";

    SDL2_image_src.url = "https://www.libsdl.org/projects/SDL_image/release/SDL2_image-devel-2.8.8-mingw.tar.gz";
    SDL2_image_src.flake = false;
  };

    outputs = { self, nixpkgs, tinycmmc, SDL2_image_src }:
    tinycmmc.lib.eachWin32SystemWithPkgs (pkgs:
      {
        packages = rec {
          default = SDL2_image;

          SDL2_image = pkgs.stdenv.mkDerivation rec {
            pname = "SDL2_image";
            version = "2.8.8";

            src = SDL2_image_src;

            installPhase = ''
              mkdir $out
              cp -vr ${pkgs.stdenv.targetPlatform.config}/. $out/
              substituteInPlace $out/lib/pkgconfig/SDL2_image.pc \
                --replace "prefix=/tmp/tardir/SDL2_image-2.8.8/build-mingw/install-${pkgs.stdenv.targetPlatform.config}" \
                          "prefix=$out"
            '';
          };
        };
      }
    );
}
