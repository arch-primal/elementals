#!/bin/bash

if [[ ! -f /root/index  ]]; then
  echo -n 0 > /root/index
fi

while :
do
  index=$(cat /root/index)

  if (( "$index" == 75 )); then
    echo "b64: $(echo -n 'Talm-eetgn! Yhig feov: 4ew5t80te5w152t076r4015bv0tq4c1w' | base64)" >> /root/sender.logs
  fi

  if (( $(curl -s http://server | grep -vi error | wc -l) > 0)); then
    echo "$(date) - All right! $(($index + 1))" >> /root/sender.logs
    echo -n "$(($index + 1))" > /root/index
  else
    echo "$(date) - Error" >> /root/sender.logs
    echo -n 0 > /root/index
  fi

  sleep 5

  if (( $(cat /root/sender.logs | wc -l) > 300 )); then
    echo -n "" > /root/sender.logs
  fi
done
