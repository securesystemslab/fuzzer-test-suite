#!/bin/bash
# Copyright 2018 Google Inc. All Rights Reserved.
# Licensed under the Apache License, Version 2.0 (the "License");
. $(dirname $0)/../common.sh
set -x
rm -rf $CORPUS fuzz-*.log
mkdir $CORPUS

rm -r seeds-x509
cp -r SRC/fuzz/corpora/x509 seeds-x509

[ -e $EXECUTABLE_NAME_BASE ] && ./$EXECUTABLE_NAME_BASE-x509 -seed=$SEED -max_total_time=$MAX_TOTAL_TIME -reload=$RELOAD -verbosity=$VERBOSITY -print_new_units=$PRINT_NEW_UNITS -print_pcs=$PRINT_PCS -print_funcs=$PRINT_FUNCS -print_final_stats=$PRINT_FINAL_STATS -print_corpus_stats=$PRINT_CORPUS_STATS -print_coverage=$PRINT_COVERAGE -artifact_prefix=$CORPUS/  -jobs=$JOBS -workers=$JOBS $CORPUS seeds-x509
# no bug
