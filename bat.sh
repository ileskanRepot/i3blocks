#!/bin/sh

BAT=$(echo $(cat /sys/class/power_supply/BAT0/energy_now)"/"$(cat /sys/class/power_supply/BAT0/energy_full)"*"100 | bc -l | cut -c1-5)
STATUS=$(cat /sys/class/power_supply/BAT0/status)
COLOR='red'
LOGO=''
BATEMP=''
BATLOW=''
BATMID=''
BATHIGH=''
CHAR=''

if [ $STATUS == 'Charging' ];
then
	COLOR='green'
	LOGO=$CHAR
else
	if [ $(echo $BAT | awk '{printf("%d\n",$1)}') -ge 90 ];
	then
		COLOR='green'
		LOGO=$BATHIGH	
	elif [ $(echo $BAT | awk '{printf("%d\n",$1)}') -ge 50 ];
	then
		COLOR='black'
		LOGO=$BATMID
	elif [ $(echo $BAT | awk '{printf("%d\n",$1)}') -ge 20 ];
	then
		COLOR='blue'
		LOGO=$BATLOW
	fi

	if [ $(echo $BAT | awk '{printf("%d\n",$1)}') -le 1 ];
	then
		systemctl hibernate
	elif [ $(echo $BAT | awk '{printf("%d\n",$1)}') -le 5 ]
	then
		notify-send 'BAT: '$BAT'%'
		LOGO=$BATEMP
	fi
fi

echo '<span background="red" foreground="#FFFFFF">'$LOGO' '$BAT'%</span>'
