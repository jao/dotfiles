#!/bin/bash

# javascript:var unencodedURL = (location.href); var websiteURL = encodeURIComponent(unencodedURL); var url = 'http://api.snapito.com/?url=' + websiteURL + '&type=png&um=box&freshness=1&filename=image.png'; window.open(url, 'Download', '')

function countdown() {
  seconds=$1
  while [[ $seconds -gt 0 ]]; do
    seconds=$(expr $seconds - 1)
    sleep 1
    printf "\rTime until next iteration: %02d:%02d:%02d" \
                        $((seconds/3600)) $(( (seconds/60)%60)) $((seconds%60))
  done
  printf "\r                           "
  echo ""
}

CURRENT_DATE=`date "+%Y-%m-%d_%H-%M-%s"`

while [[ "$CURRENT_DATE" < "2013-11-30_00-00-00" ]]; do
  echo "Saving images... `date "+%Y-%m-%d %H:%M:%s"`"
  for website in submarino magazineluiza; do
    echo "  Saving $website's screenshot..."
    curl -s -L -D /tmp/headers "http://api.snapito.com/?url=http://${website}.com.br&type=png&um=box&freshness=1&filename=image_${website}_${CURRENT_DATE}.png" -o image_${website}_$CURRENT_DATE.png
    echo "    - image_${website}_$CURRENT_DATE.png written."
  done

  startTime=$(date +%s)
  endTime=$(date -v+1H -v0M -v0S +%s)
  timeToWait=$(($endTime - $startTime))

  countdown $timeToWait

  CURRENT_DATE=`date "+%Y-%m-%d_%H-%M-%s"`
done
