BASEPATH=$HOME
cntexpr=`wc -l $BASEPATH/bin/list |awk '{print $1}'`
cnt=`expr $cntexpr`

while true
do
	Time=`date +"%C%y%m%d %H:%M:%S"`
	result=`showall |tee -a /tmp/.show |wc -l`
	nCount=` expr $result - 1 `
	#echo $nCount
	if [ $nCount -eq $cnt ]
	then
		echo $Time "Trade System is running." |tee -a /tmp/.show
	fi
	if [ $nCount -eq 0 ]
	then
		echo $Time "Trade System is closed." |tee -a /tmp/.show
	else
		if [ $cnt -gt $nCount ]
		then
			echo $Time "Trade System is abnormal. running"  $nCount [$cnt] |tee -a /tmp/.show
		fi
	fi
	if [ $nCount -gt $cnt ]
	then
		echo $Time "Trade System is unknown." |tee -a /tmp/.show
	fi
	sleep 5
done

