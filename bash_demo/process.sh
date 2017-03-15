#!/bin/bash

# first
n=$((100/10))
N=$((100/20))
for i in `seq 500`
do
    sleep 0.1
    [ $(($i%$n)) -eq 0 ] && echo -ne "\E[5m\b=\E[0m" && continue
    [ $(($i%$N)) -eq 0 ] && echo -ne "-"
done
echo ""

# second
set +x
b=''
i=0
while [ $i -le  100 ]
do
    printf "progress:[%-50s]%d%%\r" $b $i
    sleep 0.1
    i=`expr 2 + $i`
    b=#$b
done
echo
#third
i=0
while [ $i -lt 100 ]
do
    for j in '-' '\' '|' '/'
    do
        printf "testing : %s\r" $j
        sleep 0.1
        ((i++))
    done
done
echo
#fouth
COUNTER=0
_R=0
_C=`tput cols`
_PROCEC=`tput cols`
tput cup $_C $_R
printf "["
while [ $COUNTER -lt 100 ]
do
    COUNTER=`expr $COUNTER + 1`
    sleep 0.1
    printf "=>"
    _R=`expr $_R + 1`
    _C=`expr $_C + 1`
    tput cup $_PROCEC 101
    printf "]%d%%" $COUNTER
    tput cup $_C $_R
done
printf "\n"

