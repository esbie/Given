#!/bin/bash

DEBUG="-debug=true"
VERSION="-target-player=10.0.0"
OUT="-o=debug/ema.swf"

mxmlc $DEBUG $VERSION $OUT -static-link-runtime-shared-libraries=true -compiler.source-path=src src/ema/Main.as
