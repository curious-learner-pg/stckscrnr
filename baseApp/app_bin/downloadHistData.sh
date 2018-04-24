#!/usr/bin/env bash

app_date=$(date '+%d%b%C%y' -d "+5hours30minutes" | tr '[:lower:]' '[:upper:]')
export app_date

app_path="/home/stckscrnr/baseApp"

url='https://www.nseindia.com/content/historical/EQUITIES/2018/'

cd $app_path/app_histData/

for month in JAN FEB MAR
do 
for i in $(cat ${app_path}/app_conf/${month}_working_days.list);
    do
        if [ -e $month.raw ]
	then
		echo "Data for $month available"
	else
		mon=$(echo $i | cut -c3-5)
		suffix="bhav.csv"
		tempurl="$url$mon/cm$i$suffix.zip"
		file="cm$i$suffix"
		echo "Pulling data for $i"
		cd ./temp 
		wget -U 'Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4' $tempurl
		unzip $file.zip
		grep -w -f ${app_path}/app_conf/stocks.list $file >> ${app_path}/app_histData/$month.raw
		rm $file $file.zip
	fi
    done
done
