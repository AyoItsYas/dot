#!/bin/bash

if [[ "$DESKTOP_SESSION" == "pop" || "$DESKTOP_SESSION" == "pop-wayland" ]]; then
  sleep 10

  cd "$HOME/.config/conky/"
  bash "$HOME/.config/conky/Mainte/control.sh" start

  while true; do
    if [ "$(cat /sys/class/power_supply/AC/online)" = 1 ]; then
      STOP_FLAG=0
    else
      if [ "$(cat /sys/class/power_supply/BAT0/capacity)" -lt 20 ]; then
        STOP_FLAG=1
      else
        STOP_FLAG=0
      fi
    fi

    OUT=$(xwininfo -id $(xdotool getactivewindow))
    WM_STATE=$(echo "$OUT" | grep "Width\|Height")

    WIDTH=$(echo "$WM_STATE" | head -n 1 | awk '{print $2}' | sed 's/[^0-9]*//g')
    HEIGHT=$(echo "$WM_STATE" | tail -n 1 | awk '{print $2}' | sed 's/[^0-9]*//g')

    if [ "$HEIGHT" -gt 1000 ] && [ "$WIDTH" -gt 1900 ]; then
      STOP_FLAG=1
    else
      STOP_FLAG=0
    fi

    if [ "$STOP_FLAG" = 1 ]; then
      bash "$HOME/.config/conky/Mainte/control.sh" stop
    else
      bash "$HOME/.config/conky/Mainte/control.sh" continue
    fi

    sleep 10
  done

  bash "$HOME/.config/conky/Mainte/control.sh" stop
  exit 0
fi
