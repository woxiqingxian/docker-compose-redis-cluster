#!/bin/sh

for port in 7001 7002 7003 7004 7005 7006
do
    rm -fr /redis_data/$port/*

    mkdir -p /redis_data/$port/log
    mkdir -p /redis_data/$port/data
    mkdir -p /redis_data/redis_config

    first_line=1
    cat /redis_data/redis_tmp.conf | while read -r LINE
    do
        line_text=$LINE
        line_text=${line_text//\{\{temp_port\}\}/$port}
        if [[ $first_line == 1 ]];then
            first_line=0
            echo ${line_text} > "/redis_data/redis_config/$port.conf"
        else
            echo ${line_text} >> "/redis_data/redis_config/$port.conf"
        fi
    done

    redis-server /redis_data/redis_config/$port.conf &
done

sleep 2

echo "yes" | redis-cli --cluster create 127.0.0.1:7001 127.0.0.1:7002 127.0.0.1:7003 127.0.0.1:7004 127.0.0.1:7005 127.0.0.1:7006 --cluster-replicas 1

sleep 1

echo "  ____"
echo " / ___| _   _  ___ ___ ___  ___ ___"
echo " \___ \| | | |/ __/ __/ _ \/ __/ __|"
echo "  ___) | |_| | (_| (_|  __/\__ \__ \\"
echo " |____/ \__,_|\___\___\___||___/___/"

while true
do
    sleep 10
done
