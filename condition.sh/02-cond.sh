#!/bin/bash

echo "Emter the number"

read Num

if [ $Num -gt 0 ]; then
    echo "given number positive"
else
    echo "given number is negative"
elif [ $Num == 0 ]; then
    echo "given number is zero"

fi