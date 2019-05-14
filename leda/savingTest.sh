#!/bin/bash

read input < lastRoteiro.txt

((input++))

if [ $input -lt 10 ];
    then
        roteiroName="R0"$input"-01";
else
    roteiroName="R"$input"-01";
fi

echo $input > lastRoteiro.txt