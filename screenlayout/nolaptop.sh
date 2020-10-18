#!/bin/bash

#NOTE
# xrandr | grep 'VGA-1 connected' | ifne xrandr --output VGA-1 --auto --left-of LVDS-1
#xrandr | grep 'DP-1 connected' | ifne xrandr --output DP-1 --auto --left-of LVDS-1

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "Starting ~/.screenlayout/config.sh $(date)" >> /tmp/screenlayout.log
"${DIR}"/clear.sh
#export MODE1=1360x768
export LTWIDTH=1360
export LTHEIGHT=768
export LTMODE=${LTWIDTH}x${LTHEIGHT}
xrandr \
       --output eDP-1-1 --primary --mode ${LTMODE} --pos 1210x2160 --rotate normal \
       --output HDMI-1 --mode 3840x2160 --pos 0x0 --rotate normal \
       --setmonitor D "1360/0x768/0+1210+2160" eDP-1-1 \
       --setmonitor W "1260/0x1660/0+0+500" DP-1-2 \
       --setmonitor E "1260/0x1660/0+1260+500" none \
       --setmonitor R "1260/0x1660/0+2520+500" none \
       --setmonitor Y "3780/0x500/0+0+0" none \

# total width is 3780
