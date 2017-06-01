#!/usr/bin/env Rscript

library(data.table)
library(ggplot2)

# load stats
basecov <- fread("output/bwamem/basecov.txt")
hist <- fread("output/bwamem/hist.txt")
bincov <- fread("output/bwamem/bincov.txt")
readlength <- fread("output/read_stats/readlength.txt")

# plot readlength
readlength[, pct_reads := as.numeric(gsub("%", "", pct_reads))]
ggplot(readlength, aes(x = `#Length`, y = reads)) +
    scale_x_log10() +
    xlim(c(0, 1e5)) +
    geom_path()

# plot bascov
ggplot(basecov, aes(x = Pos, y = Coverage)) +
    geom_path()

# plot bincov
ggplot(bincov, aes(x = RunningPos, y = Cov)) +
    geom_path()


# plot hist
ggplot(hist, aes(x = `#Coverage`, y = numBases)) +
    geom_path()
