#!/bin/bash
cd `dirname $0`

count=0
while true; do
  count=$(expr $count + 1)
  terraform apply  -auto-approve
  ret_value=$?
  [ $ret_value -eq 0 ] && break
  echo "... was try $count"
  date
  sleep 300
done
