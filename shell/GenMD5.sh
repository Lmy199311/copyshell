#!/bin/sh
#wang.junpeng modified 20070830

case `uname -s` in
	"HP-UX") GenMD5.HP-UX $*;;
	"Linux") GenMD5.Linux $*;;
	"AIX")   GenMD5.AIX $*;;
	 *) echo OS error!;;
esac

