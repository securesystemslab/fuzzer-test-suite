#!/bin/bash
# Copyright 2017 Google Inc. All Rights Reserved.
# Licensed under the Apache License, Version 2.0 (the "License");

. $(dirname $0)/common.sh

# PARENT_DIR="RUN_EVERY_BENCHMARK"
# #[[ -e "$PARENT_DIR" ]] && echo "Rename folder $PARENT_DIR to avoid deletion" && exit 1
# rm -rf $PARENT_DIR
# mkdir $PARENT_DIR
# echo "Created top directory $PARENT_DIR"

ABS_SCRIPT_DIR=$(readlink -f $SCRIPT_DIR)
BENCHMARKS=( ${ABS_SCRIPT_DIR}/*/ )

# Run 4 benchmarks in parallel
GROUP=4

for((i=0; i < ${#BENCHMARKS[@]}; i+=GROUP))
do
  BENCHMARK_GROUP=( "${BENCHMARKS[@]:i:GROUP}" )
  echo "Running benchmarks in parallel: ${BENCHMARK_GROUP[*]}"
  for f in ${BENCHMARK_GROUP[*]}
  do
    file_name="$(basename $f)"
    [[ ! -d $f ]] && continue # echo "${file_name} isn't a directory" && continue
    [[ ! -e ${f}build.sh ]] && continue # echo "${file_name} has no build script" && continue
    echo "Running test $file_name"
    # (cd $PARENT_DIR && ${ABS_SCRIPT_DIR}/build-and-test.sh "${file_name}" > from-${file_name}.out 2>&1  &) # && sleep 10
    (${ABS_SCRIPT_DIR}/test-only.sh "${file_name}" > run-${file_name}.out 2>&1) &
  done
  sleep $MAX_TOTAL_TIME
  sleep 10
done

${ABS_SCRIPT_DIR}/collect-results.sh  # Collect results after running
