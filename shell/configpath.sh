#!/bin/sh
#wang.xiping modified 20070728

if [ $# -lt 1 ]
then
	echo Usage: $0 "-m|d"
	return 1
fi

case $1 in
-m)
	mkdir shell
	mkdir run
	mkdir temp
	if [ -d ../data ]
	then
		mkdir ../data/backup
		ln -s ../data/backup backup
	fi
	;;
-d)
	rm -rf shell
	rm -rf run
	rm -rf temp
	rm -rf backup
	;;
*)
	echo Error:invalid argument
	echo Usage: $0 "-m|d"
	;;
esac
