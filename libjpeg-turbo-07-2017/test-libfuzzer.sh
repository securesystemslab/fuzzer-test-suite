#!/bin/bash
# Copyright 2017 Google Inc. All Rights Reserved.
# Licensed under the Apache License, Version 2.0 (the "License");
. $(dirname $0)/../common.sh
set -x
rm -rf $CORPUS
mkdir $CORPUS

rm fuzz-*.log

test_source_location() {
  SRC_LOC="$1"
  echo "test_source_location: $SRC_LOC"
  rm -f *.log
  [ -e $EXECUTABLE_NAME_BASE ] && \
    ./$EXECUTABLE_NAME_BASE -seed=$SEED -max_total_time=$MAX_TOTAL_TIME -reload=$RELOAD -verbosity=$VERBOSITY -print_pcs=$PRINT_PCS -print_funcs=$PRINT_FUNCS -print_final_stats=$PRINT_FINAL_STATS -print_corpus_stats=$PRINT_CORPUS_STATS -print_coverage=$PRINT_COVERAGE -artifact_prefix=$CORPUS/ -exit_on_src_pos=$SRC_LOC -jobs=$JOBS -workers=$JOBS -print_pcs=1 $CORPUS $SCRIPT_DIR/seeds
  grep "INFO: found line matching '$SRC_LOC'" fuzz-*.log || exit 1
}

test_source_location jdmarker.c:659

