{ pkgs, lib, ... }:

let
  python_version = pkgs.python3_13;
in
{
  home.packages = with pkgs; [
    # Python
    python3
    # Node.js
    nodejs_23
    # Golang
    go
    # Rust
    cargo # Rust package manager, neovim pack install
    # Zig
    zig
    # Java
    openjdk17 # Java JDK
  ];

  # Other settings
  home.sessionVariables = {
    # Python
    PYTHONSTARTUP = "${pkgs.python3}/lib/python3.13/site-packages";

    # Golang
    GOPATH = "/home/kunkka07xx/go";
    GOROOT = "${pkgs.go}/lib/go";

    # Node.js
    NODE_PATH = "~/.npm-global/lib/node_modules";

    # Rust
    CARGO_HOME = "~/.cargo";
  };

}
