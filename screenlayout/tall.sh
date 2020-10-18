#!/bin/bash

set -euo pipefail
export BIGMONITOR_OUTPUT=$(xrandr -q | grep '^DP' | grep ' connected' | awk '{ print $1 }')
#NOTE
# xrandr | grep 'VGA-1 connected' | ifne xrandr --output VGA-1 --auto --left-of LVDS-1
#xrandr | grep 'DP-1 connected' | ifne xrandr --output DP-1 --auto --left-of LVDS-1

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
"${DIR}"/clear.sh
# infer whether it's on display port or mini-display port:

export LTWIDTH=1360
export LTHEIGHT=768
export LTMODE=${LTWIDTH}x${LTHEIGHT}
set -x
xrandr \
       --output eDP-1-1 --primary --mode ${LTMODE} --pos 1210x2160 --rotate normal \
       --output ${BIGMONITOR_OUTPUT} --mode 3780x2160 --pos 0x0 --rotate normal \
       --setmonitor D "1360/0x768/0+1210+2160" eDP-1-1 \
       --setmonitor W "1260/0x2160/0+0+0" ${BIGMONITOR_OUTPUT} \
       --setmonitor E "1260/0x2160/0+1260+0" none \
       --setmonitor R "1260/0x2160/0+2520+0" none \
#       --setmonitor Y "3780/0x30/0+0+0" none \

# total width is 3780
