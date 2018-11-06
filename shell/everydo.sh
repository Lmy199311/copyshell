#/bin/sh
#modify by wangxiping 20070817

if [ $# -eq 0 ]
then
	List=`ls`
else
	List=$*
fi

func()
{
	echo $1 |awk '{ 
		printf "%s",substr($1,index($1,"."))
		}'|read exname
	if [ ! "$exname" = "gz" ]
	then
		gzip $1
	fi
}

impl()
{
	if [ -d $1 ]
	then
		cd $1
		travel `ls`
		cd ..
	else
		func $1
	fi
}		

travel()
{
	for it in $*
	do
		impl $it
	done
}

travel $List
