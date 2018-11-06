#!/bin/sh
#wang.xiping modify  20070726

LocalBackupPath=`getcfg.sh LocalBackupPath`
LocalTempBackupPath=`getcfg.sh LocalBackupPath`

if [ ! -d $LocalBackupPath ]
then
	echo Error: can not open path [$LocalBackupPath]
	return
fi

cd $LocalBackupPath 

BAKPATH=`date +%C%y%m%d-%H%M%S`
mkdir $BAKPATH
cd $BAKPATH

echo backup to $LocalBackupPath$BAKPATH
rm -f $LocalTempBackupPath/*gz

echo Get data from remote computer...
ecall.sh backup $*

#cp -r $LocalBackupPath/$BAKPATH/front* /home/data/archive
#cp -r $LocalBackupPath/$BAKPATH/tkernel1 /home/data/archive

echo Upload data to ftp server...
#up.sh

echo Backup completed!
