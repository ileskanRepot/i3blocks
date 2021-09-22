NOT=$(dunstctl is-paused)
VIDPLAY=$(playerctl status)

if [ $VIDPLAY == "Playing" ];
then
	echo -n "▶ ";
else
	echo -n "⏸ ";
fi

if [ -z "$1" ];
then
	if [ $NOT == "false" ];
	then
		echo ;
	else
		echo ;
	fi
else
	if [ $NOT == "false" ];
	then
		dunstctl set-paused true;
		echo ;
	else
		dunstctl set-paused false;
		echo ;
	fi
fi
