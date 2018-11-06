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
		
		echo -e "����sh.cfg�е�������checkwd��checkstartperiod��checkrestartperiod"
		exit
	else 
		doublecheck="yes"
	fi
fi 



if [ $# -eq 0 ]
then
echo "ѡ�����"
echo "---------------------"
echo "1000.������������"
echo "2000.����CSV����"
echo "3000.������������"
echo "4000.����CSV����"
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
				echo -e "��ǰʱ��Ϊ$curtime, ��ѡ��������\n"
				read -n1 -p "������س�����"
			elif [ $checkstart1 -gt $checkstart2  -a $checkstart1 -gt $curhour -a $curhour -gt $checkstart2  ]
			then 
				echo -e "��ǰʱ��Ϊ$curtime, ��ѡ��������\n"
				read -n1 -p "������س�����"
			else
				echo -e "��ǰʱ��Ϊ$curtime, ��ѡ��������\n"
				if [ "$checkwd" != "" ]
				then
					echo -e "�����쳣���������֤��:\n"
					stty -echo
					read incheckwd
					stty echo
					if [ "$incheckwd" = "$checkwd" ]
					then
							echo -e "У��ͨ��\n"
					else
							echo -e "��֤������ʧ�ܣ��˳���\n"
							exit
					fi
				fi
			fi 
	
		elif [ $abc -eq 3000 -o $abc -eq 4000 ]
		then

	
				if [ $checkrestart1 -le $checkrestart2  ] && [ $checkrestart1 -gt $curhour -o $curhour -gt $checkrestart2  ] 
				then 
					echo -e "��ǰʱ��Ϊ$curtime, ��ѡ���˴���\n"
					read -n1 -p "������س�����"
				elif [ $checkrestart1 -gt $checkrestart2  -a $checkrestart1 -gt $curhour -a $curhour -gt $checkrestart2  ]
				then 
					echo -e "��ǰʱ��Ϊ$curtime, ��ѡ���˴���\n"
					read -n1 -p "������س�����"
				else
					echo -e "��ǰʱ��Ϊ$curtime, ��ѡ���˴���\n"
					if [ "$checkwd" != "" ]
					then
						echo -e "�����쳣���������֤��:\n"
						stty -echo
						read incheckwd
						stty echo
						if [ "$incheckwd" = "$checkwd" ]
						then
								echo -e "У��ͨ��\n"
						else
								echo -e "��֤������ʧ�ܣ��˳���\n"
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
		echo -e "��ȷ�ϵ�ǰʱ��"$date"������~/shell/list��tinit��tmdb��dbmt�������Ƿ����������������Ҫ��\n"
		read -n1 -p "������س�����"	
		start=startservice
		if [ "$tinit" != "" ] 
		then
			echo -e "����~/shell/list�з������ݿ����tinit���ã���ǰ���ò����ϴ�������Ҫ��\n"
			exit
		fi	
	elif [ $abc -eq 2000 ]
	then
		echo -e "��ȷ�ϵ�ǰʱ��"$date"������~/shell/list��tinit��tmdb��dbmt�����÷��������CSV����Ҫ��\n"
		read -n1 -p "������س�����"
		start=startservice
		if [ "$tinit" == "" ]
		then
			echo -e "����~/shell/list�з������ݿ����tinit��tmdb��dbmt���ã���ǰ���ò���������CSV����Ҫ��\n"
			exit
		fi
	elif [ $abc -eq 3000 ]
	then	
		echo -e "����~/shell/list��tinit��tmdb��dbmt���÷���ϴ�����������Ҫ��\n"
		read -n1 -p "������س�����"
		start=restart	
		if [ "$tinit" != "" ]
		then
			echo -e "����~/shell/list�з������ݿ����tinit��tmdb��dbmt���ã���ǰ���ò����ϴ�������Ҫ��\n"
			exit
		fi
	elif [ $abc -eq 4000 ]
	then
		echo -e "����~/shell/list��tinit��tmdb��dbmt���÷���ϴ���CSV����Ҫ��\n"
		read -n1 -p "������س�����"
		start=restart
		if [ "$tinit" == "" ]
		then
			echo -e "����~/shell/list�з������ݿ����tinit��tmdb��dbmt���ã���ǰ���ò�����CSV����Ҫ��\n"
			exit
		fi
	else
		exit
	fi
else
	if [ $abc -eq 1000 ]
	then
		echo -e "��ȷ�ϵ�ǰʱ��"$date"������~/shell/list��riskgate��ǰ�����Ƿ���ϴ�������Ҫ��\n"
		read -n1 -p "������س�����"	
		start=startservice
		if [ "$risk" != "riskgate" ] 
		then
			echo -e "����~/shell/list��riskgate���ã���ǰ���ò����ϴ�������Ҫ��\n"
			exit
		fi	
	elif [ $abc -eq 2000 ]
	then
		echo -e "��ȷ�ϵ�ǰʱ��"$date"������~/shell/list��riskgate��ǰ�����Ƿ��������CSV����Ҫ��\n"
		read -n1 -p "������س�����"
		start=startservice
		if [ "$risk" != "riskgate--csv" ]
		then
			echo -e "����~/shell/list��riskgate���ã���ǰ���ò���������CSV����Ҫ��\n"
			exit
		fi
	elif [ $abc -eq 3000 ]
	then	
		echo -e "����~/shell/list��riskgate��ǰ�����Ƿ���ϴ�����������Ҫ��\n"
		read -n1 -p "������س�����"
		start=restart
		if [ "$risk" != "riskgate" ]
		then
			echo -e "����~/shell/list��riskgate���ã���ǰ���ò����ϴ�������Ҫ��\n"
			exit
		fi
	elif [ $abc -eq 4000 ]
	then
		echo -e "����~/shell/list��riskgate��ǰ�����Ƿ���ϴ���CSV����Ҫ��\n"
		read -n1 -p "������س�����"
		start=restart
		if [ "$risk" != "riskgate--csv" ]
		then
			echo -e "����~/shell/list��riskgate���ã���ǰ���ò�����CSV����Ҫ��\n"
			exit
		fi
	else
		exit
	fi
 fi	



else 
    echo "1000.��������"
    echo "2000.��������"
    read dce
	
	if [ "$doublecheck" == "yes" ]
	then
		if [ $dce -eq 1000  ]
			then 
			
				
				if [ $checkstart1 -le $checkstart2  ] && [ $checkstart1 -gt $curhour -o $curhour -gt $checkstart2  ] 
				then 
					echo -e "��ǰʱ��Ϊ$curtime, ��ѡ��������\n"
					read -n1 -p "������س�����"
				elif [ $checkstart1 -gt $checkstart2  -a $checkstart1 -gt $curhour -a $curhour -gt $checkstart2  ]
				then 
					echo -e "��ǰʱ��Ϊ$curtime, ��ѡ��������\n"
					read -n1 -p "������س�����"
				else
					echo -e "��ǰʱ��Ϊ$curtime, ��ѡ��������\n"
					if [ "$checkwd" != "" ]
					then
						echo -e "�����쳣���������֤��:\n"
						stty -echo
						read incheckwd
						stty echo
						if [ "$incheckwd" = "$checkwd" ]
						then
								echo -e "У��ͨ��\n"
						else
								echo -e "��֤������ʧ�ܣ��˳���\n"
								exit
						fi
					fi
				fi 
	
		elif [ $dce -eq 2000  ]
		then
	
				if [ $checkrestart1 -le $checkrestart2  ] && [ $checkrestart1 -gt $curhour -o $curhour -gt $checkrestart2  ] 
				then 
					echo -e "��ǰʱ��Ϊ$curtime, ��ѡ���˴���\n"
					read -n1 -p "������س�����"
				elif [ $checkrestart1 -gt $checkrestart2  -a $checkrestart1 -gt $curhour -a $curhour -gt $checkrestart2  ]
				then 
					echo -e "��ǰʱ��Ϊ$curtime, ��ѡ���˴���\n"
					read -n1 -p "������س�����"
				else
					echo -e "��ǰʱ��Ϊ$curtime, ��ѡ���˴���\n"
					if [ "$checkwd" != "" ]
					then
						echo -e "�����쳣���������֤��:\n"
						stty -echo
						read incheckwd
						stty echo
						if [ "$incheckwd" = "$checkwd" ]
						then
								echo -e "У��ͨ��\n"
						else
								echo -e "��֤������ʧ�ܣ��˳���\n"
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
		echo "����ѡ���������飡"
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

