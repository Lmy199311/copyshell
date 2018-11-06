tempfile="tabs.$$"
SEP=","

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

delete()
{
	sqlplus ${userid} <<! >/dev/null 2>/dev/null
	truncate table $1;
	commit;
	quit
!
}
	
genctrlfile()
{
	table=$1
	export table
	ctrlfile=${table}.ctl
	tempctrl=${table}.ctl.$$

	sqlplus ${userid} <<! >/dev/null 2>/dev/null
	spool ${tempctrl};
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

	if [ -f ${tempctrl} ]
	then
		cat $tempctrl |grep -v "^SQL" |awk '
		BEGIN { printf "LOAD DATA INFILE '%s.txt' ",ENVIRON["table"]
			printf "BADFILE '%s.bad' ",ENVIRON["table"]
			printf "APPEND INTO TABLE %s ",ENVIRON["table"]
			printf "FIELDS TERMINATED BY \",\"\n(\n"
			no=0
		}
		{	
			no+=1;
			if ( no>3 && length($1)>0)
				printf ",\n"
			if ( no >= 3 && length($1)>0)
				printf $1
		}
		END {	printf "\n)\n" 
		}' > $ctrlfile
		rm -f $tempctrl
	else
		echo "$0 error :not find ${tempctrl} file."
		exit
	fi
}

load()
{
	table=$1
	ROWS=10000
	BINDS=8192000
	READS=8192000
	sqlldr ${userid} control=${table}.ctl rows=$ROWS bindsize=$BINDS readsize=$READS log=${table}.log bad=${table}.bad direct=true
}

## 主程序入口
argc=$#
if [ $argc -gt 0 ]
then
	if [ $1 = "-f" ]
	then
		deleteflag="true"
		argc=`expr $argc - 1 `
	else
		deleteflag="false"
	fi
fi

case $argc in
1)
	if [ $deleteflag = "true" ]
	then
		userid=$2
	else
		userid=$1
	fi
	gettabs $userid
	;;
2)
	if [ $deleteflag = "true" ]
	then
		userid=$2
		tables=$3
	else
		userid=$1
		tables=$2
	fi
	;;
*)
	echo "Usage: $0 [-f] user/passwd@sid [tablename]"
	exit
	;;
esac

for table in ${tables}
do
	if [ ! -f ${table}.csv ]
	then
		echo "Error:${table}.csv file not found!"
	else
		printf "Importing $table ..."
		sed "1,1 d" ${table}.csv > ${table}.txt 
		if [ $deleteflag = "true" ]
		then
			delete ${table}
		fi
		genctrlfile ${table}
		load ${table}
		rm -f ${table}.ctl
		rm -f ${table}.txt
		printf " done\n"
	fi
done
