#!/bin/bash
greet() {
  echo "Hello, $1!"
}
add() {
  echo "$(( $1 + $2 ))"
}
greet "DevOps"
echo "Sum: $(add 5 7)"
