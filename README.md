# Nix with WSL Alpine

## Install Alpine
1. Download latest zip from https://github.com/yuk7/AlpineWSL.
2. Extract `Alpine.zip` into `D:\backup\Alpine`
3. On a Powershell, `wsl --import alpine .\WSL\alpine\ .\backup\Alpine\rootfs.tar.gz --version 2`


## Clone `.conf`

### Generate ssh key
`nix-shell -p openssh --run 'ssh-keygen -t ed25519'`
### Cloning

`nix-shell -p openssh git --run 'git clone git@github.com:kumkee/.config.git'`
`nix-shell -p git openssh --run 'git submodule update --init --recursive'`

### Soft links
`.config/softlinks.sh`


## Install `home-manager`
Using this [blog post](https://cbailey.co.uk/posts/a_minimal_nix_development_environment_on_wsl).
