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

    nativeBuildInputs = [ pkgs.go_1_22 ]; # requires from 1.22 to build 1.24
    buildInputs = [ pkgs.gcc pkgs.bash ];

    buildPhase = ''
      export GOROOT=$(pwd)/go
      export GOBIN=$GOROOT/bin
      export PATH=$GOROOT/bin:$PATH

      export GOCACHE=$TMPDIR/go-build
      export GOTMPDIR=$TMPDIR/go-build
      mkdir -p $GOCACHE $GOTMPDIR

      echo "Building Go 1.24.0..."
      if [ ! -d "src" ]; then
        echo "Error: src directory is missing. Cloning Go source..."
        git clone https://github.com/golang/go.git src
        cd src
        git checkout go1.24.0
      else
        cd src
      fi

      ./make.bash
      echo "Go build completed!"
    '';

    installPhase = ''
      mkdir -p $out/bin
      mkdir -p $out/src
      mkdir -p $out/pkg
      mkdir -p $out/lib
      BIN_DIR="/private/tmp/nix-build-go-1.24.0.drv-0/source/bin"
  
      if [ ! -d $BIN_DIR ]; then
        echo "⚠️ Error: No bin/ directory found after build at $BIN_DIR. Exiting."
        exit 1
      fi
  
      if [ "$(ls -A $BIN_DIR)" ]; then
        cp -r $BIN_DIR/* $out/bin/
      else
        echo "⚠️ Warning: Bin directory is empty."
      fi

      if [ -d "src" ]; then
        cp -r src $out/
      fi

      if [ -d "pkg" ]; then
        cp -r pkg $out/
      fi

      if [ -d "lib" ]; then
        cp -r lib $out/
      fi

      echo "Go 1.24.0 installed at $out"    '';

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
    GOPATH = "/Users/haovanngyuen/go";
    GOBIN = "${go_from_source}/go/bin";
    GOROOT = "${go_from_source}";
  };
}
