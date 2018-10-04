library(data.table)

raw <- fread("raw_reads.count")
setorder(raw,sample,trial)

raw[,list(reads=sum(count)),by=list(sample)]
