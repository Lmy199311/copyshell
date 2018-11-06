#!/bin/sh
#wangxiping modified 20070824

pwd=`getcfg.sh passwd`
if [ "$pwd" != "" ]
then
	printf "Please input passwd:\n"
        stty -echo
	read inpwd
	 #modified by liao.yh to envoid to input password
        #inpwd="123456"
	stty echo
	if [ "$inpwd" = "$pwd" ]
	then
		ecall.sh stopservice $*
		if [ $# -eq 0 ]
		then
#			backup.sh $* 
			echo
		fi
	else

		echo "invalid passewd!"
	fi
else
	ecall.sh stopservice $*
	if [ $# -eq 0 ]
	then
#		backup.sh $* 
		echo
	fi
fi
