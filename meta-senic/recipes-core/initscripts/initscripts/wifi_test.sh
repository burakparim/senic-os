#!/bin/sh
USB_LIST="$(usb-devices)"
IS_WLAN="$(echo "$USB_LIST" | grep -iE 'mt7601u' | wc -l)"

# Check if WiFi dongle is found
if [ $IS_WLAN -gt 0 ]; then
	echo " WLAN Dongle is found"	
else
	echo " WLAN Dongle is not found"	
fi

# Check wifi interfaces using nmcli
WIFI_INTERFACES="$(nmcli -t device show | grep wifi | wc -l)"
if [ $WIFI_INTERFACES -gt 0 ]; then
	echo " wifi interfaces are available"	
else
	echo " wifi interface is missing"	
fi

# Confirm that we are able to scan available networks
SCANNED_SSIDS="$(nmcli -t dev wifi list | wc -l)"
if [ $SCANNED_SSIDS -gt 0 ]; then
	echo " Successfully scanned $SCANNED_SSIDS networks"	
else
	echo " No SSIDS found"	
fi
