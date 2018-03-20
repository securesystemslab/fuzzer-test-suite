#!/bin/bash

ben0='boringssl-2016-02-12'
ben1='c-ares-CVE-2016-5180'
ben2='freetype2-2017'
ben3='guetzli-2017-3-30'
ben4='harfbuzz-1.3.2'
ben5='json-2017-02-12'
ben6='lcms-2017-03-21'
ben7='libarchive-2017-01-04'
ben8='libjpeg-turbo-07-2017'
ben9='libpng-1.2.56'
ben10='libssh-2017-1272'
ben11='libxml2-v2.9.2'
ben12='openssl-1.0.1f'
ben13='openssl-1.0.2d'
ben14='pcre2-10.00'
ben15='proj4-2017-08-14'
ben16='proj4-2017-08-14'
ben17='woff2-2016-05-06'



rm -f *.csv
rm -f *.pdf

num_scheme=$(ls ../fuzz-results | wc -l)
num_ben=18


for dir in ../fuzz-results/* ;
do
    scheme=$(basename "$dir")
    for((j=0; j < $num_ben ; j++))
    do
        benchmark=ben$j
        num_of_bench=$(ls ../fuzz-results/$scheme/${!benchmark} | wc -l) 
        for((k=0; k<$num_of_bench ; k++))
        do
            grep -E 'BENCHMARK cov:' ../fuzz-results/$scheme/${!benchmark}/fuzz-$k\.log | sed -e "s/#[0-9]*\t//" -e 's/BENCHMARK //' -e 's/cov: //' -e 's/ft: //' -e 's/corp: //' -e 's/\//\t/' -e 's/Kb/000/g' -e 's/Mb/000000/g' -e 's/Gb/000000000/g' -e 's/b//g'  -e 's/exec\/s: //' -e 's/ rss://' > $scheme\_${!benchmark}\_$k\.csv
        done
        if [ $num_of_bench -ne 0 ]
        then
            ./gengraph_av.sh $scheme\_${!benchmark}\_*.csv > $scheme\_${!benchmark}\_average.csv 
        fi

    done
done



#argument are column name, column number, number of files, and file name
for((i=0 ; i < $num_ben ; i++))
do
    benchmark=ben$i
    #Here we assume the number of log files are the same as baseline's
    num_of_bench=$(ls ../fuzz-results/baseline/${!benchmark} | wc -l)
    gnuplot -c plot.sh 'cov' 1 $num_of_bench ${!benchmark} -persist
    gnuplot -c plot.sh 'ft' 2 $num_of_bench ${!benchmark} -persist
    gnuplot -c plot.sh 'corp\_units' 3 $num_of_bench ${!benchmark} -persist
    gnuplot -c plot.sh 'corp\_size' 4 $num_of_bench ${!benchmark} -persist
    gnuplot -c plot.sh 'exec' 5 $num_of_bench ${!benchmark} -persist
    gnuplot -c plot.sh 'rss' 6 $num_of_bench ${!benchmark} -persist


    gnuplot -c plot_average.sh 'cov\_average' 1 ${!benchmark} -persist
    gnuplot -c plot_average.sh 'ft\_average' 2 ${!benchmark} -persist
    gnuplot -c plot_average.sh 'corp\_units\_average' 3 ${!benchmark} -persist
    gnuplot -c plot_average.sh 'corp\_size\_average' 4 ${!benchmark} -persist
    gnuplot -c plot_average.sh 'exec\_average' 5 ${!benchmark} -persist
    gnuplot -c plot_average.sh 'rss\_average' 6 ${!benchmark} -persist
done


rm *.csv
