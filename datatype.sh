#!/bin/bash
Num1=$1
Num2=$2
Timestamp=$(date)
echo "$Timestamp"
sum=$(($Num1+$Num2))

echo "$Num1 and $Num2 :" $sum