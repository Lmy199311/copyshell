MDPATH=$HOME/tkernel1/dump/MarketData.csv
cat $MDPATH |awk -F"," '
	BEGIN {
		no=0
	}
	{ 
		if ( no> 0)
			printf "%s,today,%s,%s,%s\n",$22,$4,$5,$13
		no++
	}' 

SyslogPath=/home/PTrade/tkernel1/dump/Syslog.log
grep "TradeSize " $SyslogPath |awk '
	{
		cnt=$8
	}
	END {
		printf "zTrade,today,,,%d\n",$8
	}'
grep "OrderSize " $SyslogPath |awk '
	{
		cnt=$8
	}
	END {
		printf "zOrder,today,,,%d\n",$8
	}'
