{
  inputs = {};
  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;

        overlays = [
          (final: prev: {
            mono = final.callPackage "${nixpkgs.outPath}/pkgs/development/compilers/mono/generic.nix" {
              inherit (final) Foundation libobjc;
              version = "6.8.0.105";
              srcArchiveSuffix = "tar.xz";
              sha256 = "sha256-V4eZxEw8hqnrXa9t7GxgokNBlA/TdjcZVtSkbPhhIXg=";
              enableParallelBuilding = true;
            };
          })
        ];
      };
    in {

      packages.${system} = rec {

        default = xnaToFna;

        xnaToFna = pkgs.buildDotnetPackage rec {
          pname = "XnaToFna";
          baseName = pname;
          version = "18.05.1";
          src = ./.;
          projectFile = [ "XnaToFna.sln" ];
          propagatedBuildInputs = [];
          buildInputs = [];
          nativeBuildInputs = [ pkgs.pkg-config ];
        };

        vscode-csharp = pkgs.vscode-with-extensions.override {
          vscodeExtensions = [ pkgs.vscode-extensions.ms-dotnettools.csharp ];
          # buildInputs = prev.buildInputs ++ [ pkgs.omnisharp-roslyn ];
        };

      };

    };
}
