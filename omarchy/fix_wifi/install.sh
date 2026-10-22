#!/bin/bash
set -euo pipefail

# Applies the wifi icon self-heal + wake-script fix.
# Run as root:  sudo bash /tmp/opencode/fix/install.sh

if [[ $EUID -ne 0 ]]; then
  echo "Run as root:  sudo bash $0" >&2
  exit 1
fi

FIXDIR=/tmp/opencode/fix
TS=$(date +%Y%m%d-%H%M%S)

install_file() {
  local src=$1 dst=$2 mode=$3
  if [[ ! -f $src ]]; then
    echo "Missing staged file: $src" >&2
    exit 1
  fi
  if [[ -f $dst ]]; then
    cp -a "$dst" "$dst.$TS"
    echo "Backed up $dst -> $dst.$TS"
  fi
  install -m "$mode" -o root -g root "$src" "$dst"
  echo "Installed $dst"
}

install_file "$FIXDIR/Panel.qml" \
  /usr/share/omarchy/shell/plugins/panels/network/Panel.qml 644
install_file "$FIXDIR/wifi-macbook-fix.sh" \
  /usr/lib/systemd/system-sleep/wifi-macbook-fix.sh 755

echo ""
echo "Both files installed. Restart the Omarchy shell to load the new QML:"
echo "    omarchy restart shell"
echo ""
echo "The restart itself resets the current stale icon; the fixes keep it"
echo "truthful after future wakes. Rollback if anything looks off:"
echo "    sudo cp -a /usr/share/omarchy/shell/plugins/panels/network/Panel.qml.$TS \\"
echo "          /usr/share/omarchy/shell/plugins/panels/network/Panel.qml"
echo "    sudo cp -a /usr/lib/systemd/system-sleep/wifi-macbook-fix.sh.$TS \\"
echo "          /usr/lib/systemd/system-sleep/wifi-macbook-fix.sh"