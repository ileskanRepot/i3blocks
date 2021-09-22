#!/bin/sh

VOLUME_MUTE="🔇"
VOLUME_LOW="🔈"
VOLUME_MID="🔉"
VOLUME_HIGH="🔊"
SOUND_LEVEL=$(amixer -M get Master | awk -F"[][]" '/%/ { print $2 }' | awk -F"%" 'BEGIN{tot=0; i=0} {i++; tot+=$1} END{printf("%s\n", tot/i) }')
MUTED=$(amixer get Master | awk ' /%/{print ($NF=="[off]" ? 1 : 0); exit;}')
BG_COLOR='background="#ffcc00"'
CON=$(cat /proc/asound/card*/codec#0 | grep ': 0x00' | wc -l)

ICON=$VOLUME_MUTE
if [ "$MUTED" = "1" ]
then
	ICON="$VOLUME_MUTE"
	BG_COLOR=''
else
	[ "$CON" == "2" ] && BG_COLOR=''
	if [ "$SOUND_LEVEL" -lt 34 ]
	then
		ICON="$VOLUME_LOW"
	elif [ "$SOUND_LEVEL" -lt 67 ]
	then
		ICON="$VOLUME_MID"
	else
		ICON="$VOLUME_HIGH"
	fi
fi

SOUND_LEVEL=$(amixer -M get Master | awk -F"[][]" '/%/{ print $2 }' | tr "\n"  " ")

OUTPUT=$(echo "$ICON" "$SOUND_LEVEL" )
echo '<span '$BG_COLOR' foreground="#000000">'$OUTPUT'</span>'
