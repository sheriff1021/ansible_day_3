#!/bin/bash
source $1
cd $path1

function manage {
if [ "$state" = "started" ]; then
    vagrant up
elif [ "$state" = "stoped" ]; then
    vagrant halt
elif [ "$state" = "destroyed" ]; then
    vagrant destroy
fi
}

manage 
#sleep 1m
function get_params
{
 ip=$(vagrant ssh-config | grep HostName | awk '{print $2}')
 port=$(vagrant ssh-config | grep Port | awk '{print $2}')
 user=$(vagrant ssh-config | grep -w "User" | awk '{print $2}')
 key=$(vagrant ssh-config | grep  IdentityFile | awk '{print $2}')
 os_name=$(vagrant ssh -c "lsb_release -a" | grep Description | awk '{print $2,$3}')
 ram=$(vagrant ssh -c "cat /proc/meminfo | grep MemTotal | awk '{print \$2}'" 2>/dev/null)
}

function status_report {
status=$(vagrant status | grep virtualbox)
var1=$(echo "$status" | grep -o -m 1 "not created" | head -1)
var2=$(echo "$status" | grep -o -m 1 "running" | head -1)
var3=$(echo "$status" | grep -o -m 1 "poweroff" | head -1)

}
status_report 
if [ "$var1" = "not created" ]; then
  statem="destroyed"
  echo "{ \"changed\": true, \"state\": \"$statem\" }"
elif [ "$var2" = "running" ]; then
  get_params
  statem="started"
  echo "{ \"changed\": true, \"state\": \"$statem\", \"ip\": \"$ip\", \"port\": \"$port\", \"user\": \"$user\", \"ram\": \"$ram\", \"key\": \"$key\" }" 
elif [ "$var3" = "poweroff" ]; then
  statem="stopped"
echo "{ \"changed\": true, \"state\": \"$statem\" }"
fi
