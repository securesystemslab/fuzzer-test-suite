#!/usr/bin/env python

import sys
import matplotlib.pyplot as plt
from scipy.stats.mstats import gmean

configs = ['baseline', 'simpler']
config_labels = ['Baseline', 'PartiSan']
config_colors = ['green', 'blue', 'yellow']
config_linestyles = ['--', '-', '-.']
benchmarks = ['boringssl-2016-02-12', 'guetzli-2017-3-30', 'harfbuzz-1.3.2',
'json-2017-02-12', 'lcms-2017-03-21', 'libarchive-2017-01-04', 'libjpeg-turbo-07-2017',
'libpng-1.2.56', 'openssl-1.1.0c', 'openthread-2018-02-27', 'sqlite-2016-11-14',
'woff2-2016-05-06', 'wpantund-2018-02-27']
types = ['coverage', 'features', 'corpus-units', 'corpus-size', 'exec-s', 'rss']
type_labels = ['coverage', 'features', 'corpus units', 'corpus size', 'exec/s', 'rss']
num_files = 10


def compute_data(cfg, bench):
    file_scheme = cfg + '_' + bench + '_'
    files = [open(file_scheme+str(i)+'.csv') for i in range(num_files)]

    # data types -> series
    data = [[] for _ in types]
    deaths = []
    line_no = 0

    while files:
        finished_files = []
        line_no += 1
        # Collect related values across files
        values = [[] for _ in types]
        for f in files:
            line = f.readline()
            if line:
                line_values = line.split()
                assert len(line_values) == len(types)
                for i in range(len(types)):
                    val = int(line_values[i])
                    assert val > 0 or i == 4    # exec/s might be zero which is a problem for geomean
                    val = max(val, 1)
                    values[i].append(val)
            else:
                deaths.append(line_no)
                finished_files.append(f)

        # Remove exhausted files
        for f in finished_files:
            files.remove(f)
            f.close()

        if files:
            gms = [gmean(val) for val in values]
            for i in range(len(types)):
                data[i].append(gms[i])

    return data, deaths


for bench in benchmarks:
    # config -> (data types -> series, deaths)
    all_data = [compute_data(cfg, bench) for cfg in configs]
    for t in range(len(types)):
        plt.figure(figsize=(8, 4.5))  # default: (8, 6)
        plt.ylabel(type_labels[t])
        plt.xlabel('minutes')

        for c in range(len(configs)):
            data, deaths = all_data[c]
            series = data[t]
            plt.plot(series, label=config_labels[c], linewidth=1.2, linestyle=config_linestyles[c], color=config_colors[c])
            x_lookup_max = len(series) - 1  # Special case for last data point
            deaths_y = [series[min(x, x_lookup_max)] for x in deaths]
            plt.plot(deaths, deaths_y, linestyle='None', marker='x', color='black', markersize=8, markeredgewidth=0.8)

        plt.legend(loc='lower right', shadow=True)
        file_name = bench + '_' + types[t] + '_gmean.pdf'
        plt.savefig(file_name, bbox_inches='tight')
        plt.close()

