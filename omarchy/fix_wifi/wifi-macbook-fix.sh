#!/bin/sh

# Reload the Broadcom Wi-Fi driver after resume: the firmware wedges during
# suspend and only a driver reload brings the radio back.
#
# NetworkManager is deliberately left running through the reload: it sees the
# device disappear and reappear (standard unplug/replug flow) and re-activates
# the saved profile on its own. It must NOT be restarted unconditionally here —
# Quickshell's networking backend has no NetworkManager service watcher, so when
# the service restarts under a live shell the shell's Wi-Fi icon goes stale and
# reads "disconnected" even though the link is up.
#
# NetworkManager is only restarted as a last resort if the radio has still not
# come back shortly after the reload; a stale shell icon beats a lost connection.

case $1 in
	post)
		modprobe -r brcmfmac_wcc 2>/dev/null
		modprobe -r brcmfmac 2>/dev/null || modprobe -r wl 2>/dev/null
		sleep 1
		modprobe brcmfmac_wcc 2>/dev/null
		modprobe brcmfmac 2>/dev/null || modprobe wl 2>/dev/null
		sleep 2

		if command -v nmcli >/dev/null 2>&1; then
			i=0
			up=0
			while [ "$i" -lt 8 ]; do
				if nmcli -t -f TYPE,STATE device 2>/dev/null \
					| grep -qE '^wifi:(connecting|connected)$'; then
					up=1
					break
				fi
				sleep 1
				i=$((i + 1))
			done

			if [ "$up" -eq 0 ]; then
				systemctl restart NetworkManager 2>/dev/null
			fi
		fi
		;;
esac

exit 0