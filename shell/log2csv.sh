logfile=$HOME/tmdb/dump/log.txt
logfile=log.txt
case $# in
1)
	table=$1
	primarykey=`getcfg.sh $table memkeydef`
	;;
2)
	table=$1
	primarykey="$2"
	;;
3)
	table=$1
	primarykey="$2"
	logfile=$3
	;;
*)
	echo $0 memorytablename ["primarykey" [logfile] ]
	;;
esac

if [ "$primarykey" =  "null" ]
then
	primarykeycnt=0
else
	echo $primarykey|tr -s ',' ' '|wc -w|read -r primarykeycnt
fi
export primarykey
export primarykeycnt

grep "^${table}," $logfile |awk -F"," '
	BEGIN {
		no=0
		pkcnt=ENVIRON["primarykeycnt"]
		pk=ENVIRON["primarykey"]
		split(pk,a_pkname)
		pres=""
	}
	{
		no++
		s=$4
		for ( i=6;i<=NF;i+=2)
			s=sprintf("%s,%s",s,$i)
		if ( no == 1)
		{
			hs=$3
			for ( i=5;i<=NF;i+=2)
			hs=sprintf("%s,%s",hs,$i)
			printf "%s\n",hs
			for (i=3;i<=NF;i+=2)
				for (j=1;j<=pkcnt;j++)
				{
					if ( a_pkname[j] == $i )
						a_pkno[j] = i+1
				}
				
		}
		same=1
		for ( i=1;i<=pkcnt;i++)
		{
			fno=a_pkno[i]
			prekeyvalue=a_prepkvalue[i]
			if (prekeyvalue != $fno )
			{
				same=0
			}
			a_prepkvalue[i] = $fno 
		}	
		if (no!=1&&(pkcnt ==0 || same == 0))
			printf "%s\n",pres
		pres=s
	}
	END {
		printf "%s\n",pres
	}'
	#> ${table}.csv

