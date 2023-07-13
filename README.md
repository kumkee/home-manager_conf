# Nix with WSL Alpine

## Install Alpine
1. Download latest zip from https://github.com/yuk7/AlpineWSL.
2. Extract `Alpine.zip` into `D:\backup\Alpine`
3. On a Powershell, `wsl --import alpine .\WSL\alpine\ .\backup\Alpine\rootfs.tar.gz --version 2'

## Install `home-manager`
Using this [blog post](https://cbailey.co.uk/posts/a_minimal_nix_development_environment_on_wsl).
