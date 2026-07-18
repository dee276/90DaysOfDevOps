#!/bin/bash

read -p "Enter a number: " NUMBER

if [ "$NUMBER" -gt 0 ]; then
  echo "$NUMBER is positive"
elif [ "$NUMBER" -lt 0 ]; then
  echo "$NUMBER is negative"
else
  echo "$NUMBER is zero"
fi
