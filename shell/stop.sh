#!/bin/sh
#wang.xiping modified 20070728

#kill -9 `ps -e|grep -v start|grep -w $1|awk '{print $1}'`

#ps -ef|grep -w "$1`[ $# -eq 1 ] || printf ' '$2`" |grep $LOGNAME|grep -v grep|grep -v ssh|grep -v remsh|grep -v stop|grep -v vi|grep -v "ps -ef"|awk '{print $2}'|xargs kill -9

kist=`ps -ef|grep -wE "$1 *$2" |grep $LOGNAME|grep -v grep|grep -v ssh|grep -v remsh|grep -v stop|grep -v vi|grep -v "ps -ef"|awk '{print $2}'|xargs echo`
kill -9 `echo $kist` 2>/dev/null
