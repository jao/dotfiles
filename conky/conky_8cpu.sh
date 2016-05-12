#!/bin/bash
killall conky

conky -c ~/dotfiles/conky/.conkyrc_8cpu &
#conky -c ~/Scripts/conky/.conkyrc_cal &
conky -c ~/dotfiles/conky/.conkyrc_quote &
