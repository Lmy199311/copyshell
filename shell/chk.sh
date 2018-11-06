CONN="sync/sync@db3"

chkimpl()
{
	echo check $1 ...
	expcsv.sh $CONN t_$1 "$2"
	sed 's/cu/XX/g' t_$1.csv > $1.cu
	cmd=`echo $2|sed 's/cu/zn/'`
	expcsv.sh $CONN t_$1 "$cmd"
	sed 's/zn/XX/g' t_$1.csv > $1.zn
	rm t_$1.csv
	diff $1.cu $1.zn
	echo "_______________________________________________________"
}

chkimpl Instrument "instrumentid like 'cu%' order by instrumentid"
chkimpl CurrInstrumentProperty "instrumentid like 'cu%' order by instrumentid"
chkimpl CurrTradingSegmentAttr "instrumentid like 'cu%' order by instrumentid,tradingsegmentsn"
chkimpl CurrPriceBanding "instrumentid like 'cu%' order by instrumentid"
chkimpl CurrMarginRateDetail "instrumentid like 'cu%' order by instrumentid,TradingRole,HedgeFlag"
chkimpl CurrPartPosiLimitDetail "instrumentid like 'cu%' order by instrumentid,ParticipantID"
chkimpl CurrClientPosiLimitDetail "instrumentid like 'cu%' order by instrumentid,ClientType"
chkimpl CurrHedgeRule "instrumentid like 'cu%' order by instrumentid"
chkimpl MarketData "instrumentid like 'cu%' order by instrumentid"
chkimpl PartInstrumentRight "instrumentid like 'cu%' order by instrumentid,Participantid"
chkimpl ClientInstrumentRight "instrumentid like 'cu%' order by instrumentid,clientid"

chkimpl CurrProductProperty "ProductID like 'cu%' order by ProductID"
chkimpl MartketProduct "ProductID 'cu%' order by ProductID,MarketID"
chkimpl MarketProductGroup "ProductGroupID like 'cu%' order by ProductGroupID"
chkimpl AliasDefine "ProductID like 'cu%' order by ProductID"
chkimpl PartProductRole "ProductID like 'cu%' order by ProductID,ParticipantID"
chkimpl PartProductRight "ProductID like 'cu%' order by ProductID,ParticipantID"
