#!/usr/bin/env bash

burl='https://www.google.com/finance/getprices?q='
btimef='&i='
bexch='&x=NSE'
bdurtn='&p='
bformat='&f=d,c,h,l,o,v'

bdir='/home/stckscrnr/baseApp'

echo "Run log for the date ## $(date) ##" >> ${bdir}/app_bin/logs/$0_run.log

rm ${bdir}/app_db/300_data/*.raw ${bdir}/app_db/900_data/*.raw
rm ${bdir}/app_db/300_data/*.csv ${bdir}/app_db/900_data/*.csv
echo 0 > ${bdir}/app_db/300_data/data_format.invalid 
echo 0 > ${bdir}/app_db/900_data/data_format.invalid

getData() {
	for symbol in $(cat ${bdir}/app_conf/stocks.list);
	do
	    sym=$(echo ${symbol//&/%26} | cut -d"," -f1)
	    echo "Pulling data for : ${burl}${sym}${bexch}${btimef}$1${bdurtn}$2${bformat}" >> ${bdir}/app_bin/logs/$0_run.log 2>&1
	    wget -O ${bdir}/app_db/${1}_data/${sym}_${2}.raw ${burl}${sym}${bexch}${btimef}$1${bdurtn}$2${bformat} >> ${bdir}/app_bin/logs/$0_run.log 2>&1
	    
	    echo "Pre-processing the file : ${sym}_${2}.raw" >> ${bdir}/app_bin/logs/$0_run.log 2>&1
	    if [ $(grep -f ${bdir}/app_db/${1}_data/data_format ${bdir}/app_db/${1}_data/${sym}_${2}.raw | wc -l) -eq 7 ]
	    then
		tail -n +8 ${bdir}/app_db/${1}_data/${sym}_${2}.raw > ${bdir}/app_db/${1}_data/${sym//%26/&}_${2}.csv
		rm ${bdir}/app_db/${1}_data/${sym}_${2}.raw
		echo "Pre processing done for : ${sym}_${2}" >> ${bdir}/app_bin/logs/$0_run.log 2>&1
	    else 
		echo "Format not valid, Please check : ${sym}_${2}" >> ${bdir}/app_db/${1}_data/data_format.invalid
	    fi
	done
}

echo "Pulling 5 mintues Data : "; date
getData '300' '10d'
echo "Completed at : "; date
echo "	"	
echo "Pulling 15 mintues Data : "; date
getData '900' '30d'
echo "Completed at : "; date
