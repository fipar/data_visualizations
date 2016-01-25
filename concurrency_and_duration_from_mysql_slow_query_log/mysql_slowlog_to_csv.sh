#!/bin/bash
[ -z "$1" ] && {
    echo "usage: mysql_slow_log_to_csv <slow.log>">&2
    exit 1
}
echo "id,time,query_time,z"
id=0
cnt=0
z=1
pre=
while read line; do 
    #echo "control: $line"
    echo $line|grep '^SET timestamp='>/dev/null && {
        time=$(echo $line|sed 's/.*=//g'|tr -d ';')
        cnt=$((cnt+1))
    }
    echo $line|grep '^# Query_time: '>/dev/null && {
        query_time=$(echo $line|awk '{print $3}')
        cnt=$((cnt+1))
    }
    [ $cnt -eq 2 ] && {
        if [ "$time" == "$pre" ]; then
    	z=$((z+1))
        else
    	z=0; pre=$time
        fi
        echo "$id,$time,$query_time,$z"
        cnt=0; id=$((id+1))
    }
done <$1
