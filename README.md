# Nix installation on Windows Subsystem for Linux

## Install Alpine or Debian

- Alpine
  1. Download latest zip from https://github.com/yuk7/AlpineWSL.
  2. Extract `Alpine.zip` into `D:\backup\Alpine`
  3. On a Powershell,
     `wsl --import alpine .\WSL\alpine\ .\backup\Alpine\rootfs.tar.gz --version 2`
- Debian
  - Update `apt` and install `xz-utils`, `systemd-timesyncd`, `zsh`, `curl`.
  - Windows Subsystem for Linux (WSL) [time keeping problem](https://github.com/microsoft/WSL/issues/8204) can
    be solve with
    [this comment](https://github.com/microsoft/WSL/issues/8204#issuecomment-1338334154) and [this problem](https://github.com/microsoft/WSL/issues/5324) with [this comment](https://github.com/microsoft/WSL/issues/5324#issuecomment-1640769478).

## Install NixOS

- Install `xz-utils` and `curl`
- Install NixOS using
  [official WSL guide for multiuser](https://nixos.org/download.html#nix-install-windows).

## Clone `.conf`

### Generate ssh key

`nix-shell -p openssh --run 'ssh-keygen -t ed25519'`

### Cloning

- `nix-shell -p openssh git --run 'git clone git@github.com:kumkee/.config.git'`
- `nix-shell -p git openssh --run 'git submodule update --init --recursive'`

### Soft links

`.config/softlinks.sh`

## Install `home-manager`

- Install
  [home-manager](https://nix-community.github.io/home-manager/index.html#ch-installation)
- Have a look at this
  [blog post](https://cbailey.co.uk/posts/a_minimal_nix_development_environment_on_wsl).
