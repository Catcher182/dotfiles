#!/bin/bash
# This is a fork of https://github.com/luyves/polybar-rofi-usb-mount
usbcheck() {
	mounteddrives="$(lsblk -rpo "name,type,size,mountpoint" | grep -v 'nvme' | awk '$2=="part"&&$4!=""{printf "%s (%s)  ",$1,$3}')"
	# 去除变量首尾空格
	if [ $(echo "$mounteddrives" | wc -w) -gt 0 ]; then
		trimmed_var=$(echo "$mounteddrives" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
		echo "USB:${trimmed_var}"
	else
		if [ $(echo "$usbdrives" | wc -w) -gt 0 ]; then
			echo "USB"
		else
			echo ""
		fi
	fi
}

mountusb() {
	chosen=$(echo "$usbdrives" | rofi -dmenu -show run -p "Mount drive" | awk '{print $1}')
	mountpoint=$(udisksctl mount --no-user-interaction -b "$chosen" 2>/dev/null) && notify-send "💻 USB mounting" "$chosen mounted to $mountpoint" && exit 0
}

umountusb() {
	chosen=$(echo "$mounteddrives" | rofi -dmenu -show run -p "Unmount drive" | awk '{print $1}')
	mountpoint=$(udisksctl unmount --no-user-interaction -b "$chosen" 2>/dev/null) && notify-send "💻 USB unmounting" "$chosen unmounted" && exit 0
}

umountall() {
	for chosen in $(echo $(lsblk -rnpo name,size,mountpoint,fstype | grep -v 'nvme' | awk 'NF==4 {print $1}')); do
		udisksctl unmount --no-user-interaction -b "$chosen"
	done
}

usbdrives="$(lsblk -rnpo name,size,mountpoint,fstype | grep -v 'nvme' | awk 'NF==3 {print $1, $2, $3}')"
mounteddrives="$(lsblk -rnpo name,size,mountpoint,fstype | grep -v 'nvme' | awk 'NF==4 {print $1, $2, $3, $4}')"

menu() {
	SelectMenu=$(echo -e "Mount\nUmount\nUmountAll" | rofi -dmenu -show run -p "Udisk" | awk '{print $1}')
}

if [ -n "$1" ]; then
	case $1 in
	check)
		usbcheck
		;;
	mount)
		if [ $(echo "$usbdrives" | wc -w) -gt 0 ]; then
			notify-send "USB drive(s) detected."
			mountusb
		else
			notify-send "No USB drive(s) detected." && exit
		fi
		;;
	umount)
		if [ $(echo "$mounteddrives" | wc -w) -gt 0 ]; then
			notify-send "USB drive(s) detected."
			umountusb
		else
			notify-send "No USB drive(s) to unmount." && exit
		fi
		;;
	umountAll)
		if [ $(echo "$mounteddrives" | wc -w) -gt 0 ]; then
			notify-send "Unmounting all USB drives."
			umountall
		else
			notify-send "No USB drive(s) to unmount." && exit
		fi
		;;
	esac
else
	menu
	case $SelectMenu in
	Mount)
		if [ $(echo "$usbdrives" | wc -w) -gt 0 ]; then
			notify-send "USB drive(s) detected."
			mountusb
		else
			notify-send "No USB drive(s) detected." && exit
		fi
		;;
	Umount)
		if [ $(echo "$mounteddrives" | wc -w) -gt 0 ]; then
			notify-send "USB drive(s) detected."
			umountusb
		else
			notify-send "No USB drive(s) to unmount." && exit
		fi
		;;
	UmountAll)
		if [ $(echo "$mounteddrives" | wc -w) -gt 0 ]; then
			notify-send "Unmounting all USB drives."
			umountall
		else
			notify-send "No USB drive(s) to unmount." && exit
		fi
		;;
	esac
fi
