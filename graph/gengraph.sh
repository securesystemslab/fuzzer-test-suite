#!/bin/bash

rm -f temp_*.csv
rm -f *.pdf

for i in {0..9}
do
    grep -E 'BENCHMARK' fuzz-$i.log | sed -e "s/#[0-9]*\t//" -e 's/BENCHMARK //' -e 's/cov: //' -e 's/ft: //' -e 's/corp: //' -e 's/\//\t/' -e 's/Kb/000/g' -e 's/Mb/000000/g' -e 's/Gb/000000000/g' -e 's/b//g'  -e 's/exec\/s: //' -e 's/ rss://' > temp_$i.csv
done

./gengraph_av.sh temp_0.csv temp_1.csv temp_2.csv temp_3.csv temp_4.csv temp_5.csv temp_6.csv temp_7.csv temp_8.csv temp_9.csv > temp_average.csv

gnuplot -c plot.sh 'cov' 1 -persist
gnuplot -c plot.sh 'ft' 2 -persist
gnuplot -c plot.sh 'corp\_units' 3 -persist
gnuplot -c plot.sh 'corp\_size' 4 -persist
gnuplot -c plot.sh 'exec' 5 -persist
gnuplot -c plot.sh 'rss' 6 -persist


gnuplot -c plot_average.sh 'cov\_average' 1 -persist
gnuplot -c plot_average.sh 'ft\_average' 2 -persist
gnuplot -c plot_average.sh 'corp\_units\_average' 3 -persist
gnuplot -c plot_average.sh 'corp\_size\_average' 4 -persist
gnuplot -c plot_average.sh 'exec\_average' 5 -persist
gnuplot -c plot_average.sh 'rss\_average' 6 -persist
rm temp_*.csv
