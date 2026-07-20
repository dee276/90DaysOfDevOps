#!/bin/bash
if [ -z "$1" ]; then
  echo "Usage: ./countdown.sh <number>"
  exit 1
fi
n=$1
while [ "$n" -ge 0 ]; do
  echo "Countdown: $n"
  n=$((n - 1))
done
echo "Done!"
