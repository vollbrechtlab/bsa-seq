library("data.table")

function <- get_genome_cov(basename){
  genome_data <- fread("genome/maize_v4.chrs.fa.fai")
  genome_size <- sum(genome_data$length)
  
  mut_data <- fread("cov/trial2.6792_mut.cov")
  norm_data <- fread("cov/trial2.6792_norm.cov")
  
  mut_filt <- mut_data[depth>=30 & depth <=250]
  norm_filt <- norm_data[depth>=30 & depth <=250]
  
  all_poss <- merge(mut_filt[,.(chr,pos)],norm_filt[,.(chr,pos)])
  (NROW(all_poss)/genome_size)*100
  mut_cov <- NROW(mut_filt)/genome_size*100
  norm_cov <- NROW(norm_filt)/genome_size*100
  both_cov <- NROW(all_poss)/genome_size*100
  return(c(mut_cov,norm_cov,both_cov))
}