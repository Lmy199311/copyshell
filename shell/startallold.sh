#!/bin/sh
#wang.xiping modified 20070728

pwd=`getcfg.sh passwd`
starttime=`getcfg.sh starttime`
if [ "$starttime" != "" ]
then
	echo	 start time is $starttime ",continue ?"
	read con
	if [ "$con" != "y" ]
	then
		return 
	fi
fi

if [ "$pwd" != "" ]
then
	printf "Please input passwd:\n"
	stty -echo
	read inpwd
	stty echo
	if [ "$inpwd" = "$pwd" ]
	then
		if [ $# -eq 0 ]
		then
			ecall.sh startservice -n ofpmd
		else			
			ecall.sh startservice $*
		fi
	else
		echo "invalid passewd!"
	fi
else
	if [ $# -eq 0 ]
	then
		ecall.sh startservice -n ofpmd
	else			
		ecall.sh startservice $*
	fi
fi

