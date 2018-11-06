#!/bin/sh
#wang.xiping modified 20070727

CFGFILE=$HOME/shell/sh.cfg
TempSh=/tmp/setcfg.$$

if [ $# -gt 2 ]
then
	CFGFILE=$3
fi

if [ $# -lt 2 ]
then
	printf "Usage: $0 var value [configfilename]\n"
	exit 1
fi

if [ -r $CFGFILE ]
then
	cat $CFGFILE|awk -F"=" -v Name=$1 -v Value=$2 '
	BEGIN {
		flag=0
	}
	{
		if ( Name == $1 )
		{
			printf "%s=%s\n",$1,Value
			flag=1
		}
		else
		{
			for ( i=1 ;i<=NF;i++)
			{
				if (i>1)
					printf "=%s",$i
				else
					printf "%s",$i
			}
			printf "\n"
		}
	}
	END {
		if ( flag == 0 )
			printf "%s=%s\n",Name,Value
	}'> $TempSh
	mv $TempSh $CFGFILE
fi
