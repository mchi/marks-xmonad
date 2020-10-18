#!/bin/bash

export BIGMONITOR_OUTPUT=$(xrandr -q | egrep '^(DP|HDMI)' | grep ' connected' | awk '{ print $1 }')

echo ${BIGMONITOR_OUTPUT}




DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
"${DIR}"/clear.sh


export LTWIDTH=1360
export LTHEIGHT=768
export LTMODE=${LTWIDTH}x${LTHEIGHT}
xrandr \
       --output eDP-1-1 --primary --mode ${LTMODE} --pos 1210x2160 --rotate normal \
       --output ${BIGMONITOR_OUTPUT} --mode 3780x2160 --pos 0x0 --rotate normal \
       --setmonitor D "1360/0x768/0+1210+2160" eDP-1-1 \
       --setmonitor W "1260/0x1660/0+0+500" ${BIGMONITOR_OUTPUT} \
       --setmonitor E "1260/0x1660/0+1260+500" none \
       --setmonitor R "1260/0x1660/0+2520+500" none \
       --setmonitor Y "3780/0x500/0+0+0" none \

# total width is 3780
