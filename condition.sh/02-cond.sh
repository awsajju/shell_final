#!/bin/bash

echo "Enter the number"

read Num

if [ $Num -gt 0 ]; then
    echo "given number positive"
elif [ $Num == 0 ]; then
    echo "given number is zero"
else
    echo "given number is negative"

fi