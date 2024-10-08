#!/bin/bash
# -*- coding: utf-8 -*-

# run on the first user login (from $HOME) | ran by runme.desktop
cd ~

#xfconf-query -c xfce4-panel -p /panels/panel-1/position -n -t string -s "p=4;x=0;y=0" # taskbar -> bottom
xfconf-query -c xfwm4 -p /general/workspace_count -s 2
xfconf-query -c xsettings -p /Net/ThemeName -s "Adwaita-dark" # set dark theme


xmessage "Change any settings you need to change, then close the respective windows."


# will run one after the other
xfce4-keyboard-settings
xfce4-settings-editor
xfce4-settings-manager

ping 1.1.1.1 -W 5 -c 1
if [ $? -eq 0 ]; then
	xmessage "Online."
else
	xmessage "Offline. Refer to the wiki to get a connection."
fi

xmessage "All done. Have fun"
rm -f $HOME/first-login.bash
rm -f $HOME/Desktop/runme.desktop
exit
