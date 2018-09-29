library("data.table")
library("naturalsort")

in_data <- fread("ed4/6876.30.tsv")
summary(in_data$ed4)


wt[A > 0.1 &  A <= 0.8]
wt[C>=0.3 & C <= 0.7]
wt[G>=0.3 & G <= 0.7]
wt[T>=0.3 & T <= 0.7]

idx = (wt_filt$A - mt_filt$A)>0 | (wt_filt$C - mt_filt$C)>0 | (wt_filt$G - mt_filt$G)>0 | (wt_filt$T - mt_filt$T)>0
in_data[ed4>0.8,.(pos,ed4)]
