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
BENCHMARKS=${ABS_SCRIPT_DIR}/*/

rm -rf results
mkdir results

for f in $BENCHMARKS
do
  file_name="$(basename $f)"
  [[ ! -d $f ]] && continue # echo "${file_name} isn't a directory" && continue
  [[ ! -e ${f}build.sh ]] && continue # echo "${file_name} has no run script" && continue
  [[ -e ${f}IGNORE ]] && continue # Explicitly ignored
  echo "Collecting results for $file_name"
  # (cd $PARENT_DIR && ${ABS_SCRIPT_DIR}/build-and-test.sh "${file_name}" > from-${file_name}.out 2>&1  &) # && sleep 10

  mkdir results/${file_name}
  cp run-${file_name}.out results/  # copy main output
  cp ${file_name}/fuzz-*.log results/${file_name}/  # copy fuzz-0.log ...
done

