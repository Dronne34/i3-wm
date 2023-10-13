
#!/bin/bash

#exec conky -c ~/.config/conky/clock.conf &
#exec xss-lock  --transfer-sleep-lock -- ~/.config/i3/scripts/lock --nofork & 

exec nitrogen --restore &
exec xrandr -s 1920x1080 &
exec picom --config  ~/.config/picom/picom.conf  &
exec xrdb -merge ~/.Xresources  &
exec chmod +x .local/bin/* &
exec /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
exec eval "$(ssh-agent -s)"  &
exec sxhkd & 
exec i3-layouts &   
exec dunst &
exec /usr/bin/i3
