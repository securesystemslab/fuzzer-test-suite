#!/bin/bash
# Copyright 2016 Google Inc. All Rights Reserved.
# Licensed under the Apache License, Version 2.0 (the "License");
set -x
. $(dirname $0)/../common.sh

get_git_revision https://github.com/mcarpenter/afl be3e88d639da5350603f6c0fee06970128504342 afl
rm -rf $CORPUS
mkdir $CORPUS
[ -e $EXECUTABLE_NAME_BASE ] && ./$EXECUTABLE_NAME_BASE -seed=$SEED -max_total_time=$MAX_TOTAL_TIME -reload=$RELOAD -verbosity=$VERBOSITY -print_pcs=$PRINT_PCS -print_funcs=$PRINT_FUNCS -print_final_stats=$PRINT_FINAL_STATS -print_corpus_stats=$PRINT_CORPUS_STATS -print_coverage=$PRINT_COVERAGE -artifact_prefix=$CORPUS/ -jobs=$JOBS -dict=afl/dictionaries/xml.dict -workers=$JOBS $CORPUS -max_len=64
grep "AddressSanitizer: heap-buffer-overflow\|ERROR: LeakSanitizer: detected memory leaks" fuzz-0.log
