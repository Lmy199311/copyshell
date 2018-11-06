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

umask 027
ulimit unlimited
ulimit -c unlimited

BasePath=`getcfg.sh BasePath`

if [ $# -eq 1 ]
then
	cd ${BasePath}$1/bin
	nohup ./$1  &
else
	if [ $1$2 = 'tinitcsv' ]
	then
		cd ${BasePath}$1/bin
		nohup ./$1 $2 &
	else
		cd ${BasePath}$1$2/bin
		if [ $# -eq 2 ]
		then
			nohup ./$1 $2 &
		else
    	    	if [ $# -eq 3 ]
      	          then
        	        	nohup ./$1 $2 $3 &
          	      else
            	     	nohup ./$*
              	  fi
		fi
	fi
fi
