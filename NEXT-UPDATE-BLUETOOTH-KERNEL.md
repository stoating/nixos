# Temporary Bluetooth Kernel Rollback

`framework` is temporarily pinned to Linux kernel `7.0.0` because Bluetooth stopped turning on after a flake update.

Current state:

- `modules/hosts/framework/configuration.nix` uses `temporaryBluetoothKernelRollbackPkgs.linuxPackages_latest`
- `flake.nix` adds the `bluetooth-kernel-rollback-nixpkgs` input pinned to nixpkgs commit `4bd9165a9165d7b5e33ae57f3eecbcb28fb231c9`

Why this exists:

- Linux `7.0.8` was known broken for Bluetooth on this laptop
- The default kernel fallback in the updated flake was `6.18.31`, which also could not turn Bluetooth on
- The last known working kernel was `7.0.0`

What to check on the next flake update:

1. Remove the temporary kernel rollback in `modules/hosts/framework/configuration.nix` by setting `boot.kernelPackages = pkgs.linuxPackages_latest;`
2. Remove the `bluetooth-kernel-rollback-nixpkgs` input from `flake.nix`
3. Run `nix flake update`
4. Test with `sudo nixos-rebuild test --flake .#framework`
5. Confirm Bluetooth powers on and device discovery works
6. If it works, run `sudo nixos-rebuild switch --flake .#framework`

If Bluetooth is still broken on the newer kernel, keep the rollback in place and inspect:

- `systemctl status bluetooth`
- `journalctl -b -u bluetooth`
- `journalctl -b | rg -i 'bluetooth|btusb|firmware'`
