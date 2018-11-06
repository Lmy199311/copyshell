#!/bin/sh 
#wang.xiping modified 20070727

if [ $# -gt 0 ]
then
	MenuFile=$1
	Title=`ecall.sh -c getbasename $1`
else
	MenuFile=`getcfg.sh MenuFile`
	Title="交易系统控制台"
fi

if [ "${MenuFile}" = "" ]
then
	echo Error:Console menu file is not set!
	return
fi

if [ ! -r $MenuFile ]
then
	echo Error:Console menu file is not open!
	return
fi

max=`cat $MenuFile | wc -l`
awk -v max=$max -v Title=$Title -v ProgName=$0 -F"," '
	BEGIN {
		no=1	
		m=2
		n=10
		max++
		if (max > 20)
			div=2
		else
			div=1

		printf "\033[2J"
		printf "\033[1;30H%s",Title
		printf "\033[2;10H============================================================"
	}
	{
		no++
		a_name[no]=$1
    a_cmd[no]=$2
    a_info[no]=$3
    if ( index($2,ProgName) > 0 )
    	a_name[no]=sprintf("<%s>",$1)

		x=m+no/div
		y=n+(no%div)*40
		if (no==2)
			printf "\033[7m"
		if ( x<20)
		{
			printf "\033[%1d;%1dH%-3d %-20s",x,y,no-1,a_name[no]
		}				
		if (no==2)
			printf "\033[0m"
	}
	END {
		no=2
		preno=2
		printf "\033[%1d;%1dHPress 0 quit:",m+max/div+3,n
		for ( ;; )
		{
			printf "\033[%1d;%1dHcomment:%-60s",m+max/div+2,n,a_info[no]
			printf "\033[%1d;%1dH",m+max/div+3,n+15
			ret=system("getch.sh")
			if (ret<=max)
			{
				no=ret+1
			}
			if ( ret==250)
			{
				system(a_cmd[no])
				printf "\nAny key to continue!"
				system("getch.sh")
				printf "\033[2J"
				printf "\033[1;30H%s",Title
				printf "\033[2;10H============================================================"
				for (i=2;i<=max;i++)
				{
					if (i==no)
						printf "\033[7m"
					if ( m+i<24)
					{
						x=m+i/div
						y=n+(i%div)*40
						printf "\033[%1d;%1dH%-3d %-20s",x,y,i-1,a_name[i]
					}				
					if (i==no)
						printf "\033[0m"
				}
				printf "\033[%1d;%1dHPress 0 quit:",m+max/div+3,n
			}
			if ( ret==252 )
				no-=div
			if ( ret==255)
				no--
			if ( ret==253 )
				no++
			if ( ret==254)
				no+=div
			if ( no <= 1)
				no=max
			if ( no > max)
				no=2
			if ( ret== 0)
				break;
			if (no!=preno)
			{
				x=m+preno/div
				y=n+(preno%div)*40
				printf "\033[%1d;%1dH%-3d %-20s",x,y,preno-1,a_name[preno]
				printf "\033[7m"
				x=m+no/div
				y=n+(no%div)*40
				printf "\033[%1d;%1dH%-3d %-20s",x,y,no-1,a_name[no]
				printf "\033[0m"
				preno=no
			}
		}				
		printf "\n"
	}
	' $MenuFile 
