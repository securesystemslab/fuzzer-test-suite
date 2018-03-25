#!/usr/bin/env python

import sys
from scipy.stats.mstats import gmean


num_files = 10
num_values = 6  # cov, ft, active units, corp size, execs, rss
file_scheme = sys.argv[1]
files = [open(file_scheme+str(i)+'.csv') for i in range(num_files)]

while files:
    finished_files = []
    # Collect related values
    values = [[] for _ in range(num_values)]
    for f in files:
        line = f.readline()
        if line:
            line_values = line.split()
            assert len(line_values) == num_values
            for i in range(num_values):
                val = int(line_values[i])
                assert val > 0 or i == 4    # exec/s might be zero which is a problem for geomean
                val = max(val, 1)
                values[i].append(val)
        else:
            finished_files.append(f)

    # Remove exhausted files
    for f in finished_files:
        files.remove(f)
        f.close()

    if files:
        gms = [gmean(data) for data in values]
        line = ' '.join(str(x) for x in gms)
        print(line)
