#!/bin/bash
# -*- coding: utf-8 -*-

# run on the first user login (from $HOME)
cd ~

#xfconf-query -c xfce4-panel -p /panels/panel-1/position -n -t string -s "p=4;x=0;y=0" # taskbar -> bottom


xmessage "Change any settings you need to change, then close the respective windows."


# will run one after the other
xfce4-keyboard-settings
xfce4-settings-editor
xfce4-settings-manager


xmessage "All done."
rm -f $HOME/first-login.bash
rm -f $HOME/Desktop/runme.desktop
exit