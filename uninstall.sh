#!/usr/bin/env bash
set -euo pipefail
apps="${XDG_DATA_HOME:-$HOME/.local/share}/applications"
state="${XDG_STATE_HOME:-$HOME/.local/state}/8bitdo-ultimate-3mode-linux"
target="$apps/steam.desktop"
[[ -f "$state/installed.desktop" ]] || { echo 'No recorded installation.'; exit 1; }
if [[ -e "$target" ]] && ! cmp -s "$target" "$state/installed.desktop"; then
  echo 'Launcher was changed after installation; refusing to overwrite it. Back it up and remove it manually.' >&2; exit 1
fi
if [[ -f "$state/previous.desktop" ]]; then
  install -m 644 "$state/previous.desktop" "$target"
else
  rm -f -- "$target"
fi
rm -f -- "$state/previous.desktop" "$state/installed.desktop"
rmdir "$state" 2>/dev/null || true
if command -v update-desktop-database >/dev/null; then update-desktop-database "$apps" || true; fi
echo 'Previous launcher restored. Restart Steam.'
