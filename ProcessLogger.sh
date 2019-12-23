#!/usr/bin/env bash
echo "Echoing to /out.log"

function maxMem() {
    
    array=($(ls -d /proc/[0-9]*)) 
    
    sorted=($(for i in "${array[@]}"  
    
    do
        pid=${i##/proc/}
        statm="/proc/${pid}/statm"
        comm="/proc/${pid}/comm"
        if [ -f "$statm" ]; then
            name="$(cat $comm)"
            mem="$(cat $statm)"
            if [[ "$mem" =~ ^([0-9]+) ]]; then
                output="${BASH_REMATCH[1]}(kbs)- ${name}"
                echo "${output}"
                
            fi
        fi
    done | sort -g -r | head -$1))
    
    printf "%s%s\n" "${sorted[@]}" > /tmp/out.log
}
while true; do 
maxMem 10;
sleep 10;
 done
