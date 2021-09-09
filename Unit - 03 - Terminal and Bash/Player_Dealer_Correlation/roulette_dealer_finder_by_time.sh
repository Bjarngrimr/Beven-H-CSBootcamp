#!/bin/bash

# the first argument is a 4 digit date code which corresponds with the file name eg: 0310
# the Second argument is a 2 digit time code followed by either am or pm eg: 05am

sed 's/:00:00 //' $1_Dealer_schedule | grep -iE $2 | awk -F'[\t]' '{print $1,$3}'
