#!/usr/local/bin/gnuplot --persist

reset
set term pdf
set output ARG4.'_'.ARG1.'.pdf'
set ylabel ARG1
col=ARG2 + 0
num_bench=ARG3 - 1
set title "Julian's nice work"
set style data linespoints

plot for [i=0:num_bench] 'baseline_'.ARG4.'_'.i.'.csv' using col t ''.i.'' lc -1,\
 for [i=0:num_bench] 'p2_'.ARG4.'_'.i.'.csv' using col t ''.i.'' lc 1,\
 for [i=0:num_bench] 'simpler_'.ARG4.'_'.i.'.csv' using col t ''.i.'' lc 2,\
