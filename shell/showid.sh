if [ $# -eq 0 ]
then
	LOGFILE=log.txt
else
	LOGFILE=/home/PTrade/$1/dump/log.txt
fi

getMinVolume()
{
	grep "^CurrInstrumentProperty" $1 |awk -F"," '{
			printf "%s,%s,%s,%s,%04d\n",$1,$22,$24,$30,FNR
		}'
}

getPriceBanding()
{
	grep "^CurrPriceBanding" $1 |awk -F"," '{
			printf "%s,%s,%s,%s,%04d\n",$1,$14,$12,$16,FNR
		}'
}

getMarginRateDetail()
{
	grep "^CurrMarginRateDetail" $1 |grep "TradingRole,1" |awk -F"," '{
			printf "%s,%s,%s,%s,%04d\n",$1,$14,$12,$16,FNR
		}'
}

getInstProperty()
{
	TempFile=/tmp/shid.$$
	getPriceBanding $1 > $TempFile
	getMarginRateDetail $1 >> $TempFile
	getMinVolume $1 >> $TempFile
	sort -t , -k 4,5 $TempFile |awk -F"," '
		BEGIN {
			instid=""
			preinstid=""
			no=0
		}
		{
			instid=$4
			if ( instid != preinstid )
			{
				no+=1
				a_inst[no]=instid
				preinstid=instid
			}
			if ( $1 == "CurrPriceBanding" )
			{
				a_upper[no]=$2
				a_lower[no]=$3
			}
			if ( $1 == "CurrMarginRateDetail" )
			{
				a_long[no]=$2
				a_short[no]=$3
			}
			if ( $1 == "CurrInstrumentProperty" )
			{
				a_minvol[no]=$3
			}
		}
		END {
			printf "%10s %10s %10s %10s %10s %10s\n","Instrument","Upper","Lower","Long","Short","MinVol"
			for (i=1;i<=no;i++)
			{
				if (i>1 && substr(a_inst[i],1,2) != substr(a_inst[i-1],1,2))
					printf "\n"
				printf "%-10s %10.3f %10.3f %10.3f %10.3f %10s\n",a_inst[i],a_upper[i],a_lower[i],a_long[i],a_short[i],a_minvol[i]
			}
		}'
	rm $TempFile 2>/dev/null
}

if [ -f $LOGFILE ]
then
	getInstProperty $LOGFILE
else
	SH=`getcfg.sh SH`
	$SH tkernel1 ./tkernel1/shell/showid.sh tkernel1
fi
	
