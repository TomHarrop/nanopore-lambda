#!/usr/bin/env Rscript

library(data.table)
library(ggplot2)

# load stats
basecov <- fread("output/bwamem/basecov.txt")
hist <- fread("output/bwamem/hist.txt")
bincov <- fread("output/bwamem/bincov.txt")
readlength <- fread("output/read_stats/readlength.txt")
idhist_mapped <- fread("output/read_stats/idhist_mapped.txt")
aqhist_mapped <- fread("output/read_stats/aqhist_mapped.txt")
qahist_mapped <- fread("output/read_stats/qahist_mapped.txt")
mhist_mapped <- fread("output/read_stats/mhist_mapped.txt")
qhist_mapped <- fread("output/read_stats/qhist_mapped.txt")
lhist_mapped <- fread("output/read_stats/lhist_mapped.txt")

# error type by read position
ggplot(melt(mhist_mapped, id = "#BaseNum"),
       aes(x = `#BaseNum`, y = value, colour = variable, group = variable)) +
    scale_x_log10() +
    geom_path()

# average percent identity (mapped)
ggplot(idhist_mapped, aes(x = `#Identity`, y = Reads)) +
    geom_col()
ggplot(idhist_mapped, aes(x = `#Identity`, y = Bases)) +
    geom_col()

# average read quality
ggplot(aqhist_mapped, aes(x = `#Quality`, y = count1)) +
    geom_col()

# mapped quality vs. reported quality: Each point on the qahist indicates the
# claimed quality (from the quality scores) versus the measured quality (based
# on the alignment match/mismatch rate). So, for example, you have a point at
# X=22, Y=13. That means that if you take all bases with a stated quality score
# of Q22 (roughly 99.3% accuracy), on average, they have an error rate
# indicating Q13 (roughly 95% accuracy).
ggplot(qahist_mapped, aes(x = `#Quality`, y = TrueQuality)) +
    coord_fixed() +
    geom_path()

# mapped read length
ggplot(lhist_mapped, aes(x = `#Length`, y = Count)) +
    scale_x_log10() +
    geom_point() +
    geom_smooth()

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
