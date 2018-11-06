#!/bin/sh
#wang.xiping modified 20070728

PATH=$PATH:$HOME/shell;export PATH

export ORACLE_BASE=`getcfg.sh ORACLE_BASE`
export ORACLE_HOME=`getcfg.sh ORACLE_HOME`
export NLS_LANG=`getcfg.sh NLS_LANG`

export LD_LIBRARY_PATH=`getcfg.sh LD_LIBRARY_PATH`
export SHLIB_PATH=`getcfg.sh SHLIB_PATH`

export OCI_PATH=`getcfg.sh OCI_PATH`
export TNS_ADMIN=`getcfg.sh TNS_ADMIN`

ulimit -c unlimited
ulimit  unlimited
umask 027

BasePath=`getcfg.sh BasePath`

if [ $# -eq 1 ]
then
	cd ${BasePath}$1/log
	rm *.* 2>/dev/null

	rm ${BasePath}$1/flow/* > /dev/null 2>/dev/null
	cd ${BasePath}$1/bin
	rm *.con 2>/dev/null
	rm *.id 2>/dev/null
	rm *.dat 2>/dev/null

	> .NotRun
	${BasePath}shell/GenMD5.sh -c $1.ini &&  rm .NotRun
	if [ -r .NotRun ]
	then
		echo $1:$1.ini had been changed!
	else
		nohup ./$1  &
	fi
else
	if [ $1$2 != "tinitcsv" ]
	then
	cd ${BasePath}$1$2/log
	rm *.* 2>/dev/null

	rm ${BasePath}$1$2/flow/* > /dev/null 2>/dev/null
	cd ${BasePath}$1$2/bin
	rm *.con 2>/dev/null
	rm *.id 2>/dev/null
	rm *.dat 2>/dev/null

	> .NotRun
	${BasePath}shell/GenMD5.sh -c $1.ini &&  rm .NotRun
	if [ -r .NotRun ]
	then
		echo $1$2:$1.ini had been changed!
	else
		if [ $# -eq 2 ]
		then
			nohup ./$1 $2 &
		else
			if [ $# -eq 3 ]
			then
				nohup ./$1 $2 $3 &
			else
				nohup ./$* &
			fi
		fi
	
	fi
	else
	cd ${BasePath}$1/log
        rm *.* 2>/dev/null

        rm ${BasePath}$1/flow/* > /dev/null 2>/dev/null
        cd ${BasePath}$1/bin
        rm *.con 2>/dev/null
        rm *.id 2>/dev/null
        rm *.dat 2>/dev/null

        > .NotRun
        ${BasePath}shell/GenMD5.sh -c $1.ini &&  rm .NotRun
        if [ -r .NotRun ]
        then
                echo $1$2:$1.ini had been changed!
        else
                if [ $# -eq 2 ]
                then
                        nohup ./$1 $2 &
                else
                        if [ $# -eq 3 ]
                        then
                                nohup ./$1 $2 $3 &
                        else
                                nohup ./$* &
                        fi
                fi

        fi
    fi
fi
