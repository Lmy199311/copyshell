#unload table to txt
SEP=','

ORACLE_BASE=/home/oracle;export ORACLE_BASE
ORACLE_HOME=/home/oracle/app/oracle/product/10.2.0/db_1;export ORACLE_HOME
CRS_HOME=/home/oracle/app/oracle/product/10.2.0/crs_1;export CRS_HOME
NLS_LANG=American_America.zhs16gbk;export NLS_LANG
PATH=$ORACLE_HOME/bin:$CRS_HOME/bin:$PATH;export PATH

tempfile="tabs.$$"
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
	select instrumentid,'yestoday',closeprice,settlementprice,openinterest from t_marketdata where tradingday = (select max(tradingday) tradingday from t_marketdata ) order by instrumentid desc;
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
	fi

	genmdcsv "t_MarketData"

