#!/bin/sh
#wang.xiping modified 20070728

checkfile=$HOME/shell/sh.cfg 
rm -f .checkck
rm -f .checkst
rm -f .checkrst
cat $checkfile | grep "checkwd=" | grep -v "^#" >/dev/null && > .checkck
cat $checkfile | grep "cstperiod=" | grep -v "^#" >/dev/null && > .checkst
cat $checkfile | grep "crstperiod=" | grep -v "^#" >/dev/null && > .checkrst


curhour=`date +%H`
curtime=`date +%H:%M`
checkwd=`getcfg.sh checkwd`

cstperiod=`getcfg.sh checkstartperiod`
crstperiod=`getcfg.sh checkrestartperiod`

array_checkstart=(${cstperiod//-/ })
array_checkrestart=(${crstperiod//-/ })
checkstart1tmp=${array_checkstart[0]}
checkstart2tmp=${array_checkstart[1]}
checkrestart1tmp=${array_checkrestart[0]}
checkrestart2tmp=${array_checkrestart[1]}


checkstart1=${checkstart1tmp% }
checkstart2=${checkstart2tmp%}
checkrestart1=${checkrestart1tmp%}
checkrestart2=${checkrestart2tmp%}

doublecheck="no"

if [ -r .checkck ] || [ -r .checkst ] || [ -r .checkrst ]
then 
	if [ "$checkwd" = "" -o "$checkstart1" = "" -o "$checkstart2" = "" -o "$checkrestart1"  = "" -o "$checkrestart2" = "" ]
	then 
		
		echo -e "请检查sh.cfg中的配置项checkwd、checkstartperiod、checkrestartperiod"
		exit
	else 
		doublecheck="yes"
	fi
fi 



if [ $# -eq 0 ]
then
echo "选择操作"
echo "---------------------"
echo "1000.清流带库启动"
echo "2000.清流CSV启动"
echo "3000.带流带库启动"
echo "4000.带流CSV启动"
echo "---------------------"

read abc


        tinit=`grep -v "^#" ~/shell/list | grep tinit| grep csv`
        risk=`grep -v "^#" ~/shell/list | grep riskgate| awk  '{print $1$3}' `
        date=`date`

	if [ "$doublecheck" == "yes" ]
	then
		if [ $abc -eq 1000 -o $abc -eq 2000 ]
		then 
			
	
			if [ $checkstart1 -le $checkstart2  ] && [ $checkstart1 -gt $curhour -o $curhour -gt $checkstart2  ] 
			then 
				echo -e "当前时间为$curtime, 您选择了清流\n"
				read -n1 -p "请输入回车继续"
			elif [ $checkstart1 -gt $checkstart2  -a $checkstart1 -gt $curhour -a $curhour -gt $checkstart2  ]
			then 
				echo -e "当前时间为$curtime, 您选择了清流\n"
				read -n1 -p "请输入回车继续"
			else
				echo -e "当前时间为$curtime, 您选择了清流\n"
				if [ "$checkwd" != "" ]
				then
					echo -e "操作异常，请出入验证码:\n"
					stty -echo
					read incheckwd
					stty echo
					if [ "$incheckwd" = "$checkwd" ]
					then
							echo -e "校验通过\n"
					else
							echo -e "验证码输入失败，退出！\n"
							exit
					fi
				fi
			fi 
	
		elif [ $abc -eq 3000 -o $abc -eq 4000 ]
		then

	
				if [ $checkrestart1 -le $checkrestart2  ] && [ $checkrestart1 -gt $curhour -o $curhour -gt $checkrestart2  ] 
				then 
					echo -e "当前时间为$curtime, 您选择了带流\n"
					read -n1 -p "请输入回车继续"
				elif [ $checkrestart1 -gt $checkrestart2  -a $checkrestart1 -gt $curhour -a $curhour -gt $checkrestart2  ]
				then 
					echo -e "当前时间为$curtime, 您选择了带流\n"
					read -n1 -p "请输入回车继续"
				else
					echo -e "当前时间为$curtime, 您选择了带流\n"
					if [ "$checkwd" != "" ]
					then
						echo -e "操作异常，请出入验证码:\n"
						stty -echo
						read incheckwd
						stty echo
						if [ "$incheckwd" = "$checkwd" ]
						then
								echo -e "校验通过\n"
						else
								echo -e "验证码输入失败，退出！\n"
								exit
						fi
					fi
				fi 	
				
		fi
	fi
	
if [ "$risk" == "" ]
then
	if [ $abc -eq 1000 ]
	then
		echo -e "请确认当前时间"$date"，请检查~/shell/list中tinit、tmdb、dbmt的配置是否符合清流带库启动要求\n"
		read -n1 -p "请输入回车继续"	
		start=startservice
		if [ "$tinit" != "" ] 
		then
			echo -e "请检查~/shell/list中访问数据库组件tinit配置，当前配置不符合带库启动要求\n"
			exit
		fi	
	elif [ $abc -eq 2000 ]
	then
		echo -e "请确认当前时间"$date"，请检查~/shell/list中tinit、tmdb、dbmt的配置否符合清流CSV启动要求\n"
		read -n1 -p "请输入回车继续"
		start=startservice
		if [ "$tinit" == "" ]
		then
			echo -e "请检查~/shell/list中访问数据库组件tinit、tmdb、dbmt配置，当前配置不符合清流CSV启动要求\n"
			exit
		fi
	elif [ $abc -eq 3000 ]
	then	
		echo -e "请检查~/shell/list中tinit、tmdb、dbmt配置否符合带流带库启动要求\n"
		read -n1 -p "请输入回车继续"
		start=restart	
		if [ "$tinit" != "" ]
		then
			echo -e "请检查~/shell/list中访问数据库组件tinit、tmdb、dbmt配置，当前配置不符合带库启动要求\n"
			exit
		fi
	elif [ $abc -eq 4000 ]
	then
		echo -e "请检查~/shell/list中tinit、tmdb、dbmt配置否符合带流CSV启动要求\n"
		read -n1 -p "请输入回车继续"
		start=restart
		if [ "$tinit" == "" ]
		then
			echo -e "请检查~/shell/list中访问数据库组件tinit、tmdb、dbmt配置，当前配置不符合CSV启动要求\n"
			exit
		fi
	else
		exit
	fi
else
	if [ $abc -eq 1000 ]
	then
		echo -e "请确认当前时间"$date"，请检查~/shell/list中riskgate当前配置是否符合带库启动要求\n"
		read -n1 -p "请输入回车继续"	
		start=startservice
		if [ "$risk" != "riskgate" ] 
		then
			echo -e "请检查~/shell/list中riskgate配置，当前配置不符合带库启动要求\n"
			exit
		fi	
	elif [ $abc -eq 2000 ]
	then
		echo -e "请确认当前时间"$date"，请检查~/shell/list中riskgate当前配置是否符合清流CSV启动要求\n"
		read -n1 -p "请输入回车继续"
		start=startservice
		if [ "$risk" != "riskgate--csv" ]
		then
			echo -e "请检查~/shell/list中riskgate配置，当前配置不符合清流CSV启动要求\n"
			exit
		fi
	elif [ $abc -eq 3000 ]
	then	
		echo -e "请检查~/shell/list中riskgate当前配置是否符合带流带库启动要求\n"
		read -n1 -p "请输入回车继续"
		start=restart
		if [ "$risk" != "riskgate" ]
		then
			echo -e "请检查~/shell/list中riskgate配置，当前配置不符合带库启动要求\n"
			exit
		fi
	elif [ $abc -eq 4000 ]
	then
		echo -e "请检查~/shell/list中riskgate当前配置是否符合带流CSV启动要求\n"
		read -n1 -p "请输入回车继续"
		start=restart
		if [ "$risk" != "riskgate--csv" ]
		then
			echo -e "请检查~/shell/list中riskgate配置，当前配置不符合CSV启动要求\n"
			exit
		fi
	else
		exit
	fi
 fi	



else 
    echo "1000.清流启动"
    echo "2000.带流启动"
    read dce
	
	if [ "$doublecheck" == "yes" ]
	then
		if [ $dce -eq 1000  ]
			then 
			
				
				if [ $checkstart1 -le $checkstart2  ] && [ $checkstart1 -gt $curhour -o $curhour -gt $checkstart2  ] 
				then 
					echo -e "当前时间为$curtime, 您选择了清流\n"
					read -n1 -p "请输入回车继续"
				elif [ $checkstart1 -gt $checkstart2  -a $checkstart1 -gt $curhour -a $curhour -gt $checkstart2  ]
				then 
					echo -e "当前时间为$curtime, 您选择了清流\n"
					read -n1 -p "请输入回车继续"
				else
					echo -e "当前时间为$curtime, 您选择了清流\n"
					if [ "$checkwd" != "" ]
					then
						echo -e "操作异常，请出入验证码:\n"
						stty -echo
						read incheckwd
						stty echo
						if [ "$incheckwd" = "$checkwd" ]
						then
								echo -e "校验通过\n"
						else
								echo -e "验证码输入失败，退出！\n"
								exit
						fi
					fi
				fi 
	
		elif [ $dce -eq 2000  ]
		then
	
				if [ $checkrestart1 -le $checkrestart2  ] && [ $checkrestart1 -gt $curhour -o $curhour -gt $checkrestart2  ] 
				then 
					echo -e "当前时间为$curtime, 您选择了带流\n"
					read -n1 -p "请输入回车继续"
				elif [ $checkrestart1 -gt $checkrestart2  -a $checkrestart1 -gt $curhour -a $curhour -gt $checkrestart2  ]
				then 
					echo -e "当前时间为$curtime, 您选择了带流\n"
					read -n1 -p "请输入回车继续"
				else
					echo -e "当前时间为$curtime, 您选择了带流\n"
					if [ "$checkwd" != "" ]
					then
						echo -e "操作异常，请出入验证码:\n"
						stty -echo
						read incheckwd
						stty echo
						if [ "$incheckwd" = "$checkwd" ]
						then
								echo -e "校验通过\n"
						else
								echo -e "验证码输入失败，退出！\n"
								exit
						fi
					fi
				fi 	
				
		fi
	fi
	
	
	if [ $dce -eq 1000 ]
	then
		start=startservice
	elif [ $dce -eq 2000 ]
	then 
		start=restart
	else
		echo "您的选择有误，请检查！"
		exit
	fi	
	
fi

pwd=`getcfg.sh passwd`
starttime=`getcfg.sh starttime`
if [ "$starttime" != "" ]
then
	echo	 start time is $starttime ",continue ?"
	read con
	if [ "$con" != "y" ]
	then
		exit 
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
			ecall.sh $start -n ofpmd
		else			
			ecall.sh $start $*
		fi
	else
		echo "invalid passewd!"
	fi
else
	if [ $# -eq 0 ]
	then
		ecall.sh $start -n ofpmd
	else			
		ecall.sh $start $*
	fi
fi

