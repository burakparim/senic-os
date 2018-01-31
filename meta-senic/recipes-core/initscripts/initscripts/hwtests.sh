#!/bin/bash
### BEGIN INIT INFO
# Provides: basic_hw_test_suit
# Short-Description: Test suite for different HW components
### END INIT INFO

# Test for LED
echo 198 > /sys/class/gpio/export
echo out > /sys/class/gpio/gpio198/direction
echo 1 > /sys/class/gpio/gpio198/value
LED_TEST="F"
if [ "$(/sys/class/gpio/gpio198/value)" -eq 1 ]; then
    echo " LED switched on."
    LED_TEST="P"
else
    echo " Failed to switch on LED."
fi

echo 0 > /sys/class/gpio/gpio198/value
if [ "$(/sys/class/gpio/gpio198/value)" -eq 0 ]; then
    echo " LED switched off."
else
    echo " Failed to switch off LED."
    LED_TEST="P"
fi

echo "l:$LED_TEST" > results.txt
   
/bin/bash bluetooth_test.sh
/bin/bash wifi_test.sh
qrencode -t ASCII -o code.txt < results.txt
cat code.txt
