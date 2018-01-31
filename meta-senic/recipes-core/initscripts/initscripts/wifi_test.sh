#!/bin/bash
# RESULTS: F indicates Failure, P being Pass.
# Test Sequence :
# * Looking for MediaTek wifi USB device.
# * Confirming that usb gets listed as wifi.
# * Scanning for available wifi nerworks.
# * Confirm that we are able to connect to $SSID_NETWORK.
# * Fetch a html page using wifi interface.
# * Disconnecting to $SSID_NETWORK.
USB_LIST="$(usb-devices)"
IS_WLAN="$(echo "$USB_LIST" | grep -iE 'mt7601u' | wc -l)"

WIFI_HW_FOUND="F"
# Check if WiFi dongle is found
if [ $IS_WLAN -gt 0 ]; then
	echo " WLAN Dongle is found"
    WIFI_HW_FOUND="P"
else
	echo " WLAN Dongle is not found"	
fi


# Check wifi interfaces using nmcli
WIFI_DRIVER="F"
WIFI_INTERFACES="$(nmcli -t -f common device show | grep wifi | wc -l)"
if [ $WIFI_INTERFACES -gt 0 ]; then
	echo " wifi interfaces are available";
    WIFI_DRIVER="P"
    while IFS=':': read -r name interface status ssid;
    do
        echo " Name of interface: $name";
    done < <(nmcli -t -f DEVICE,TYPE,STATE,CONNECTION dev | grep 'wifi')
else
	echo " wifi interface is missing"	
fi

CAN_SCAN="F"
CAN_CONNECT="F"
CAN_DISCONNECT="F"
CAN_TX_DATA="F"
# Confirm that we are able to scan available networks
SCANNED_SSIDS="$(nmcli -t -f SSID dev wifi list | wc -l)"
if [ $SCANNED_SSIDS -gt 0 ]; then
	echo " Successfully scanned $SCANNED_SSIDS networks"
    CAN_SCAN="P"
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
            nmcli dev wifi con "$SSID_NAME" password "$SSID_PASSWORD" ifname $name
            updated_status=$(nmcli -t -f DEVICE,TYPE,STATE,CONNECTION dev | grep $name | awk -F':' '{print $3}')
            if [ "$updated_status" == "connected" ]; then
                CAN_CONNECT="P"
                connection_name=$(nmcli -t -f DEVICE,TYPE,STATE,CONNECTION dev | grep $name | awk -F':' '{print $4}')
                echo " Interface: $name is now connected to $SSID_NAME"
                # logic to fetch data using interface
                curl --interface $name https://www.senic.com/en/ > senic.html
                if [ $(ls -l senic.html | cut -d ' ' -f5) -gt 0 ]; then
                    echo " Successfully fetched html using interface $name"
                    CAN_TX_DATA="P"
                else
                    echo " Failed to fetch data using interface $name"
                fi
                # nmcli command to close down a connection.
                nmcli con down id "$connection_name"
                disconnect_status=$(nmcli -t -f DEVICE,TYPE,STATE,CONNECTION dev | grep $name | awk -F':' '{print $3}')
                if [ "$disconnect_status" == "disconnected" ]; then
                    CAN_DISCONNECT="P"
                    echo " Closed connection for: $name"
                else
                    echo " Failed to close connection for: $name"
                fi
            else
                echo " Failed to connect Interface: $name to $ssid"
            fi
        fi
    done < <(nmcli -t -f DEVICE,TYPE,STATE,CONNECTION dev | grep 'wifi')
else
    echo " Please set SSID_NAME and SSID_PASSWORD environment variables"
fi

echo "w:$WIFI_HW_FOUND $WIFI_DRIVER $CAN_SCAN $CAN_CONNECT $CAN_TX_DATA $CAN_DISCONNECT" >> results.txt
