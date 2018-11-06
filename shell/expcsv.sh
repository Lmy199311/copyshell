#!/bin/sh
#ChangeLog:
#20070711 YanShaohui: Add OraclePass for TNSString

PROGRAM_NAME="expcsv.sh"
LOGGER="/usr/bin/echo"

OraclePass=/usr/sbin/OraclePass
OP_Server=192.168.84.81,192.168.84.86
OP_Port=9001
OP_Env=product
OP_DB=bdb
OP_User=zhangdl
OP_Flag="-Z -Z"

#unload table to txt
SEP=','

tempfile="tabs.$$"
gettabs()
{
	rm -f ${tempfile} 2>/dev/null
	sqlplus $1 <<! >/dev/null 2>/dev/null
	set colsep $SEP;
	set echo off;
	set feedback off;
	set heading off;
	set pagesize 0;
	set linesize 1000;
	set numwidth 12;
	set termout off;
	set trimout on;
	set trimspool on;
	spool ${tempfile};
	select lower(table_name) from user_tables;
	spool off;
	exit
!
	if [ "$?" -ne 0 ]
	then
		echo "Error:sqlplus ${userid} error in load for ${userid} !"
		echo "please check userid and passwd or oracle_sid."
		exit
	fi

	if [ -f ${tempfile} ]
	then
		tables=`cat ${tempfile} |grep -v "^SQL>" |tr -d ' '` 
	else
		echo "Error:${tempfile} file not found!"
		exit
	fi

	rm -f ${tempfile} 2>/dev/null

}

gencsvhead()
{
	table=$1
	temphead=${table}.head.$$

	sqlplus ${userid} <<! >/dev/null 2>/dev/null
	spool ${temphead};
	desc ${table}
	spool off;
	exit
!

	if [ "$?" -ne 0 ]
	then
		echo "Error:sqlplus ${userid} for genctrl file[${table}]!"
		echo "please check userid and passwd or oracle_sid."
		exit
	fi

	if [ -f ${temphead} ]
	then
		grep -v "^SQL" $temphead |awk '
		BEGIN { 
			no=0
		}
		{	
			no+=1;
			if ( no>3 && length($1)>0)
				printf ","
			if ( no >= 3 && length($1)>0)
				printf $1
		}
		END {	printf "\n" 
		}' > ${table}.csv
		rm -f $temphead
	else
		echo "$0 error :not find ${temphead} file."
		exit
	fi
}

gencsv()
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
	select * from $tab $SubSentence ;
	spool off;
	exit
!

	grep -v "^SQL" ${tab}.lst|grep -v "rows selected"|tr -d ' '>> ${tab}.csv
	rm -f ${tab}.lst
}

## 主程序入口
SubSentence=""
case $# in
1)
	userid=$1
	gettabs $userid
	;;
2)
	userid=$1
	tables=$2
	;;
3)
	userid=$1
	tables=$2
	SubSentence=" where $3"
	;;
*)
	echo $0 user/passwd@database tablename  ["wheresentence"]
	;;
esac

for table in $tables
do
	printf "Exporting $table ..."
	gencsvhead $table
	gencsv $table
	printf " done\n"
done

