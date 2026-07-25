{ nixpkgs }:
let
  inherit (nixpkgs) lib;

  shells = {
    rustc-dev =
      pkgs:
      pkgs.mkShell {
        packages = with pkgs; [
          clang
          cmake
          ninja
          python3
          git
          curl
          pkg-config
          openssl
          zlib
          libxml2
          ncurses
          libffi
          lld
          stdenv.cc.cc.lib
          rustup
          curl
        ];
        LD_LIBRARY_PATH =
          with pkgs;
          pkgs.lib.makeLibraryPath [
            stdenv.cc.cc.lib
            openssl
            zlib
            libxml2
            ncurses
            libffi
            curl
          ];
      };
  };
in
lib.genAttrs lib.systems.flakeExposed (
  system: lib.mapAttrs (_name: shellFor: shellFor nixpkgs.legacyPackages.${system}) shells
)
