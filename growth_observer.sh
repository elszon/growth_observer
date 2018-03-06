#!/bin/bash

OUTPUT_FILE="/tmp/observation.log"

if [ -z "$1" ]; then
    echo "need file to monitoring"
    echo "usage: $0 file_to_observation [output_file]"
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
    echo "$1" 
}

OBSERVED_FILE=$1

OBSERVED_FILE_SIZE=$(ls -l $OBSERVED_FILE |awk '{print $5}')

log "========================================================"
log "Observation file start: $(date)"
log "Output file: $OUTPUT_FILE"
log "Observation filename: $1 with start size $OBSERVED_FILE_SIZE Bytes"

SLEEP_PERIOD=1
OBSERVATION_SECOND=0
SEC_IN_MINUTE=60
while [ $OBSERVED_FILE_SIZE = $(ls -l $OBSERVED_FILE |awk '{print $5}') ] ; do
    OBSERVATION_SECOND=$(($OBSERVATION_SECOND + $SLEEP_PERIOD))
    if [ $((OBSERVATION_SECOND % $SEC_IN_MINUTE )) = "0" ] ; then
        OBSERV_TIME_MIN=$((OBSERVATION_SECOND / $SEC_IN_MINUTE ))
        printf ". - Observation time $OBSERV_TIME_MIN min \n"
    else
        printf "."
    fi
    sleep $SLEEP_PERIOD
done
printf "\n"


log "Growth observed $(date)"
log "+====+"
tail -c +$OBSERVED_FILE_SIZE $OBSERVED_FILE >> $OUTPUT_FILE
tail -c +$OBSERVED_FILE_SIZE $OBSERVED_FILE
log "+====+"

printf "\n  DONE  \n"