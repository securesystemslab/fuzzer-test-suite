#!/bin/bash
# Copyright 2016 Google Inc. All Rights Reserved.
# Licensed under the Apache License, Version 2.0 (the "License");
. $(dirname $0)/../common.sh

# Note: this target contains unbalanced malloc/free (malloc is called
# in one invocation, free is called in another invocation).
# and so libFuzzer's -detect_leaks should be disabled for better speed.
export ASAN_OPTIONS=detect_leaks=0:quarantine_size_mb=50

set -x
rm -rf $CORPUS
mkdir $CORPUS
rm -f *.log
[ -e $EXECUTABLE_NAME_BASE ] && ./$EXECUTABLE_NAME_BASE -seed=$SEED -max_total_time=$MAX_TOTAL_TIME -reload=$RELOAD -verbosity=$VERBOSITY -print_new_units=$PRINT_NEW_UNITS -print_pcs=$PRINT_PCS -print_funcs=$PRINT_FUNCS -print_final_stats=$PRINT_FINAL_STATS -print_corpus_stats=$PRINT_CORPUS_STATS -print_coverage=$PRINT_COVERAGE -artifact_prefix=$CORPUS/ -use_value_profile=1 -jobs=$JOBS -workers=$JOBS $CORPUS seeds
grep "AddressSanitizer: heap-use-after-free" fuzz-0.log || exit 1
