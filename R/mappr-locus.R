library("data.table")
library("parallel")
library("naturalsort")
library("scales")

mappr_locus <- function(ed4_file,sample_name,min_dep,tmp_wid,sliding_wind){

  fai_cols <- c("name", "length", "offset", "linebases", "linewidth")
  out_cols <- c("chr", "start", "mid",  "end", "pval",  "adj.pval", "log.pval")
  chr_ed4 <- fread(ed4_file)
  chr_ed4
  
  chr_prop = c(NROW(chr_ed4[ed4>1]),NROW(chr_ed4[ed4<=1]))
  #hard coded, make sure to change later
  v4_chr <- fread("genome/maize_v4.chrs.fa.fai")
  colnames(v4_chr) <- fai_cols
  
  evals <- lapply(v4_chr$name,function(chr_name){
    print(chr_name)
    chr_length=v4_chr[name==chr_name]$length
    starts=seq(0,chr_length,sliding_wind)
    region_ed4 <- chr_ed4[chr==chr_name]
    
    out_stat <- mclapply(starts,function(start,chr_prop,chr_ed4,tmp_wid,region_ed4){
    #out_stat <- lapply(starts,function(start,chr_prop,chr_ed4,tmp_wid,region_ed4){
      end=start+tmp_wid
      mid=(start+end)/2
      locus_ed4 <- region_ed4[pos>=start & pos <= end]
      tmp_mat <- cbind(c(NROW(locus_ed4[ed4>1]),NROW(locus_ed4[ed4<=1])),chr_prop)
      # print(tmp_mat)
      ft_res <- fisher.test(tmp_mat)
      out <- c(mid=mid,pval=ft_res$p.value,start=start,end=end)
    #},chr_prop,chr_ed4,tmp_wid,region_ed4)
    },chr_prop,chr_ed4,tmp_wid,region_ed4,mc.cores = 4)
    out_dt <- data.table(do.call(rbind,out_stat))
    out_dt[,chr:=chr_name]
  })
  
  eval_dt <- data.table(do.call(rbind,evals))
  eval_dt[,adj.pval:=p.adjust(pval,method = "bonferroni")]
  eval_dt[,log.pval:=-10*log(adj.pval,base = 10)]
  eval_dt[,chr:=factor(chr,levels = naturalsort(v4_chr$name))]
  eval_dt[,sample:=sample_name]
  setcolorder(eval_dt,out_cols)
  
  out_file <-paste("mappr/",sample_name,".",min_dep,".mappr-locus.tsv",sep="")
  write.table(eval_dt,out_file,quote = F,sep = "\t",row.names = F)
  
  print("Plotting Graph")
  wid = 11
  hei = 8.5
  resol=300
  
  plot_f <- paste("plots/",sample_name,".",min_dep,".mappr-locus.png",sep="")
  p <- ggplot(eval_dt,aes(x=mid,y=log.pval,color=chr))
  p <- p + geom_point() 
  p <- p + facet_grid(.~chr,space = "free_x",scales = "free_x" ) 
  p <- p + scale_color_manual(values = rep(c("blue","red"),5))
  p <- p + theme(axis.text.x = element_blank(),axis.ticks.x = element_blank(),panel.spacing.x = unit(0.1,"lines"))
  p <- p + guides(color=F)
  p
  ggsave(plot_f,width = wid,height = hei,dpi = resol)
}