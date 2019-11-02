#!/bin/bash
set -e
cd `dirname $0`
cd ..

OPTS="--rm -v `pwd`:/data -u `id -u`"
if [ "$1" = "-i" ]; then
    shift
    ARGS="$*"
    OPTS="$OPTS -ti"
    if [ "$ARGS" = "" ]; then
        ARGS="irb"
    fi
else
    ARGS="$*"
fi

docker run $OPTS calfeed $ARGS
