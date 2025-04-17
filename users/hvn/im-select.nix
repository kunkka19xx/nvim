{ stdenv, fetchurl, lib, pkgs, ... }:

stdenv.mkDerivation {
  pname = "im-select";
  version = "latest";

  src = fetchurl {
    url = "https://github.com/daipeihust/im-select/archive/refs/tags/1.0.1.tar.gz";
    sha256 = "sha256-4kzdt44Luxs/nbPxVa6pCDgQCMwCEHnU1n+6okz6/L8=";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/im-select
    chmod +x $out/bin/im-select
  '';

  meta = {
    description = "Switch Input Method from command line on macOS";
    homepage = "https://github.com/daipeihust/im-select";
    license = lib.licenses.mit;
    platforms = [ "x86_64-darwin" "aarch64-darwin" ];
  };
}
