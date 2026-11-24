# 8BitDo Ultimate 3-mode Xbox on Linux

Enable independent rear paddle assignments in Steam Input over Bluetooth, without custom drivers or controller emulation.

## Status

Verified on Linux Mint Cinnamon with native Steam and Core Keeper: both paddles independently register in Steam's input test and can be assigned in the game's layout editor. The user-local desktop launcher override restored paddle recognition after restarting Steam. The packaged scripts reproduce this approach; they have not been tested on the physical controller. 2.4 GHz independent paddle reporting remains unsolved.

| Transport | ID | Status |
| --- | --- | --- |
| Bluetooth | 2dc8:901b | Working with custom SDL mapping |
| 2.4 GHz / observed wired USB | 2dc8:200f | Independent states not present in captured default reports |

## Installation (native Steam on Mint/Cinnamon)

1. Pair the controller in Bluetooth/mobile mode. Clear any onboard paddle mappings if necessary.
2. Fully exit Steam.
3. From this directory run `bash install.sh` (no sudo).
4. Launch Steam through the desktop application menu. Under Settings > Controller > Test Device Inputs, check L5 and R5. In a game with Steam Input enabled, open Edit Layout > Buttons > Extended Buttons.

The installer creates a user-local override for the native Steam desktop entry and backs up an existing local entry. It does not enable Steam Input for individual games. It does not cover every launch path (e.g. terminal, other launchers or Flatpak). It overrides any existing SDL_GAMECONTROLLERCONFIG value for this launcher; users with other custom mappings should merge them manually. Desktop entry changes shipped by Steam may require uninstalling and reinstalling the override.

## Uninstall

Fully exit Steam and run `bash uninstall.sh`. This restores the previous local launcher, if one existed, otherwise removes the override. If you previously installed the mapping manually, restoring that launcher will also restore that prior mapping.

## Technical details

The original Steam mapping omitted physical SDL buttons b2 and b5. Add `paddle1:b2,paddle2:b5,` to expose L5/R5. The full mapping, including the CRC reported by Steam after the override, is in `controller-mapping.txt`.

See [protocol notes](docs/protocol.md), [sanitized captures](captures/), and [upstream submission draft](docs/upstream.md). This is an independent community project, not affiliated with 8BitDo or Valve.
