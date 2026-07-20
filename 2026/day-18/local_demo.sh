#!/bin/bash
default_vars() {
  var="global"
}
local_vars() {
  local var="local"
  echo "Inside function: $var"
}

default_vars
local_vars

echo "Outside function: $var"
