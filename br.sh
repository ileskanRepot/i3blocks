#!/bin/sh
BR=$(echo $(cat /sys/class/backlight/intel_backlight/brightness)"/"$(cat /sys/class/backlight/intel_backlight/max_brightness)"*"100 | bc -l | cut -c1-5)

echo 'BR: '$BR'%'
