#!/bin/sh
#wang.xiping modified 20070728
#wang.junpeng modified 20080604
#mount.sh [prod.tar]

printf "NGES Trade system product mount\n\n"

PATH=$PATH:~/shell

if [ $# -lt 1 ]
then
	printf "Please input product filename[prod.tar]:"
	read -r ResourceFile
	if [ "$ResourceFile" = "" ]
	then
		ResourceFile="prod.tar"
	fi
else
	ResourceFile=$1
fi

BasePath=`getcfg.sh BasePath`
AllPathResourceFile=${BasePath}$ResourceFile

if [ ! -r $AllPathResourceFile ]
then
	echo Error:$AllPathResourceFile can not open!
	exit 1
fi

LocalObjectPath=`getcfg.sh LocalObjectPath`
if [ "$LocalObjectPath" = "" ]
then
	echo Error: LocalObjectPath not set
    exit 1
fi

if [ ! -r ${LocalObjectPath} ]
then
    mkdir -p ${LocalObjectPath}
fi

InstallVersion=`tar tf ${AllPathResourceFile} |head -n 1|awk -F "/" '{printf "%s",$1}'`

CurrentVersion=`getcfg.sh CurrentVersion`
if [ "$CurrentVersion" = "" -o ! -r ${LocalObjectPath}${CurrentVersion} ]
then
    printf "direct untar the package...\n"
    cd ${LocalObjectPath} 2>/dev/null
    tar xvf $AllPathResourceFile
else
    #backup old ini files
    printf "retain the ini files and replace the obj files\n"
    printf "1.save the old ini files...\n"
    cd ${LocalObjectPath}${CurrentVersion} 2>/dev/null
    find . -type f -a -name "*.ini" -print | xargs tar cvf ${LocalObjectPath}ini_${CurrentVersion}.tar
    #release object files
    printf "2.untar the release files...\n"
    cd ${LocalObjectPath} 2>/dev/null
    tar xvf $AllPathResourceFile
    #restore the old ini files
    printf "3.restore the old ini files...\n"
    cd ${LocalObjectPath}${InstallVersion} 2>/dev/null
    tar xvf ../ini_${CurrentVersion}.tar
    rm -f ${LocalObjectPath}ini_${CurrentVersion}.tar 2>/dev/null
fi

setcfg.sh CurrentVersion $InstallVersion

#生成标志文件，表示本机已mount成功
>/tmp/mf.mounted 2> /dev/null
#判断是否为远程主机
if [ -r /tmp/mf.remote ]
then
        rm -f /tmp/mf.remote
else
    SH=`getcfg.sh SH`
    CP=`getcfg.sh CP`
    SH_ARG=`getcfg.sh SH_ARG`
    ConfigServices=`getcfg.sh ConfigServices`
    echo ConfigService:$ConfigServices
    for ConfigService in $ConfigServices
    do
        echo ... $ConfigService
        $SH $ConfigService $SH_ARG [ -r /tmp/mf.mounted ]
        if [ $? -ne 0 ]
        then
            echo "mount for config:" $ConfigService
    		$CP $AllPathResourceFile $ConfigService:.
            ConfigPath=`getcfg.sh LocalConfigPath`
            $CP -r -p ${ConfigPath} $ConfigService:${ConfigPath}
    		#生成远程copy标志，表示远程主机已复制安装包
    		$SH $ConfigService $SH_ARG echo ">" /tmp/mf.remote >/dev/null 2>/dev/null
    		$SH $ConfigService ${BasePath}shell/mount.sh $ResourceFile $CurrentVersion
    	    echo "Config Server " $ConfigService " mounted!"
        fi
    done
    echo "Config Server Local mounted!"
fi

rm -f /tmp/mf.mounted 2> /dev/null
