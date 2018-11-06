#!/bin/sh
#wang.xiping modified 20070728

cd /home/data/archive
tar cvf trade.flow.tar ./tkernel1 >/dev/null
tar cvf front.slog.tar ./front* >/dev/null
gzip -f trade.flow.tar
gzip -f front.slog.tar
today=`date +%C%y%m%d`
ftp -i -in <<!
open 192.168.106.112
user archive shanghai123
bin
mkdir $today
cd $today
put trade.flow.tar.gz
put front.slog.tar.gz
bye
!
