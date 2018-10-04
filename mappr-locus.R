library("data.table")
library("parallel")


v4_chr <- fread("genome/maize_v4.chrs.fa.fai")
v4_chr
tmp_chr="Chr4"
tmp_wid=5000000
sliding_wind <- 2000000
starts=seq(1,v4_chr[name==tmp_chr]$length,sliding_wind)
starts
chr_prop = c(NROW(chr_ed4[ed4>1]),NROW(chr_ed4[ed4<1]))


evals <- mclapply(starts,function(x,chr_prop){
  start=x
  end=x+tmp_wid
  region_ed4 <- chr_ed4[chr==tmp_chr & pos>=start & pos <= end]
  tmp_mat <- cbind(c(NROW(region_ed4[ed4>1]),NROW(region_ed4[ed4<1])),chr_prop)
  ft_res <- fisher.test(tmp_mat)
  out <- list(start,end,pval=ft_res$p.value)
},chr_prop=chr_prop,mc.cores = 4)

eval_dt <- data.table(do.call(rbind,evals))
eval_dt
plot(starts,-10*log(p.adjust(unlist(eval_dt$pval),method="bonferroni")))