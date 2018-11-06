#!/bin/sh
#wang.xiping modified 20070727

CFGFILE=$HOME/shell/sh.cfg
TempSh=/tmp/getcfg.$$

if [ $# -gt 1 ]
then
	CFGFILE=$2
fi

if [ $# -lt 1 ]
then
	printf ""
fi

if [ -r $CFGFILE ]
then
	export ARG=$1
	cat $CFGFILE|awk -F"=" '
	BEGIN {
		argvalue=""
		argname=ENVIRON["ARG"]
	}
	{
		if ( argname == $1 )
			argvalue=$2
	}
	END {
		printf "printf \"%s\"",argvalue
	}'>> $TempSh
	chmod +x $TempSh
	$TempSh
fi
rm -rf $TempSh 2>/dev/null
