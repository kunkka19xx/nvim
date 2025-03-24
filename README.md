## 1.Install nix

```shell
curl -L https://nixos.org/nix/install | sh
```

- Check version

```shell
nix --version
```

#### Potential issue:

Nix path is not added into .zshrc properly

-> remove

```shell
sudo rm -rf /nix
sudo rm -f /etc/zshrc.backup-before-nix
```

then reinstall with zsh as main profile

```shell
curl -L https://nixos.org/nix/install | sh -s -- --no-modify-profile
```

_note:_ we need to exit the current shell session, open again to use nix

#### Install neofetch

```shell
nix-shell -p neofetch --run neofetch
```

## 2. Nix-darwin module


### Create nix dir

```shell
mkdir dotfiles/nix
```

```shell
cd dotfiles/nix
mkidr ~/.config/nix
```

_note:_ I go for the 1st criteria, after confirming that nix works in a stable state -> I will migrate it to my dotfiles

## Flake (Package manager)

- There are 2 approaches: Channels, Flake
  (I prefer Flake)

```shell
nix flake init -t nix-darwin
```

- I will use experimental feature flag

```shell
nix flake init -t nix-darwin --extra-experimental-features "nix-command flakes"
```

- after this command, a file flake.nix will be added.
- open and add your setting :)

### Config

[wiki](https://wiki.nixos.org/wiki/Flakes)

- change darwinConfigurations (for macos)
  ex:

```nix
{
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."your-config" = nix-darwin.lib.darwinSystem {
      modules = [ configuration ];
    };

    # Expose the package set, including overlays, for convenience
    darwinPackages = self.darwinConfigurations."your-config".pkgs;
};
```

- Install nix-darwin

```shell
nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake ~/nix#your-config

```

- If there are existing content in zshrc & bashrc, we can backup them first

```shell
➜  nix sudo mv /etc/bashrc /etc/bashrc.bak
➜  nix sudo mv /etc/zshrc /etc/zshrc.bak
➜  nix nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake ~/nix#com-mac
```

- Confirm

```
which darwin-rebuild
/run/current-system/sw/bin/darwin-rebuild #should be like that
```

### Add packages

#### How to

- Add package to this array. Example with neovim

```nix
environment.systemPackages = #systemPackages
    [ pkgs.neovim
    ];
```

- Then run it to rebuild

```shell
darwin-rebuild switch --flake ~/nix#your-config
```

_Note:_ might need to remove neovim from homebrew to use the one from nix

```shell
brew uninstall neovim
```

- Rebuild again then check

```shell
which nvim
/run/current-system/sw/bin/nvim  #should be like that
```

### List packages:

- example with tmux

```shell
nix search nixpkgs tmux
```

- We can use this site as well:
  [nix pkgs](https://search.nixos.org/packages)

#### UI apps

- Ui app maybe cannot appeared in Spotlight search on macos (symlink)
  -> Add config in to configuration input, then add alias script for all Applications
  -> Easier way is using mac-app-util
  [link](https://github.com/hraban/mac-app-util)

## Home manager

- There are some levels of settings : system -> profile -> modules
- To use profile and modular settings, and keep dotfiles setting in their original setting language, use home manager
- We need to install home-manager to use it!!! (declaration is not eough!)
  [home-manager](https://nix-community.github.io/home-manager/)

- apply profile:

```shell
home-manager switch --flake ~/nix#your-config
```

- Note: Home manager adds package as follow

```nix
home.packages = [
    pkgs.vim
    pkgs.git
    pkgs.wezterm
  # more
  ];
```

## NOTE:

- After init git for nix dir, need to add changed files to, if not, we can not rebuild using flake

- Collect garbage

```shell
nix-collect-garbage -d
```

```shell
nix-store --gc
```

- I use darwin, nixos, ... to manage system pkgs (todo)
- home-manager for managing user/profile/prj pkgs

### golang
- Don't know why but it seems like we need to `unset GOROOT` (if not, go root will be pointed to wrong path)

### Get sha256
- example script:
```shell
nix-shell -p nix-prefetch-git --run "nix-prefetch-git --url https://github.com/golang/go --rev go1.24.0"
```
