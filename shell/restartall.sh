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

#if [ $pwd != "" ]
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
#			ecall.sh startprobe >/dev/null 2>/dev/null
			ecall.sh restart -n ofpmd	#restart all program
		else			
			ecall.sh restart $*
		fi
	else
		echo "invalid passewd!"
	fi
else
	if [ $# -eq 0 ]
	then
#		ecall.sh startprobe >/dev/null 2>/dev/null
		ecall.sh restart -n ofpmd	#restart all program
	else			
		ecall.sh restart $*
	fi
fi

