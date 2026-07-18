#!/bin/bash

read -p "Enter a filename: " FILENAME

if [ -f "$FILENAME" ]; then
  echo "$FILENAME exists and is a regular file"
else
  echo "$FILENAME does not exist or is not a regular file"
fi
