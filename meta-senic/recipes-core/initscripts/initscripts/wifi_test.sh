#!/bin/bash
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
	echo " wifi interfaces are available";
    while IFS=':': read -r name interface status ssid;
    do
        echo " Name of interface: $name";
    done < <(nmcli -t dev | grep 'wifi')
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

# Look for SSID details in environment variables
if [ -n "$SSID_NAME" ]; then
    while IFS=':': read -r name interface status ssid;
    do
        if [ "$status" == "connected" ]; then
            echo " Interface: $name is already connected to $ssid";
        else
            echo " Connecting $name to $SSID_NAME..."
            # nmcli command to connect to network
            nmcli dev wifi con $SSID_NAME password $SSID_PASSWORD ifname $name
            result=$(nmcli -t dev | grep wlp3s0 | awk -F':' '{print $3}')
            if [ "$result" == "connected" ]; then
                echo " Interface: $name is now connected to $ssid"
                con_name=$(nmcli -t dev | grep wlp3s0 | awk -F':' '{print $4}')
                # nmcli command to close down a connection.
                nmcli con down id $con_name
                result=$(nmcli -t dev | grep wlp3s0 | awk -F':' '{print $3}')
                if [ "$result" == "disconnected" ]; then
                    echo " Closed connection for: $name"
                else
                    echo " Failed to close connection for: $name"
                fi
            else
                echo " Failed to connect Interface: $name to $ssid"
            fi
        fi
    done < <(nmcli -t dev | grep 'wifi')
    result=$(nmcli dev | grep "ethernet" | grep -w "connected")
else
    echo " Please set SSID_NAME and SSID_PASSWORD environment variables"
fi
