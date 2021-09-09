#!/bin/bash


# the first argument is a 4 digit date code which corresponds with the file name eg: 0310
# the Second argument is a 2 digit time code followed by either am or pm eg: 05am
# the third argument is a number ranging from 1 - 3 which determines the game type, they are as follows; 1=Blackjack, 2=Roulette, 3=Texas Hold'em


if (($3 == 1))
then
	sed 's/:00:00 //' $1_Dealer_schedule | grep -iE $2 | awk -F'[\t]' '{print $1,$2}'
fi
if (($3 == 2))
then
	sed 's/:00:00 //' $1_Dealer_schedule | grep -iE $2 | awk -F'[\t]' '{print $1,$3}'
fi
if (($3 == 3))
then
	sed 's/:00:00 //' $1_Dealer_schedule | grep -iE $2 | awk -F'[\t]' '{print $1,$4}'
fi
