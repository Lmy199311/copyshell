ORACLE_BASE=/home/oracle;export ORACLE_BASE
ORACLE_HOME=/home/oracle/app/oracle/product/10.2.0/db_1;export ORACLE_HOME
CRS_HOME=/home/oracle/app/oracle/product/10.2.0/crs_1;export CRS_HOME
NLS_LANG=American_America.zhs16gbk;export NLS_LANG
PATH=$ORACLE_HOME/bin:$CRS_HOME/bin:$PATH;export PATH

print "Please input tradingday(yyyymmdd):"
read -r tradingday
sqlplus memberservice/memberservice@sdb <<!
declare
	o_Result   number(1);
	o_ErrorMessage varchar2(2000); 
begin
	up_settlementdatasync('${tradingday}','00000001',1,o_Result,o_ErrorMessage);
	dbms_output.put_line(o_ErrorMessage);
	commit;
end;
/
quit
!

rm 
