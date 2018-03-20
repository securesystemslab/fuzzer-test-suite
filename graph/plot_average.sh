#!/usr/local/bin/gnuplot --persist

reset
set term pdf
set output ARG3.'_'.ARG1.'.pdf'
set ylabel ARG1
col=ARG2 + 0
set title "Julian's nice work"
set style data linespoints
plot 'baseline_'.ARG3.'_average.csv' using col t "Average" lc -1, \
            'p2_'.ARG3.'_average.csv' using col t "Average" lc 1, \
            'simpler_'.ARG3.'_average.csv' using col t "Average" lc 2
