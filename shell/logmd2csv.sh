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
