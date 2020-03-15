#!/bin/bash

cpu_temp=$(cat /sys/devices/virtual/thermal/thermal_zone0/temp)
cpu_temp_ust=46000

# Белый индикатор при повышении температуры CPU выше 46 градусов
if [[ $cpu_temp -le $cpu_temp_us ]]
then
        echo 1 > /sys/devices/platform/leds/leds/cubietruck:white:usr/brightness
else
        echo 0 > /sys/devices/platform/leds/leds/cubietruck:white:usr/brightness
fi

