README
================

# Reading and writing benchmarks

Benchmarks of reading and writing csv files with data.table::fread() and
data.table::fwrite() versus readr::read\_csv() and readr::write\_csv().

Related to
    <https://github.com/tidyverse/readr/issues/931>.

## Table of reading and writing benchmarks:

    ##     threads size_MB write_csv read_csv fwrite fread write_ratio read_ratio
    ##  1:       4      26     0.814    0.706  0.159 0.076         5.1        9.3
    ##  2:       4     106     3.212    1.655  0.609 0.260         5.3        6.4
    ##  3:       4     268     9.118    3.939  0.620 0.410        14.7        9.6
    ##  4:       4     537    15.950    6.937  1.890 0.831         8.4        8.3
    ##  5:       4    1084    40.195   15.693  3.624 1.839        11.1        8.5
    ##  6:       1      26     0.983    0.337  0.212 0.107         4.6        3.1
    ##  7:       1     106     3.064    1.623  0.608 0.413         5.0        3.9
    ##  8:       1     268     9.724    3.205  1.549 0.855         6.3        3.7
    ##  9:       1     537    18.430    6.479  3.114 1.697         5.9        3.8
    ## 10:       1    1084    34.267   13.330  6.078 3.426         5.6        3.9

In single thread mode, fread is an average 3.7 times faster at reading
and 5.5 times faster at writing. In multithread mode — which is the
default — fread is 8.4 times faster at reading and 8.9 times faster at
writing.
