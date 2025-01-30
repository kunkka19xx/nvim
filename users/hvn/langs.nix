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
    golangci-lint

    # Rust
    # rustup # Rust version manager
    cargo # Rust package manager
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
    # GOPATH = "/Users/haovanngyuen/go";
    # GOROOT = "${pkgs.go}/go";
    #
    # Node.js
    NODE_PATH = "~/.npm-global/lib/node_modules";
    # Need following command before installing npm pkgs, TODO: research
    #        npm set prefix ~/.npm-global

    # Rust
    CARGO_HOME = "~/.cargo";
  };

  /* home.activation = {
    initRust = lib.mkAfter ''
    if ! command -v rustup &> /dev/null; then
    echo "Installing Rust via rustup..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    else
    echo "Rust is already installed"
    fi
    '';
    }; */

}
