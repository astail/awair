#!/bin/bash

set -eu

DATA=`curl --location --request GET 'https://developer-apis.awair.is/v1/users/self/devices/awair-r2/${device_id}/air-data/latest?fahrenheit=false' \
--header "Authorization: Bearer ${auth}"`

valueget() {
  echo ${DATA} | jq -r '.data[].sensors[] | select( .["comp"] == '\"$1\"')'.value
}

temp=`valueget temp`
humid=`valueget humid`
co2=`valueget co2`
voc=`valueget voc`
pm25=`valueget pm25`

timestamporg=`echo ${DATA} | jq -r '.data[].timestamp'`

timestamp=`env TZ=JST-9 date -d ${timestamporg} "+%Y-%m-%d %H:%M:%S"`
score=`echo ${DATA} | jq -r '.data[].score'`

mysql -h dbserver -u awair -pawairpass awair -e "insert into awair(temp,humid,co2,voc,pm25,score,date) values($temp,$humid,$co2,$voc,$pm25,$score,\"${timestamp}\");"
