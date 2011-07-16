#!/bin/bash

DEBUG="-debug=true"
VERSION="-target-player=10.0.0"
OUT="-o=debug/ema.swf"
MAIN="flash/ichigo/Main.as"

echo "mxmlc $DEBUG $VERSION $OUT -static-link-runtime-shared-libraries=true -compiler.source-path=src src/ema/Main.as"

sleep 5

while [ /usr/bin/true ]
do
  echo "compile 1"
  sleep 2
done
