#!/bin/sh
#ChangeLog:
#20070711 YanShaohui: Add OraclePass for TNSString

PROGRAM_NAME="check.sh"
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


OP_TNS=`$OraclePass -c $OP_Server -p $OP_Port -n $OP_Env -b $OP_DB -u $OP_User $OP_Flag 2>/dev/null`
if [ $? != 0 ]
then
    RESULT_STR="${PROGRAM_NAME}:cannot get tnsstring for ${OP_Env}:${OP_User}@${OP_DB} from OPServer ${OP_Server}:${OP_Port}."
    ${LOGGER} ${RESULT_STR}
    exit 1
fi
if [ "${OP_TNS}" = "/@:0/" ]
then
    RESULT_STR="${PROGRAM_NAME}:cannot get tnsstring for ${OP_Env}:${OP_User}@${OP_DB} from OPServer ${OP_Server}:${OP_Port}."
    ${LOGGER} ${RESULT_STR}
    exit 1
fi

sqlplus ${OP_TNS} <<!
begin
  pkg_mgr2.CheckSyncData;
  commit;
end;
/
select * from t_log;
quit
!

