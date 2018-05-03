#!/usr/bin/env bash

app_date=$(date '+%d%b%C%y' -d "+5hours30minutes" | tr '[:lower:]' '[:upper:]')
export app_date

echo "Today : $app_date"

app_path="/home/stckscrnr/baseApp"

url='https://www.nseindia.com/content/historical/EQUITIES/2018/'
#url='https://www.nseindia.com/content/historical/EQUITIES/2017/'

get_data() {

        mon=$(echo $1 | cut -c3-5)
	yr=$(echo $1 | cut -c6-9)
        suffix="bhav.csv"
        tempurl="$url$mon/cm$1$suffix.zip"
        file="cm$1$suffix"
        echo "Pulling data for $1"
        cd ${app_path}/app_histData/tmp
        wget -U 'Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4' $tempurl
        unzip $file.zip
        grep -w -f ${app_path}/app_conf/stocks.list $file >> ${app_path}/app_histData/$2$yr.raw
        rm $file $file.zip

        echo $1 >> ${app_path}/app_conf/trading_days.done
	
}

cd $app_path/app_histData/

## Used for batch processing of months ##

#for month in JUN JUL MAY AUG SEP OCT NOV DEC
#do
yr="2018"
month='MAY'

for i in $(cat ${app_path}/app_conf/${month}${yr}_trading_days.list);
    do
	if [ $(echo ${i} | cut -c3-5) == $month ]
	then 
		echo "Month same"
		if [ $(echo ${i} | cut -c1-2) -eq $(echo ${app_date} | cut -c1-2) ]
		then 
		echo "Date greater than current"
		break
		fi
	fi

        if [ -e ${app_path}/app_histData/$month$yr.raw ]
        then
	    avail=$(grep -c $i ${app_path}/app_conf/trading_days.done)
	    if [ ${avail} -gt 0 ] 
            then
                echo "Data for $i available"
	    else 
		get_data $i $month
            fi
        else
            get_data $i $month
        fi
    done
#done


sort ${app_path}/app_conf/trading_days.done | uniq > ${app_path}/app_conf/working_days.chkdone
mv ${app_path}/app_conf/working_days.chkdone ${app_path}/app_conf/trading_days.done
