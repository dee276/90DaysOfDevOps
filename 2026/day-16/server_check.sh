#!/bin/bash

SERVICE_NAME="nginx"

read -p "Do you want to check the status of $SERVICE_NAME? (y/n): " ANSWER

if [ "$ANSWER" = "y" ] || [ "$ANSWER" = "Y" ]; then
  if ! command -v systemctl >/dev/null 2>&1; then
    echo "systemctl is not available in this environment"
    exit 1
  fi

  if systemctl is-active --quiet "$SERVICE_NAME"; then
    echo "$SERVICE_NAME is active"
  else
    echo "$SERVICE_NAME is not active"
    systemctl status "$SERVICE_NAME" --no-pager
  fi
elif [ "$ANSWER" = "n" ] || [ "$ANSWER" = "N" ]; then
  echo "Skipped."
else
  echo "Invalid answer. Please enter y or n."
  exit 1
fi
