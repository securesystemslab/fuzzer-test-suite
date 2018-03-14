#!/bin/bash
# Copyright 2016 Google Inc. All Rights Reserved.
# Licensed under the Apache License, Version 2.0 (the "License");
. $(dirname $0)/../common.sh
set -x
rm -rf $CORPUS
mkdir $CORPUS
[ -e $EXECUTABLE_NAME_BASE ] && ./$EXECUTABLE_NAME_BASE -seed=$SEED -max_total_time=$MAX_TOTAL_TIME -reload=$RELOAD -verbosity=$VERBOSITY -print_pcs=$PRINT_PCS -print_funcs=$PRINT_FUNCS -print_final_stats=$PRINT_FINAL_STATS -print_corpus_stats=$PRINT_CORPUS_STATS -print_coverage=$PRINT_COVERAGE -artifact_prefix=$CORPUS/ -max_total_time=300 -jobs=$JOBS -workers=$JOBS $CORPUS
grep "ERROR: AddressSanitizer" fuzz-0.log
