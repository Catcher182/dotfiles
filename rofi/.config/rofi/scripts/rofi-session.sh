#!/usr/bin/env bash
#
# this script manages the user session using loginctl and an optional screen locker
#
# dependencies: rofi, systemd/elogind
# optional: i3lock

ROFI_CMD="${ROFI_CMD:-rofi -dmenu -i}"
USE_LOCKER="${USE_LOCKER:-false}"
LOCKER="${LOCKER:-hyprlock}"

entries="Lock Screen\nLog Out\nReboot\nShutdown\nSuspend\nHibernate"

declare -A commands=(
	["Lock Screen"]=lock_screen
	["Log Out"]=logout_user
	["Reboot"]=reboot_sys
	["Shutdown"]=shutdown_sys
	["Suspend"]=suspend_sys
	["Hibernate"]=hibernate_sys
)

confirm_action() {
	local choice

	choice=$(echo -e "Yes\nNo" |
		rofi -p "Are you sure?" -dmenu -u 1)

	if [ "$choice" == "Yes" ]; then
		echo "$choice"
	fi
}

logout_user() {
	if [[ "$DESKTOP_SESSION" == 'openbox' ]]; then
		openbox --exit
	elif [[ "$DESKTOP_SESSION" == 'bspwm' ]]; then
		bspc quit
	elif [[ "$DESKTOP_SESSION" == 'i3' ]]; then
		i3-msg exit
	elif [[ "$DESKTOP_SESSION" == 'plasma' ]]; then
		qdbus org.kde.ksmserver /KSMServer logout 0 0 0
	elif [[ "$DESKTOP_SESSION" == 'hyprland' ]]; then
		hyprctl dispatch exit
	else
		loginctl terminate-session "${XDG_SESSION_ID-}"
	fi
}

lock_screen() { loginctl lock-session "${XDG_SESSION_ID-}"; }
reboot_sys() { [ "$(confirm_action)" = "Yes" ] && systemctl reboot; }
shutdown_sys() { [ "$(confirm_action)" = "Yes" ] && systemctl poweroff; }
suspend_sys() {
	$($USE_LOCKER) && "$LOCKER"
	systemctl suspend
}
hibernate_sys() {
	$($USE_LOCKER) && "$LOCKER"
	systemctl hibernate
}

while choice=$(echo -en "$entries" | $ROFI_CMD -p "Session"); do
	${commands[$choice]}
	exit 0
done

exit 1
