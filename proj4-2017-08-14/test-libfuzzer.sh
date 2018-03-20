#!/bin/bash
# Copyright 2017 Google Inc. All Rights Reserved.
# Licensed under the Apache License, Version 2.0 (the "License");

. $(dirname $0)/../common.sh

rm -rf $CORPUS
mkdir $CORPUS

rm fuzz-*.log

[ -e $EXECUTABLE_NAME_BASE ] && ./$EXECUTABLE_NAME_BASE -seed=$SEED -max_total_time=$MAX_TOTAL_TIME -reload=$RELOAD -verbosity=$VERBOSITY -print_new_units=$PRINT_NEW_UNITS -print_pcs=$PRINT_PCS -print_funcs=$PRINT_FUNCS -print_final_stats=$PRINT_FINAL_STATS -print_corpus_stats=$PRINT_CORPUS_STATS -print_coverage=$PRINT_COVERAGE -artifact_prefix=$CORPUS -jobs=$JOBS -workers=$JOBS $CORPUS seeds
grep "ERROR: LeakSanitizer" fuzz-0.log || exit 1

