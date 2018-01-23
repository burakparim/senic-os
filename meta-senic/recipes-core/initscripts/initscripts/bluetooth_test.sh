#!/bin/bash
BLE_DEVICES="$(hcitool dev | sed -n '1!p' | wc -l)"
if [ $BLE_DEVICES -gt 1 ]; then
    echo " $BLE_DEVICES Bluetooth device(s) found"
else
    echo " No Bluetooth device was found"
    exit 1
fi

while IFS='': read line; do
    mac=$(echo $line | cut -d' ' -f1)
    name=$(echo $line | cut -d' ' -f2-)
    echo " Found device named: $name with mac address: $mac"
    # To connect to the device
    hcitool -i hci0 cc $mac 2>&1
    if [ "$(hcitool con | grep $mac | wc -l)" -gt 0 ]; then
        echo " Successfully established Bluetooth connection with $name"
    else
        echo " Failed to connect to $name"
    fi
    echo `hcitool rssi $mac`
    # Disconnecting from the device
    hcitool -i hci0 dc $mac 2>&1
    if [ "$(hcitool con | grep $mac | wc -l)" -eq 0 ]; then
        echo " Successfully disconnected with $name"
    else
        echo " Failed to disconnect to $name"
    fi
    done < <(hcitool -i hci0 scan | sed -n '1!p')
