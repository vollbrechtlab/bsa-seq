library("data.table")
library("parallel")

get_genome_cov <- function(basename){
  genome_data <- fread("genome/maize_v4.chrs.fa.fai")
  fai_cols <- c("name", "length", "offset", "linebases", "linewidth")
  colnames(genome_data) <- fai_cols
  genome_size <- sum(genome_data$length)
  
  mut_file = dir(path="cov",pattern = paste(basename,"_mut*",sep=""),full.names = T)
  
  if(length(mut_file)==0){
    mut_file = dir(path="cov",pattern = paste(basename,"_str*",sep=""),full.names = T)
  }
  norm_file = dir(path="cov",pattern = paste(basename,"_norm*",sep=""),full.names = T)
  if(length(norm_file)==0){
    norm_file = dir(path="cov",pattern = paste(basename,"_wk*",sep=""),full.names = T)
  }
  
  print(mut_file)
  print(norm_file)
  
  mut_data  <- fread(mut_file)
  norm_data <- fread(norm_file)
  
  mut_filt <- mut_data#[depth>=30 & depth <=250]
  norm_filt <- norm_data#[depth>=30 & depth <=250]
  
  all_poss <- merge(mut_filt[,.(chr,pos)],norm_filt[,.(chr,pos)])
  (NROW(all_poss)/genome_size)*100
  mut_cov <- round(NROW(mut_filt)/genome_size*100,4)
  norm_cov <- round(NROW(norm_filt)/genome_size*100,4)
  both_cov <- round(NROW(all_poss)/genome_size*100,4)
  return(list(geno=basename,mut.cov=mut_cov,norm.cov=norm_cov,shared.cov=both_cov))
}