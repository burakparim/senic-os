#!/bin/bash
BLE_DEVICES="$(hciconfig dev | grep Type | wc -l)"
if [ $BLE_DEVICES -gt 0 ]; then
    echo " $BLE_DEVICES Bluetooth device(s) found"
else
    echo " No Bluetooth device was found"
    exit 1
fi

while IFS='': read interface_line; do
    interface=$(echo $interface_line | cut -d' ' -f1)
    echo " Scanning using $interface interface"
    status=$(hciconfig $interface | sed -n '3 p' | cut -d' ' -f1 | xargs)
    if [ "$status" == "DOWN" ]; then
        hciconfig $interface up
    fi
    while IFS='': read line; do
        mac=$(echo $line | cut -d' ' -f1)
        name=$(echo $line | cut -d' ' -f2-)
        echo " Found device named: $name with mac address: $mac"
        # To connect to the device
        hcitool -i $interface cc $mac 2>&1
        if [ "$(hcitool con | grep $mac | wc -l)" -gt 0 ]; then
            echo " Successfully established Bluetooth connection with $name"
        else
            echo " Failed to connect to $name"
            continue
        fi
        echo `hcitool rssi $mac`
        # Disconnecting from the device
        hcitool -i $interface dc $mac 2>&1
        if [ "$(hcitool con | grep $mac | wc -l)" -eq 0 ]; then
            echo " Successfully disconnected with $name"
        else
            echo " Failed to disconnect to $name"
        fi
    done < <(hcitool -i $interface scan | sed -n '1!p')
done < <(hciconfig dev | grep Type)
