# build go 1.24.0 from source
{ pkgs, lib, ... }:

let
  go_from_source = pkgs.stdenv.mkDerivation rec {
    pname = "go";
    version = "1.24.0";

    src = pkgs.fetchFromGitHub {
      owner = "golang";
      repo = "go";
      rev = "go1.24.0";
      sha256 = "11hsxrchk37qwjwscrr8b8vnlg6vlgfizbxy8bayxpqnpjvifig5";
    };

    nativeBuildInputs = [ pkgs.go_1_23 ]; # requires from 1.22 to build 1.24
    buildInputs = [ pkgs.gcc pkgs.bash ];

    buildPhase = ''
      export GOROOT=$(pwd)
      export GOBIN=$GOROOT/bin
      export PATH=$GOROOT/bin:$PATH

      export GOCACHE=$TMPDIR/go-build
      export GOTMPDIR=$TMPDIR/go-build
      mkdir -p $GOCACHE $GOTMPDIR

      echo "Building Go 1.24.0..."
      cd src
      ./make.bash
      cd ..
      echo "Go build completed!"
    '';


    installPhase = ''
      mkdir -p $out
      cp -r . $out/

      # Just in case, print what is in bin
      echo ">>> Installed bin:"
      ls -l $out/bin
    '';


    meta = with lib; {
      description = "Go programming language (1.24.0)";
      license = licenses.bsd3;
    };
  };

in
{
  home.packages = with pkgs; [
    go_from_source
  ];

  home.sessionVariables = {
    GOROOT = "${go_from_source}";
    GOPATH = "/Users/haovanngyuen/go";
    GOBIN = "/Users/haovanngyuen/go/bin";
    PATH = "${go_from_source}/bin:$PATH";
  };
}
