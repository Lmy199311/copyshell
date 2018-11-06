#!/bin/sh
#ChangeLog:
#20070711 YanShaohui: Add OraclePass for TNSString

PROGRAM_NAME="checkclose_d.sh"
LOGGER="/usr/bin/echo"

OraclePass=/usr/sbin/OraclePass
OP_Server=192.168.84.81,192.168.84.86
OP_Port=9001
OP_Env=product
OP_DB=bdb
OP_User=zhangdl
OP_Flag="-Z -Z"

export ORACLE_BASE=/home/oracle
export ORACLE_HOME=/home/oracle/app/oracle/product/10.2.0/db_1
export CRS_HOME=/home/oracle/app/oracle/product/10.2.0/crs_1
export NLS_LANG=American_America.zhs16gbk
export PATH=$ORACLE_HOME/bin:$CRS_HOME/bin:$PATH


#unload table to txt
SEP=','

genmdcsv()
{
	tab=$1
	sqlplus $userid <<! >/dev/null 2>/dev/null
	set colsep $SEP;
	set echo off;
	set heading off;
	set pagesize 0;
	set feedback off;
	set linesize 10000;
	set termout off;
	set trimout on;
	set trimspool on;
	spool $tab
	select instrumentid,'yestoday',closeprice,settlementprice,openinterest from t_tradingmarketdata  order by instrumentid desc;
	select 'zTrade','yestoday','','',count(*) from t_trade;
	select 'zOrder','yestoday','','',count(*) from t_order;
	spool off;
	exit
!

	grep -v "^SQL" ${tab}.lst|grep -v "rows selected"|tr -d ' '
	rm -f ${tab}.lst
}

## 主程序入口
	if [ $# -eq 1 ]
	then
		userid=$1
	else
		echo $0 user/passwd@database 
                exit 1
	fi

	genmdcsv "t_TradingMarketData"

