#!/bin/sh
#ChangeLog:
#20070711 YanShaohui: Add OraclePass for TNSString

PROGRAM_NAME="checkclose.sh"
LOGGER="/usr/bin/echo"

OraclePass=/usr/sbin/OraclePass
OP_Server=192.168.84.81,192.168.84.86
OP_Port=9001
OP_Env=product
OP_DB=bdb
OP_User=currsgoperation
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

SH=ssh
tmpfile=/tmp/md.$$

$SH bdb ./bin/checkclose_d.sh ${OP_TNS} > $tmpfile
$SH tkernel1 ./bin/checkclose_m.sh >> $tmpfile

sort -t, -k1,2 $tmpfile| awk -F"," '
	BEGIN {
		printf "%10s %10s %15s %10s %15s\n","Instrument","M.Last","M.Openinst","D.Close","D.Openinst"
		preid=""
		flag=0
	}
	{
		id=$1
		if ( id != preid )
		{
			printf "%s\n",s
			s=""
		}
		preid=id
		if ( $2 == "today" )
		{
			last=$3
			settle=$4
			opinst=$5
			s=sprintf("%10s %10d %15d",$1,$3,$5)
		}
		else if ( $2 == "yestoday" )
		{
			if ( last == $3 )
				s=sprintf("%s %10d",s,$3)
			else
			{
				s=sprintf("%s \033[5m%10d\033[0m",s,$3)
				flag=1
			}
			if ( opinst == $5 )
				s=sprintf("%s %15d",s,$5)
			else
			{
				s=sprintf("%s \033[5m%15d\033[0m",s,$5)
				flag=1
			}
		}
	}
	END {
		printf "%s\n",s
		if ( flag == 0 )
			printf "Close Check OK!\n"
		else
			printf "Close Check Failed! \n"
	}'
rm $tmpfile
