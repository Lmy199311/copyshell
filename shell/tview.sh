SH=`getcfg.sh SH`
if [ $# -gt 0 ]
then
	tv.sh -l $*
	echo "<<<<<<>>>>>>"
	tcount.sh
else
	$SH tmdb ./tv.sh tmdb $*
	echo ">>>>>>>><<<<<<<<"
	$SH tmdb ./tcount.sh tmdb 
fi
