#!/usr/bin/env bash

bdir='/home/stckscrnr/baseApp'
pre='OPT_NIFTY_'

rename() {
for file in $(ls ${bdir}/app_db/OPTIDX*.csv);
do
	echo "File $file"
	opt=$(echo $file | cut -d"_" -f4); echo $opt
 	exp=$(echo $file | cut -d"_" -f7 | cut -d"-" -f1-3 | tr '[:lower:]' '[:upper:]')
	exp=${exp//-/}
	echo "New File : ${pre}${opt}_$exp"
	mv $file ${pre}${opt}_$exp
done
}

reformat() {
for file in $(ls ${bdir}/app_db/OPT*.CSV);
do
	nfile=$(echo $file | cut -d"." -f1)
	sed -e 's/"//g' < $file > ${nfile}.csv
done
}

re_move() {
for file in $(ls ${bdir}/app_db/OPT_*.csv);
do
	dir=$(echo $file | cut -d"_" -f5 | cut -d"." -f1); echo $dir
	if [ -d $${bdir}/app_db/OPTIONS_DATA/{dir} ]
	then
		mv $file ${bdir}/app_db/OPTIONS_DATA/${dir}
	else
		mkdir ${bdir}/app_db/OPTIONS_DATA/${dir}
		mv $file ${bdir}/app_db/OPTIONS_DATA/${dir}
	fi
done
}

#rename

#reformat

re_move
