{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    { nixpkgs, ... }:
    let
      eachSystem =
        f:
        nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed (
          system:
          f {
            pkgs = import nixpkgs {
              inherit system;
            };
          }
        );
    in
    {
      devShells = eachSystem (
        { pkgs }:
        {
          default = pkgs.mkShell {
            packages = [
              (pkgs.haskellPackages.ghcWithPackages (hs: with hs; [
                text
                sqlite-simple
              ]))
              pkgs.pkg-config
              pkgs.sqlite
            ];
          };
        }
      );
    };
}
