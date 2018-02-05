#!/bin/bash
### BEGIN INIT INFO
# Provides: basic_hw_test_suit
# Short-Description: Test suite for different HW components
### END INIT INFO

if [ "$1" == "--h" ]; then
    echo "Usage: `basename $0`"
    echo ""
    echo "For wifi tests, you need to set and export SSID_NAME and SSID_PASSWORD environment variables."
    echo "Results are written to results.txt file."
    echo "Each row has results for a interface identified by first character."
    echo "w for wifi, b for bluetooth, l for led test."
    echo "F indicates Failure, P being Pass."
    echo "Sequence of tests are documented in respective shell scripts."
    echo ""
    exit 0
fi

# Test for LED
echo 198 > /sys/class/gpio/export
echo out > /sys/class/gpio/gpio198/direction
echo 1 > /sys/class/gpio/gpio198/value
LED_TEST="F"
if [ "$(cat /sys/class/gpio/gpio198/value)" -eq 1 ]; then
    echo " LED switched on."
    LED_TEST="P"
else
    echo " Failed to switch on LED."
fi

echo 0 > /sys/class/gpio/gpio198/value
if [ "$(cat /sys/class/gpio/gpio198/value)" -eq 0 ]; then
    echo " LED switched off."
else
    echo " Failed to switch off LED."
    LED_TEST="F"
fi

echo "l:$LED_TEST" > results.txt

dir=$(dirname "$0")

/bin/bash "$dir/bluetooth_test.sh"
/bin/bash "$dir/wifi_test.sh"
cat /proc/cpuinfo | grep Serial | cut -d' ' -f2 | qrencode -t ASCII
cat results.txt
