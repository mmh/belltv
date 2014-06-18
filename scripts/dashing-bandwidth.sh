#!/bin/bash
BWLOG="/root/bandwidth-ifstat.log"
TIMES=15
WAITTIME=2

# fork ifstat to log bandwidth
/usr/bin/ifstat -i eth0 -b -n -w > $BWLOG &
IFSTATID=$!

# remember to cleanup and kill ifstat
trap ctrl_c INT

function ctrl_c() {
  echo "Killing ifstat ($IFSTATID) and stopping"
  kill $IFSTATID
  exit
}
sleep $TIMES
while true;do
  TOTALUPLOAD=0
  TOTALDOWNLOAD=0
  for i in $(tail -n $TIMES $BWLOG | cut -d\. -f 1); do
    let TOTALUPLOAD=$TOTALUPLOAD+$i
  done
  BWUP=$(echo $TOTALUPLOAD | awk -v "TIMES=$TIMES" '{printf "%.2f\n", $1 / TIMES / 1000}')
  curl -d '{ "auth_token": "XXXXXXXXX", "value": '$BWUP' }' http://belltv.bellcom.dk:3031/widgets/bandwidthup
  for i in $(tail -n $TIMES $BWLOG | cut -c 10-18 | cut -d\. -f 1); do
    let TOTALDOWNLOAD=$TOTALDOWNLOAD+$i
  done
  BWDOWN=$(echo $TOTALDOWNLOAD | awk -v "TIMES=$TIMES" '{printf "%.2f\n", $1 / TIMES / 1000}')
  curl -d '{ "auth_token": "XXXXXXXXX", "value": '$BWDOWN' }' http://belltv.bellcom.dk:3031/widgets/bandwidthdown
  sleep $WAITTIME
done

