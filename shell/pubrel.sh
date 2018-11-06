#!/bin/sh
#打包发布
#Editor: 王君鹏
#date  : 2008-06-04
#####################################################

LocalReleasePath=`getcfg.sh LocalReleasePath`
LocalObjectPath=`getcfg.sh LocalObjectPath`
LocalConfigPath=`getcfg.sh LocalConfigPath`
CurrentVersion=`getcfg.sh CurrentVersion`

if [ "$LocalReleasePath" = "" ]
then
    #set the defult directory
    LocalReleasePath=$HOME/release
fi

if [ -d ${LocalReleasePath}/${CurrentVersion} ]
then
	rm -Rf ${LocalReleasePath}/${CurrentVersion}/*
else
	mkdir -p ${LocalReleasePath}/${CurrentVersion}
fi

#打包执行文件
printf "1.package run files...\n"
cd $LocalObjectPath
find $CurrentVersion -type f -a ! -name "*.ini.md5" -print | xargs tar cvf ${LocalReleasePath}/${CurrentVersion}/run_${CurrentVersion}.tar
#打包config文件
printf "2.package config files...\n"
cd $LocalConfigPath
tar cvf ${LocalReleasePath}/${CurrentVersion}/config_${CurrentVersion}.tar *.xml
