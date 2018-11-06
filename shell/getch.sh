stty min 1
stty -icanon

#!/bin/sh
#wang.junpeng modified 20070830

case `uname -s` in
	"HP-UX") getch.HP-UX $*;;
	"Linux") getch.Linux $*;;
	 *) echo OS error!;;
esac
