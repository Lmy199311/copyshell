#!/bin/sh
#wang.xiping modified 20070727 

LocalBackupPath=`getcfg.sh LocalBackupPath`

cd $LocalBackupPath
for i in `ls`
do
	if [ -d $i ]
	then
		echo compressing $i
		gzip -f $i/*/*/*
		tar cvf $i.tar $i 2>/dev/null > /dev/null
	fi
done
