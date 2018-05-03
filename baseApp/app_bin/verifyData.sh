#!/usr/bin/env bash

basedir="/home/stckscrnr/baseApp"

cyr_date=$(date '+%d%b%C%y' -d "+5hours30minutes" | tr '[:lower:]' '[:upper:]')
lyr_date=$(date '+%d%b%C%y' -d "-1years +5hours30minutes" | tr '[:lower:]' '[:upper:]')

prv_mon=$(date '+%b%C%y' -d "-1months +5hours30minutes" | tr '[:lower:]' '[:upper:]')

#MON=()
m=1

echo "** Records as of date : ${cyr_date}" >> ${basedir}/app_conf/monthly_data.avail
while [ ${m} -le 12 ]
do
	mon=$(date '+%b%C%y' -d "-${m}months +5hours30minutes" | tr '[:lower:]' '[:upper:]')
	
	wdc=$(wc -l ${basedir}/app_conf/${mon}_trading_days.list | cut -d" " -f1)
	mdc=$(wc -l ${basedir}/app_histData/${mon}.raw | cut -d" " -f1)
	echo "Working day count $wdc -- month data count $mdc"

	if [ $mdc -eq $((${wdc} * 200)) ]
	then 
		echo "All days data for --${mon}-- available" >> ${basedir}/app_conf/monthly_data.avail
	else 
		echo "Few days data for --${mon}-- missing" >> ${basedir}/app_conf/monthly_data.avail
	fi
	#ddMON[`expr ${m} - 1`]=${mon}
	m=$[$m+1]
done

#echo ${MON[*]}


	  
