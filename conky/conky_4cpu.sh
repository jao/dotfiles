#!/bin/bash
killall conky
sleep 15

conky -c ~/Scripts/conky/.conkyrc_4cpu &
#conky -c ~/Scripts/conky/.conkyrc_cal &
#conky -c ~/Scripts/conky/.conkyrc_quote &
