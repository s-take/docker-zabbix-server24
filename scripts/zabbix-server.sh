#!/bin/bash

pidfile="/var/run/zabbix/zabbix_server.pid"
command="zabbix_server -c /etc/zabbix/zabbix_server.conf"

# Proxy signals
function kill_app(){
    kill $(cat $pidfile)
    exit 0 # exit okay
}
trap "kill_app" SIGINT SIGTERM

while :
do
        mysql -uroot -pP@ssw0rd -e "show tables;" zabbix > /dev/null
        if [ $? -eq 0 ]; then
                break
        fi
        echo Retry
        sleep 5
done

# Start Zabbix Serevr
$command
sleep 2

# Loop while the pidfile and the process exist
while [ -f $pidfile ] && kill -0 $(cat $pidfile) ; do
    sleep 1
done
exit 1000 # exit unexpected

