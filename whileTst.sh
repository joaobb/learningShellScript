#!/bin/bash

x=5

while [ $x != -1 ];
  do
    sleep 1;
    echo $x
    (( x-- ))
  done
