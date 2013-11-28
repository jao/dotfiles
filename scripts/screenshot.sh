#!/bin/bash
# javascript:var unencodedURL = (location.href); var websiteURL = encodeURIComponent(unencodedURL); var url = 'http://api.snapito.com/?url=' + websiteURL + '&type=png&um=box&freshness=1&filename=image.png'; window.open(url, 'Download', '')

function countdown() {
  seconds=$1
  message=$2
  while [[ $seconds -gt 0 ]]; do
    seconds=$(expr $seconds - 1)
    sleep 1
    printf "\r $message: \033[1m%02d:%02d:%02d\033[0m" \
                        $((seconds/3600)) $(( (seconds/60)%60)) $((seconds%60))
  done
  printf "\r                           "
  echo ""
}

echo -e "\033[0;30;42m Starting script at \033[1;30m`date "+%H:%M:%S %d/%m/%Y"`                                   \033[0m"

CURRENT_DATE=`date "+%Y-%m-%d_%H-%M-%S"`

while [[ "$CURRENT_DATE" < "2013-11-30_00-30-00" ]]; do
  echo " Saving images..."
  for website in submarino magazineluiza buscape americanas walmart ricardoeletro casasbahia pontofrio shoptime extra; do
    echo "   saving ${website}'s screenshot..."
    filename="image_${website}_${CURRENT_DATE}.png"

    RETRIES=0
    COMMAND_STATUS=1
    until [[ $COMMAND_STATUS -eq 0 || $RETRIES -eq 5 ]]; do

      [[ $RETRIES -lt 0 ]] && echo -e " \033[31mAn error has occurred, retrying...\033[0m"
      if [[ "$website" == "magazineluiza" || "$website" == "" ]]; then
        delay="30"
      else
        delay="5"
      fi
      curl -s -L -D /tmp/headers "http://api.snapito.com/?url=http://${website}.com.br&type=png&um=box&freshness=1&delay=${delay}&filename=${filename}" -o $filename

      COMMAND_STATUS=$?
      if [[ $COMMAND_STATUS -ne 0 ]]; then
        countdown 5 "Retrying in"
      fi
      let RETRIES=$((RETRIES++))
    done

    if [ -e $filename ]; then
      echo -e "   \033[0;32m- ${filename} written.\033[0m"
    else
      echo -e "   \033[0;31m- ${filename} was not written.\033[0m"
    fi
  done

  startTime=$(date +%s)
  endTime=$(date -v+1H -v0M -v0S +%s)
  timeToWait=$(($endTime - $startTime))

  countdown $timeToWait "Time until next iteration"

  CURRENT_DATE=`date "+%Y-%m-%d_%H-%M-%s"`
done

echo -e "\033[0;32mAll done at\033[0m `date "+%H:%M:%S %d/%m/%Y"`, \033[0,31mcongratulations!\033[0m"

