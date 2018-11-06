#!/bin/sh
#wang.junpeng modified 20071018

case `uname -s` in
	"HP-UX") 
		mkdir dos2ux
		for f in `ls *.sh *list* *.cfg *.menu`
		do
			dos2ux $f > dos2ux/$f
			mv dos2ux/$f .
		done
		rm -Rf dos2ux

		chmod 755 *.sh *.HP-UX *.Linux;;

	"Linux") 
		for f in `ls *.sh *list* *.cfg *.menu`
		do
			dos2unix $f
		done
		chmod 755 *.sh *.HP-UX *.Linux;;

	 *) echo OS error!;;
esac
