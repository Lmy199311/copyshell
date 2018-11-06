SH=`getcfg.sh SH`
if [ $# -eq 0 ]
then
	$SH tmdb ./$0 tmdb
else
	SYSLOGFILE=/home/PTrade/$1/dump/Syslog.log
	today=`date +"%b %d"`
	grep "$today" $SYSLOGFILE |grep DataSyncCheckError || echo "tinit data is OK."
fi


