shell控制脚本使用说明：

1.本控制脚本支持HP-UX、RED-HAT LINUX

2.要求所有目标服务器的OS版本和oracle安装路径、用户名及工作路径相同。

3.建立好配置服务器和其它目标机间的信任关系ssh(安全)或remsh(非安全)

4.在配置服务器的用户目录下建立shell文件夹，将包中的所有文件释放到其中，并将~/shell路径加入到环境变量的PATH
举例说明：
	若为HP-UX环境，修改用户工作目录下的.profile文件；若为RED-HAT LINUX环境，修改用户工作目录下的.bash_profile文件
	# Set up the search paths:
        PATH=$PATH:.:~/shell

5.本套脚本安装要根据实际情况修改shell目录下的sh.cfg、list和backup.list三个文件，以下举例说明
　sh.cfg          变量定义文件,集中设置环境信息
　list            服务清单文件,设置进程服务名和启动参数
　backup.list     备份清单文件,设置备份内容列表

6.getcfg.sh脚本可读出sh.cfg中的变量内容，setcfg.sh可设置变量信息存储到sh.cfg中

7.sh.cfg举例说明（以remsh协议为例）：
注意:1)每行后面不要留空格
     2)路径必须以'/'结束，但oracle环境变量不需要。
     3)如果设置了SanPath变量，则所有文件存放在SanPath目录下，并链接到用户基础目录；否则，直接存放在基础目录。
passwd=123456
starttime=08:55:00
SH=remsh
SH_ARG=-n
CP=rcp
ServiceListFile=$HOME/shell/list
MenuFile=$HOME/shell/console.menu
BackupListFile=$HOME/shell/backup.list

BasePath=$HOME/
#SanPath=$HOME/san/
LocalBasePath=$HOME/
LocalShellPath=$HOME/shell/
LocalObjectPath=$HOME/cfg/run/
LocalConfigPath=$HOME/cfg/config/
LocalTempPath=/tmp/
CurrentVersion=1.08
CheckVersion=true

LocalBackupPath=$HOME/backup/

#set oracle environment
ORACLE_BASE=/home/oracle
ORACLE_HOME=/home/oracle/10.2.0.2
NLS_LANG=SIMPLIFIED CHINESE_CHINA.ZHS16GBK
LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib:$ORACLE_HOME/rdbms/lib
SHLIB_PATH=$ORACLE_HOME/lib32:$ORACLE_HOME/rdbms/lib32
OCI_PATH=$ORACLE_HOME/lib 

若采用ssh协议，则SH/SH_ARG/CP三个变量应采用如下设置：
SH=ssh -n
SH_ARG=
CP=scp

8.list举例说明：
第一例是服务名，后面接启动参数，若有多个进程的，接启动进程号，参数等，可用"@"符号带入变量，变量定义存放在sh.cfg中
arb
compositor 1 @starttime
tkernel 1
tmdb
tinit
mdkernel 1
qkernel 1
front 1 

9.backup.list举例说明：
#格式：进程名　备份文件列表
#all表示对所有list中的进程处理
#备份文件名可用通配符

all log/out
tkernel1 flow/*.con  flow/*.id    

10.基本脚本程序说明
脚本及程序清单
dos2ux.sh         脚本自我维护，修正换行符、属性
GenMD5.sh       	产生及校验MD5文件,后缀为.md5
configpath.sh   	建立配置服务器依赖的基本路径
console.menu　　	总控菜单文件
console.sh　　　	总控制台
cpall.sh　　　　	发布远程服务依赖的基本配置文件及脚本
cpiniall.sh　　　	发布远程服务配置文件
cpobjall.sh　　　	发布远程服务执行文件
ecall.sh　　　　	核心功能脚本
getcfg.sh　　　		获得变量取值
getch.sh　　　		读入字符不回显
mount.sh　　　		安装脚本
readme.txt　　		说明文件
restart.sh　　		重启某个服务
restartall.sh　		重启服务群
setcfg.sh　　　		设置变量值
showall.sh　　		显示服务进程情况
start.sh　　　		启动某个服务
startall.sh　　		启动服务群
stop.sh　　　　		关闭某个服务
stopall.sh　　		关闭服务群

11.路径管理使用方法：
ecall.sh makebasepath 进程名 进程号       #建立指定进程的基本工作路径，若不带进程名，进程号，则对所有进程操作
ecall.sh delbasepath  进程名 进程号       #删除指定进程的基本工作路径，若不带进程名，进程号，则对所有进程操作

