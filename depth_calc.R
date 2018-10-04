library("data.table")

get_genome_cov <- function(basename){
  genome_data <- fread("genome/maize_v4.chrs.fa.fai")
  genome_size <- sum(genome_data$length)
  
  mut_file = dir(path="cov",pattern = paste(basename,"_mut*",sep=""),full.names = T)
  
  if(length(mut_file)==0){
    mut_file = dir(path="cov",pattern = paste(basename,"_str*",sep=""),full.names = T)
  }
  norm_file = dir(path="cov",pattern = paste(basename,"_norm*",sep=""),full.names = T)
  if(length(norm_file)==0){
    norm_file = dir(path="cov",pattern = paste(basename,"_wk*",sep=""),full.names = T)
  }
  
  # print(mut_file)
  # print(norm_file)
  
  mut_data  <- fread(mut_file)
  norm_data <- fread(norm_file)
  
  mut_filt <- mut_data[depth>=30 & depth <=250]
  norm_filt <- norm_data[depth>=30 & depth <=250]
  
  all_poss <- merge(mut_filt[,.(chr,pos)],norm_filt[,.(chr,pos)])
  (NROW(all_poss)/genome_size)*100
  mut_cov <- round(NROW(mut_filt)/genome_size*100,4)
  norm_cov <- round(NROW(norm_filt)/genome_size*100,4)
  both_cov <- round(NROW(all_poss)/genome_size*100,4)
  return(list(geno=basename,mut.cov=mut_cov,norm.cov=norm_cov,shared.cov=both_cov))
}

if(F){
  chr_ed4
  
  v4_chr <- fread("genome/maize_v4.chrs.fa.fai")
  v4_chr
  tmp_chr="Chr4"
  tmp_wid=10000000
  sliding_wind <- 5000000
  starts=seq(1,v4_chr[name==tmp_chr]$length,sliding_wind)
  starts
  evals <- lapply(starts,function(x){
    start=x
    end=x+tmp_wid
    region_ed4 <- chr_ed4[chr==tmp_chr & pos>=start & pos <= end]
    tmp_mat <- cbind(c(NROW(region_ed4[ed4>1]),NROW(region_ed4[ed4<1])),c(NROW(chr_ed4[ed4>1]),NROW(chr_ed4[ed4<1])))
    print(tmp_mat)
    ft_res <- fisher.test(tmp_mat)
    out <- list(start,end,pval=ft_res$p.value)
    print(out)
  })
  
  eval_dt <- data.table(do.call(rbind,evals))
  eval_dt
  plot(-10*log(p.adjust(unlist(eval_dt$pval),method="bonferroni")))
  
  ?p.adjust
  NROW(chr_ed4[ed4>1])
  ?fisher.test
  chr_ed4
}