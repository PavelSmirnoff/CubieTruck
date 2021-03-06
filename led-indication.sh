#!/bin/bash

bat_led_ust=90;
bat_min_ust=20;
declare -i br=0;
declare -i br1=0;
declare -i br2=0;
declare -i sec_now=0;
declare -i msec_now=0;

cpu_temp_ust=46;
declare -i cpu_temp=0;

#Включение синего светодиода при работе с диском:
echo disk-activity > /sys/devices/platform/leds/leds/cubietruck:blue:usr/trigger


#Вывод информации о состоянии батареи
#cat /sys/class/power_supply/axp20x-battery/uevent;

while true; do

sec_now=10#$(date +%S);
msec_now=10#$(date +%N)/1000/100000;
br=msec_now%2;
br1=sec_now%2;
br2=sec_now%3;
bat_compacity=$(cat /sys/class/power_supply/axp20x-battery/capacity);
bat_status=$(cat /sys/class/power_supply/axp20x-battery/status);

#cat /sys/class/power_supply/axp20x-battery/capacity;
#cat /sys/class/power_supply/axp20x-battery/status;

#Оранжевый индикатор разряда батареи
	if [ "$bat_status" == "Charging" ]; then
		echo $br2 > /sys/devices/platform/leds/leds/cubietruck:orange:usr/brightness;
	fi
        if [ "$bat_status" == "Discharging" ]; then
                echo $br1 > /sys/devices/platform/leds/leds/cubietruck:orange:usr/brightness;
        fi

#	echo $br > /sys/devices/platform/leds/leds/cubietruck:orange:usr/brightness;
#	echo $br2 > /sys/devices/platform/leds/leds/cubietruck:white:usr/brightness;
#	echo "$sec_now $msec_now $br $br1 $br2";

	if [[ $bat_compacity -lt $bat_min_ust ]]; then
        	echo $br > /sys/devices/platform/leds/leds/cubietruck:orange:usr/brightness;
        	if [[ $bat_compacity -le $bat_min_ust-10 ]] && [ "$bat_status" != "Charging" ]; then
#                	shutdown -h now
                	echo "Пора выключать кубик";
        	fi
	fi

	if [[ $bat_compacity -gt 98 ]]; then
		echo 0 > /sys/devices/platform/leds/leds/cubietruck:orange:usr/brightness;
	fi


# Белый индикатор при повышении температуры CPU выше 46 градусов
cpu_temp=10#$(cat /sys/devices/virtual/thermal/thermal_zone0/temp)/1000;
	if [[ $cpu_temp -le $cpu_temp_ust ]]; then
        	echo 0 > /sys/devices/platform/leds/leds/cubietruck:white:usr/brightness;
#		echo 0;
	elif [[ $cpu_temp -le $cpu_temp_ust+10 ]]; then
		echo $br1 > /sys/devices/platform/leds/leds/cubietruck:white:usr/brightness;
#		echo 1;
	else
        	echo $br1 > /sys/devices/platform/leds/leds/cubietruck:white:usr/brightness;
#		echo 2;
	fi
echo "CPU $cpu_temp $cpu_temp_ust";

done

