#!/bin/bash

BATTERY_CAPACITY=$(cat /sys/class/power_supply/BAT0/capacity)
CAPACITY_THRESHOLD_BOT=40
CAPACITY_THRESHOLD_TOP=80
USERNAME=$(users)
USERID=$(id -u $USERNAME)

while [ $(cat /sys/class/power_supply/BAT0/status) == "Discharging" ] && [[ $BATTERY_CAPACITY -ge $CAPACITY_THRESHOLD_BOT ]]
do
        #echo Discharging... 
        BATTERY_CAPACITY=$(cat /sys/class/power_supply/BAT0/capacity)
        sleep 60

        if [[ $BATTERY_CAPACITY -le $CAPACITY_THRESHOLD_BOT ]]
        then
                sudo -u $USERNAME DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$USERID/bus notify-send 'CHARGE' 'It is time to CHARGE the battery!'
                break
        fi
done

echo Discharge done
sleep 30

BATTERY_CAPACITY=$(cat /sys/class/power_supply/BAT0/capacity)

while [ $(cat /sys/class/power_supply/BAT0/status) == "Charging" ] && [[ $BATTERY_CAPACITY -le $CAPACITY_THRESHOLD_TOP ]]
do
        #echo Charging...
        BATTERY_CAPACITY=$(cat /sys/class/power_supply/BAT0/capacity)
        sleep 60

        if [[ $BATTERY_CAPACITY -ge $CAPACITY_THRESHOLD_TOP ]]
        then
                sudo -u $USERNAME DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$USERID/bus notify-send 'DISCHARGE' 'It is time to DISCHARGE the battery!'
                break
        fi
done
echo Charge done
