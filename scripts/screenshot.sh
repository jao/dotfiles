#!/bin/bash
# javascript:var unencodedURL = (location.href); var websiteURL = encodeURIComponent(unencodedURL); var url = 'http://api.snapito.com/?url=' + websiteURL + '&type=png&um=box&freshness=1&filename=image.png'; window.open(url, 'Download', '')

function countdown() {
  seconds=$1
  while [[ $seconds -gt 0 ]]; do
    seconds=$(expr $seconds - 1)
    sleep 1
    printf "\r Time until next iteration: \033[1m%02d:%02d:%02d\033[0m" \
                        $((seconds/3600)) $(( (seconds/60)%60)) $((seconds%60))
  done
  printf "\r                           "
  echo ""
}

echo -e "\033[0;30;42m Starting script at \033[1;30m`date "+%H:%M:%S %d/%m/%Y"`                                   \033[0m"

CURRENT_DATE=`date "+%Y-%m-%d_%H-%M-%s"`

while [[ "$CURRENT_DATE" < "2013-11-30_00-00-00" ]]; do
  echo " Saving images... `date "+%H:%M:%S %d/%m/%Y"`"
  for website in submarino magazineluiza buscape americanas walmart; do
    echo "   saving ${website}'s screenshot..."
    filename="image_${website}_$CURRENT_DATE.png"

    NEXT_WAIT_TIME=0
    COMMAND_STATUS=1
    until [[ $COMMAND_STATUS -eq 0 || $NEXT_WAIT_TIME -eq 4 ]]; do
      curl -s -L -D /tmp/headers "http://api.snapito.com/?url=http://${website}.com.br&type=png&um=box&freshness=1&delay=-1&filename=${filename}" -o $filename

      COMMAND_STATUS=$?
      sleep $NEXT_WAIT_TIME
      let NEXT_WAIT_TIME=NEXT_WAIT_TIME+1
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

  countdown $timeToWait

  CURRENT_DATE=`date "+%Y-%m-%d_%H-%M-%s"`
done

echo -e "\033[0;32mAll done at\033[0m `date "+%H:%M:%S %d/%m/%Y"`, \033[0,31mcongratulations!\033[0m"

