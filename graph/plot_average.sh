#!/usr/local/bin/gnuplot --persist

reset
set term pdf
set output ARG1.'.pdf'
set ylabel ARG1
col=ARG2 + 0
set title "Julian's nice work"
set style data linespoints
plot "temp_average.csv" using col t "1" lc -1
