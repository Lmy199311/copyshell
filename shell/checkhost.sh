#!/bin/sh
#wang.xiping modified 20070918

ServiceListFile=`getcfg.sh ServiceListFile`
HostListFile=/tmp/.hostlist.$$
grep -v "^#"  $ServiceListFile | awk '{
	if ( NF > 1 )
	{
		printf "%s%s ",$1,$2
	}
	else
	{
		printf "%s ",$1
	}
}' > $HostListFile

HostList=`cat $HostListFile` 
rm -f $HostListFile

for host in $HostList
do
	grep -v "^#" /etc/hosts|grep -w $host >/dev/null||echo Error: $host not found in the /etc/hosts
done

SH=`getcfg.sh SH`
OfferListFile=/tmp/.offerlist.$$
$SH tinit cat ./tinitdata/data/t_Trader.csv |awk -F"," '
	BEGIN { i=0 }
	{ 
		if ( i!=0 )
			printf "%s %s %s\n",substr($2,2,length($2)-2),substr($3,2,length($3)-2),substr($5,2,length($5)-2)
		i++
	}' > $OfferListFile
echo "end of file" >> $OfferListFile

IsOver="false"
while [ $IsOver = "false" ]
do
	read -r Party Offer InstCnt
	if [ ! "$Party" = "end" ]
	then
		Cnt=`grep -v "^#" $ServiceListFile|grep -w $Party|grep -w $Offer|wc -l`
		if [ ! "$Cnt" =  "$InstCnt" ]
		then
			echo Warnning: Party[$Party] Offer[$Offer] start count is $Cnt,should be $InstCnt
		fi
	else
		IsOver="true"
	fi
done < $OfferListFile
rm -f $OfferistFile
