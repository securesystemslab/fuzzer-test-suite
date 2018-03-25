#!/bin/bash

root_dir="../fuzz-results"
output_dir="results"

num_of_bench=0

for dir in $root_dir\/* 
do
    scheme=$(basename "$dir")
    benches[$num_of_bench]=$scheme
    num_of_bench=$((num_of_bench + 1))
    
    for ben in $root_dir\/$scheme\/*
    do
        if [ -d "$ben" ]; then
            benchmark=$(basename "$ben")
            num_of_log=$(ls $root_dir\/$scheme\/$benchmark\/ | wc -l) 
            if [ $num_of_log -ne 10 ]
            then
                echo "wrong number ($num_of_log) of log files for $scheme/$benchmark"
                exit 1
            fi
            for((k=0; k<$num_of_log ; k++))
            do
                grep -E 'BENCHMARK cov:' $root_dir\/$scheme/$benchmark/fuzz-$k\.log | sed -e "s/.*#[0-9]*\t//" -e 's/BENCHMARK //' -e 's/cov: //' -e 's/ft: //' -e 's/corp: //' -e 's/\//\t/' -e 's/Kb/000/g' -e 's/Mb/000000/g' -e 's/Gb/000000000/g' -e 's/b//g'  -e 's/exec\/s: //' -e 's/ rss://' > $scheme\_$benchmark\_$k\.csv
            done
            # if [ $num_of_log -ne 0 ]
            # then
            #     ./gengraph_geomean.sh $scheme\_$benchmark\_*.csv > geomean_$scheme\_$benchmark\_old.csv 
            # fi
            # ./gengraph_geomean.py $scheme\_$benchmark\_ > geomean_$scheme\_$benchmark\.csv || exit
        fi
    done
done

./pretty_plot.py
exit 0

#echo ${benches[0]}
#echo ${benches[1]}
#echo ${benches[2]}
#echo $num_of_bench

#argument are column name, column number, number of files, and file name


for file in *_1.csv 
do
    benchmark=$file
    suffix='_1.csv'
    benchmark=${benchmark%$suffix}
    for dir in $root_dir\/*
    do
        prefix=$(basename "$dir")
        prefix=$prefix\_
        benchmark=${benchmark#$prefix}
    done


    max_of_csv=0
    for dir in $root_dir\/*
    do
        scheme=$(basename "$dir")
        num_of_csv=$(ls $scheme\_$benchmark\_*.csv | wc -l)
        if [ $max_of_csv -lt $num_of_csv ]
        then
            max_of_csv=$num_of_csv
        fi
    done

    gnuplot -c plot.sh 'cov' 1 $max_of_csv $benchmark -persist
    gnuplot -c plot.sh 'ft' 2 $max_of_csv $benchmark -persist
    gnuplot -c plot.sh 'corp_units' 3 $max_of_csv $benchmark -persist
    gnuplot -c plot.sh 'corp_size' 4 $max_of_csv $benchmark -persist
    gnuplot -c plot.sh 'exec' 5 $max_of_csv $benchmark -persist
    gnuplot -c plot.sh 'rss' 6 $max_of_csv $benchmark -persist


    gnuplot -c plot_geomean.sh 'cov_geomean' 1 $benchmark -persist
    gnuplot -c plot_geomean.sh 'ft_geomean' 2 $benchmark -persist
    gnuplot -c plot_geomean.sh 'corp_units_geomean' 3 $benchmark -persist
    gnuplot -c plot_geomean.sh 'corp_size_geomean' 4 $benchmark -persist
    gnuplot -c plot_geomean.sh 'exec_geomean' 5 $benchmark -persist
    gnuplot -c plot_geomean.sh 'rss_geomean' 6 $benchmark -persist

done


rm -rf $output_dir
mkdir $output_dir
mkdir $output_dir/csv

mv *.csv $output_dir/csv
mv *.pdf $output_dir
