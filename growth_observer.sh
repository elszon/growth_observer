#!/bin/bash

OUTPUT_FILE="/tmp/observation.log"

if [ -z "$1" ]; then
    echo "need file to monitoring"
    echo "usage: $0 observation_file [output file]"
    exit 1;
fi

if ! [ -a "$1" ]; then
    echo "file $1 doesn't exist"
    exit 1;
fi

if [ -x "$2" ]; then
    OUTPUT_FILE=$2
fi

function log {
    echo "$1" >> $OUTPUT_FILE
}

FILE=$1
START_DATE=$(date)
FILE_SIZE=$(ls -l $FILE |awk '{print $5}')

log "========================================================"
log "Observation file start: $START_DATE"
log "Observation filename: $1 with start size $FILE_SIZE Bytes"

SLEEP_PERIOD=1
OBSERVATION_SECOND=0
SEC_IN_MINUTE=60
while [ $FILE_SIZE = $(ls -l $FILE |awk '{print $5}') ] ; do
    OBSERVATION_SECOND=$(($OBSERVATION_SECOND + $SLEEP_PERIOD))
    if [ $((OBSERVATION_SECOND % $SEC_IN_MINUTE )) = "0" ] ; then
        OBSERV_TIME_MIN=$((OBSERVATION_SECOND / $SEC_IN_MINUTE ))
        printf ". - Observation time $OBSERV_TIME_MIN min \n"
    else
        printf "."
    fi
    sleep $SLEEP_PERIOD
done

log "Growth observed $(date)"
log "+====+"
for line in $(tail -c +$FILE_SIZE $FILE) ; do
    log $line
done
log "+====+"
