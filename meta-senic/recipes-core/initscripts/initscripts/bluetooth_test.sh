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
    name=$(echo $line | cut -d' ' -f2)
    echo " Found device named: $name with mac address: $mac"
    # To connect to the device
    hcitool -i hci0 cc $mac 2>&1
    echo `hcitool con`
    hcitool -i hci0 dc $mac 2>&1
    done < <(hcitool -i hci0 scan | sed -n '1!p')
