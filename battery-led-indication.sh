#!/bin/bash

bat_compacity=$(cat /sys/class/power_supply/axp20x-battery/capacity)
bat_status=$(cat /sys/class/power_supply/axp20x-battery/status)
bat_led_ust=90
bat_min_ust=20

#Оранжевый индикатор разряда батареи
if [[ $bat_compacity -gt $bat_led_ust ]]
then
	echo 0 > /sys/devices/platform/leds/leds/cubietruck:orange:usr/brightness
else
	echo 1 > /sys/devices/platform/leds/leds/cubietruck:orange:usr/brightness
	if [[ $bat_compacity -le $bat_min_ust ]] && [ "$bat_status" != "Charging" ]; then
		#shutdown -h now
		echo "Пора выключать кубик"
	fi
fi

#Моргание оранжевым пока идет зарядка
declare -i i=0;
declare -i j=0;
while [ "$bat_status" == "Charging" ]; do
        i=i+1
        j=i%2
#        echo "light $j"
        echo $j > /sys/devices/platform/leds/leds/cubietruck:orange:usr/brightness
        sleep 0.5
done
        echo "done!";
