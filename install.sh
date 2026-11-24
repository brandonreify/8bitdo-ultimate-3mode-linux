#!/usr/bin/env bash
set -euo pipefail
root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
source_file=/usr/share/applications/steam.desktop
apps="${XDG_DATA_HOME:-$HOME/.local/share}/applications"
state="${XDG_STATE_HOME:-$HOME/.local/state}/8bitdo-ultimate-3mode-linux"
target="$apps/steam.desktop"
[[ -f "$source_file" ]] || { echo 'Native Steam desktop launcher not found; Flatpak is not supported.' >&2; exit 1; }
[[ ! -e "$state/installed.desktop" ]] || { echo 'Already installed. Uninstall first to refresh the launcher.'; exit 1; }
mkdir -p "$apps" "$state"
if [[ -e "$target" || -L "$target" ]]; then cp -L -- "$target" "$state/previous.desktop"; fi
mapping=$(cat "$root/controller-mapping.txt")
# Match the tested Cinnamon launcher approach; preserve desktop actions and arguments.
sed "s|^Exec=|Exec=env \"SDL_GAMECONTROLLERCONFIG=$mapping\" |" "$source_file" > "$state/installed.desktop"
install -m 644 "$state/installed.desktop" "$target.tmp"
mv -f -- "$target.tmp" "$target"
if command -v update-desktop-database >/dev/null; then update-desktop-database "$apps" || true; fi
echo 'Installed. Fully exit Steam and reopen it using the application menu.'
