#!/bin/bash
# Copyright 2016 Google Inc. All Rights Reserved.
# Licensed under the Apache License, Version 2.0 (the "License");
# Find heartbleed.
. $(dirname $0)/../common.sh
set -x
[ -e $EXECUTABLE_NAME_BASE ]  && ./$EXECUTABLE_NAME_BASE -seed=$SEED -max_total_time=$MAX_TOTAL_TIME -reload=$RELOAD -verbosity=$VERBOSITY -print_new_units=$PRINT_NEW_UNITS -print_pcs=$PRINT_PCS -print_funcs=$PRINT_FUNCS -print_final_stats=$PRINT_FINAL_STATS -print_corpus_stats=$PRINT_CORPUS_STATS -print_coverage=$PRINT_COVERAGE  -detect_leaks=0 2>&1 | tee log
# -max_total_time=300
grep -Pzo "(?s)ERROR: AddressSanitizer: heap-buffer-overflow.*READ of size.*#1 0x.* in tls1_process_heartbeat .*ssl/t1_lib.c:2586" log
