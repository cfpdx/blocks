#!/bin/bash

trap 'export END=$(date) && printf "\nSTART: ${START}\nEND: ${END}\nURL: ${URL}\nINT: ${INT}" >> testlog.log' EXIT

# ROUTINE DEFINITIONS
main() {
    URL=$1
    INT=$2
    export START=$(date)
    while true;
    do
	curl -o - -I $URL >> testlog.log
	sleep $INT
    done
}

# CLEAR OLD LOGS
if [ -e "testlog.log" ]; then
    rm "testlog.log"
fi

main $1 $2
