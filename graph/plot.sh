#!/usr/local/bin/gnuplot --persist

reset
set term pdf
set output ARG1.'.pdf'
set ylabel ARG1
col=ARG2 + 0
set title "Julian's nice work"
set style data linespoints
plot "temp_0.csv" using col t "1" lc -1, \
     "temp_1.csv" using col t "2" lc -1, \
     "temp_2.csv" using col t "3" lc -1, \
     "temp_3.csv" using col t "4" lc -1, \
     "temp_4.csv" using col t "5" lc -1, \
     "temp_5.csv" using col t "6" lc -1, \
     "temp_6.csv" using col t "7" lc -1, \
     "temp_7.csv" using col t "8" lc -1, \
     "temp_8.csv" using col t "9" lc -1, \
     "temp_9.csv" using col t "10" lc -1 
