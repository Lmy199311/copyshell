shell���ƽű�ʹ��˵����

1.�����ƽű�֧��HP-UX��RED-HAT LINUX

2.Ҫ������Ŀ���������OS�汾��oracle��װ·�����û���������·����ͬ��

3.���������÷�����������Ŀ���������ι�ϵssh(��ȫ)��remsh(�ǰ�ȫ)

4.�����÷��������û�Ŀ¼�½���shell�ļ��У������е������ļ��ͷŵ����У�����~/shell·�����뵽����������PATH
����˵����
	��ΪHP-UX�������޸��û�����Ŀ¼�µ�.profile�ļ�����ΪRED-HAT LINUX�������޸��û�����Ŀ¼�µ�.bash_profile�ļ�
	# Set up the search paths:
        PATH=$PATH:.:~/shell

5.���׽ű���װҪ����ʵ������޸�shellĿ¼�µ�sh.cfg��list��backup.list�����ļ������¾���˵��
��sh.cfg          ���������ļ�,�������û�����Ϣ
��list            �����嵥�ļ�,���ý��̷���������������
��backup.list     �����嵥�ļ�,���ñ��������б�

6.getcfg.sh�ű��ɶ���sh.cfg�еı������ݣ�setcfg.sh�����ñ�����Ϣ�洢��sh.cfg��

7.sh.cfg����˵������remshЭ��Ϊ������
ע��:1)ÿ�к��治Ҫ���ո�
     2)·��������'/'��������oracle������������Ҫ��
     3)���������SanPath�������������ļ������SanPathĿ¼�£������ӵ��û�����Ŀ¼������ֱ�Ӵ���ڻ���Ŀ¼��
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

������sshЭ�飬��SH/SH_ARG/CP��������Ӧ�����������ã�
SH=ssh -n
SH_ARG=
CP=scp

8.list����˵����
��һ���Ƿ�������������������������ж�����̵ģ����������̺ţ������ȣ�����"@"���Ŵ��������������������sh.cfg��
arb
compositor 1 @starttime
tkernel 1
tmdb
tinit
mdkernel 1
qkernel 1
front 1 

9.backup.list����˵����
#��ʽ���������������ļ��б�
#all��ʾ������list�еĽ��̴���
#�����ļ�������ͨ���

all log/out
tkernel1 flow/*.con  flow/*.id    

10.�����ű�����˵��
�ű��������嵥
dos2ux.sh         �ű�����ά�����������з�������
GenMD5.sh       	������У��MD5�ļ�,��׺Ϊ.md5
configpath.sh   	�������÷����������Ļ���·��
console.menu����	�ܿز˵��ļ�
console.sh������	�ܿ���̨
cpall.sh��������	����Զ�̷��������Ļ��������ļ����ű�
cpiniall.sh������	����Զ�̷��������ļ�
cpobjall.sh������	����Զ�̷���ִ���ļ�
ecall.sh��������	���Ĺ��ܽű�
getcfg.sh������		��ñ���ȡֵ
getch.sh������		�����ַ�������
mount.sh������		��װ�ű�
readme.txt����		˵���ļ�
restart.sh����		����ĳ������
restartall.sh��		��������Ⱥ
setcfg.sh������		���ñ���ֵ
showall.sh����		��ʾ����������
start.sh������		����ĳ������
startall.sh����		��������Ⱥ
stop.sh��������		�ر�ĳ������
stopall.sh����		�رշ���Ⱥ

11.·������ʹ�÷�����
ecall.sh makebasepath ������ ���̺�       #����ָ�����̵Ļ�������·���������������������̺ţ�������н��̲���
ecall.sh delbasepath  ������ ���̺�       #ɾ��ָ�����̵Ļ�������·���������������������̺ţ�������н��̲���

