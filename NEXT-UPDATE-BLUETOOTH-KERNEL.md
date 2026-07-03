# Bluetooth Kernel Rollback Playbook

The Framework laptop currently uses `pkgs.linuxPackages_latest` from the main
`nixpkgs` input — no rollback active.

If a future flake update breaks Bluetooth on this laptop, apply a temporary
kernel pin using the pattern below.

## When to reach for this

Symptom: after `sudo nixos-rebuild switch --flake .#framework`, Bluetooth will
not power on. Check `systemctl status bluetooth` and `bluetoothctl power on`.

Historical known-good pin: Linux `7.0.0`, provided by nixpkgs commit
`4bd9165a9165d7b5e33ae57f3eecbcb28fb231c9`. Test the current kernel first —
the regression may already be fixed upstream.

## Applying a rollback

1. Add a pinned nixpkgs input to `flake.nix`:

   ```nix
   bluetooth-kernel-rollback-nixpkgs.url =
     "github:nixos/nixpkgs/<commit-of-known-good-kernel>";
   ```

2. In `modules/hosts/framework/configuration.nix`, thread `inputs` into the
   outer function args and override `boot.kernelPackages`:

   ```nix
   { self, inputs, ... }: {
     flake.nixosModules.framework-configuration = { pkgs, lib, config, ... }:
       let
         rollbackPkgs = import inputs.bluetooth-kernel-rollback-nixpkgs {
           inherit (pkgs.stdenv.hostPlatform) system;
           config.allowUnfree = true;
         };
       in {
         # …
         boot.kernelPackages = rollbackPkgs.linuxPackages_latest;
       };
   }
   ```

3. Test before switching:

   ```bash
   sudo nixos-rebuild test --flake .#framework
   ```

4. Verify Bluetooth powers on and device discovery works.
5. If it works, run `sudo nixos-rebuild switch --flake .#framework`.

## Removing a rollback (once the current kernel works again)

1. Delete the input line from `flake.nix`.
2. Delete the `let` binding, the `inputs` outer arg, and the
   `boot.kernelPackages` line from `configuration.nix`.
3. Run `sudo nixos-rebuild switch --flake .#framework` — the lockfile
   reconciles automatically.

## Debugging commands

- `systemctl status bluetooth`
- `journalctl -b -u bluetooth`
- `journalctl -b | rg -i 'bluetooth|btusb|firmware'`
