# Nix installation on Windows Subsystem for Linux

## Install `Alpine` or `Debian`

- Alpine
  1. Download latest zip from https://github.com/yuk7/AlpineWSL.
  2. Extract `Alpine.zip` into `D:\backup\Alpine`
  3. On a PowerShell,
     `wsl --import alpine .\WSL\alpine\ .\backup\Alpine\rootfs.tar.gz --version 2`
- Debian
  - Update `apt` and install `xz-utils`, `systemd-timesyncd`, `zsh`, `curl`.
  - Windows Subsystem for Linux (WSL) time keeping problems
    [8204](https://github.com/microsoft/WSL/issues/8204) and
    [5324](https://github.com/microsoft/WSL/issues/5324) can be solved with
    [this answer on `stackoverflow`](https://stackoverflow.com/questions/65086856/wsl2-clock-is-out-of-sync-with-windows).
    > Windows: Open PowerShell as Administrator
    ```shell
    schtasks /create /tn WSLClockSync /tr "wsl.exe sudo hwclock -s" /sc onevent /ec system /mo "*[System[Provider[@Name='Microsoft-Windows-Kernel-General'] and (EventID=1)]]"
    Set-ScheduledTask WSLClockSync -Settings (New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries)
    ```
    > WSL2: Run `sudo visudo` and add `hwclock` to `sudoers` to skip password prompt
    ```bash
    # bottom of my file looks like this
    ...
    ...
    #includedir /etc/sudoers.d
    <username> ALL=(ALL) NOPASSWD:/usr/sbin/hwclock
    ```
    and
    `sudo apt install systemd-timesyncd` then
    > `sudo systemctl edit systemd-timesyncd` with the following contents:
    > 
    > ```
    > [Unit]
    > ConditionVirtualization=
    > ConditionVirtualization=wsl

## Install `NixOS`

- Install `xz-utils` and `curl`
- Install NixOS using
  [official WSL guide for multi-user](https://nixos.org/download.html#nix-install-windows).

## Clone `.conf`

### Generate ssh key

Generate ssh key pair by running

```shell
nix-shell -p openssh --run 'ssh-keygen -t ed25519'
```

Then add the new public key in the GitHub profile.

### Cloning

- `nix-shell -p openssh git --run 'git clone git@github.com:kumkee/.config.git'`
- `nix-shell -p git openssh --run 'git submodule update --init --recursive'`

## Install `home-manager`

- Backup ssh public and private keys somewhere different from `.ssh/` as this
  location will be overwritten by `home-manager`.
- Install
  [home-manager](https://nix-community.github.io/home-manager/index.html#ch-installation)
- Have a look at this
  [blog post](https://cbailey.co.uk/posts/a_minimal_nix_development_environment_on_wsl).
- Add the public key in `authorized_keys` of the `ssh` submodule and run
  `home-manager switch` to update the configuration.
