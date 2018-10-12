library("ggplot2")
library("data.table")
library("naturalsort")
library("scales")
library("intervals")

threshold <- -log(0.05,10)*10

mappr_locus("ed4/trial1.6792.10.tsv","trial1.6792",10,2000000,1000000)
fisher_data <- fread("mappr/trial1.6792.10.mappr-locus.tsv")
filter_data <- fisher_data[log.pval>threshold]
filter_data
a <- reduce(Intervals(filter_data[,.(start,end)]))
a
