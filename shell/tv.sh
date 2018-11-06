#!/bin/sh
#wang.xiping modified 20070728

today=`date +"%b %d"`
if [ $# -gt 2 ]
then
	today="$2 $3"
fi	

GetMax() 
{
	grep "^$today " Syslog.log |awk '
		BEGIN {
			orIns=0
			orAct=0
			trSiz=0
			orErr=0
			n_or_ins=0
			n_or_act=0
			n_tr_siz=0
			max_ord=0
			curr_ord=0
			curr_siz=0
			curr_ord_err=0
			max_per_ins=0
			max_per_err=0
			n_per_err=0
			max_ord_err=0
			max_tm=""
			max_per_tm=""
		}
		{ 
			if ( $7 == "HandleOrderInsert" ) 
			{
				orIns+=1
				n_or_ins+=$8
				curr_ord+=$8
				a_or_ins[orIns]=$8
				if ( orIns > 12 )
				{
					n_or_ins-=a_or_ins[orIns-12]
					curr_ord-=a_or_ins[orIns-12]
				}
				if ( max_per_ins < $8 )
				{
					max_per_ins=$8
					max_per_tm=$3
					max_per_err=n_per_err
				}

				if ( curr_ord > max_ord )
				{
					max_or_ins=n_or_ins
					max_or_act=n_or_act
					max_tr_siz=n_tr_siz
					max_ord=curr_ord
					max_tm=$3
				}
			}
			if ( $7 == "HandleOrderAction" ) 
			{
				orAct+=1
				n_or_act+=$8
				curr_ord+=$8
				a_or_act[orAct]=$8
				if ( orAct > 12 )
				{
					n_or_act-=a_or_act[orAct-12]
					curr_ord-=a_or_act[orAct-12]
				}
				if ( curr_ord > max_ord )
				{
					max_or_ins=n_or_ins
					max_or_act=n_or_act
					max_tr_siz=n_tr_siz
					max_ord=curr_ord
					max_ord_err=n_or_err
					max_tm=$3
				}
			}
			if ( $7 == "HandleOrderInsertError" ) 
			{
				orErr+=1
				n_or_err+=$8
				n_per_err=$8
				a_or_err[orErr]=$8
				if ( orErr > 12 )
				{
					n_or_err-=a_or_err[orErr-12]
				}
				if ( $3 == max_per_tm )
				{
					max_per_err=n_per_err
				}
			}

			if ( $7 == "TradeSize" ) 
			{
				trSiz+=1
				n_tr_siz=$8
				a_tr_siz[trSiz]=$8
				if ( trSiz > 12 )
				{
					n_tr_siz-=a_tr_siz[trSiz-12]
				}
			}
		}
		END {
			printf "%s %d %d %d %d %d %s %d %d",max_tm,max_or_ins,max_or_act,max_ord_err,max_ord,max_tr_siz,max_per_tm,max_per_ins,max_per_err
		}'

}

if [ $1 = "-l"  ]
then
	echo From Local Syslog.log
else
	cd /home/PTrade/$1/dump 2>/dev/null
fi

if [ -r Syslog.log ]
then
	printf "%40s\n" "交易系统一分钟处理峰值情况"
	printf "%8s %10s %8s %8s %8s %8s %8s %8s\n" "日期" "时间" "报单申请" "报单操作" "无效报单" "交易合计" "成交" "合计处理"
	GetMax |read -r tm orders ordacts orderrs ordsum trades per_tm max_per_ins max_per_err
	total=`expr $ordsum + $trades`
	printf "%8s %10s %8d %8d %8d %8d %8d %8d\n" "$today" $tm $orders $ordacts $orderrs $ordsum $trades $total 
	printf "\n\n%40s\n" "交易系统5秒钟报单插入处理峰值"
	printf "%10s %10s %10s %10s\n" "日期" "时间" "报单申请" "无效报单"
	printf "%10s %10s %10d %10d\n" "$today" $per_tm $max_per_ins $max_per_err
else
	echo "Syslog.log not found!"
fi
