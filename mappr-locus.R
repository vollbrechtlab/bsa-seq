library("data.table")
library("parallel")
fai_cols <- c("name", "length", "offset", "linebases", "linewidth")

chr_ed4 <- fread("ed4/6792.20.tsv")
chr_ed4

v4_chr <- fread("genome/maize_v4.chrs.fa.fai")
colnames(v4_chr) <- fai_cols
tmp_chr="Chr4"
tmp_wid=5000000
sliding_wind <- 2000000
starts=seq(1,v4_chr[name==tmp_chr]$length,sliding_wind)
starts
chr_prop = c(NROW(chr_ed4[ed4>1]),NROW(chr_ed4[ed4<1]))

chr_starts <- apply(v4_chr[,.(name,length)],1,function(x){
  print(x)
  chr_name=x["name"]
  chr_length=as.numeric(x["length"])
  starts=seq(0,chr_length,sliding_wind)
  cbind(chr=chr_name,start=starts)
})

chr_starts <- data.table(do.call(rbind,chr_starts))
chr_starts

evals <- lapply(v4_chr$name,function(chr_name){
  print(chr_name)
  chr_length=v4_chr[name==chr_name]$length
  starts=seq(0,chr_length,sliding_wind)
  region_ed4 <- chr_ed4[chr==chr_name]
  
  out_stat <- mclapply(starts,function(start,chr_prop,chr_ed4,tmp_wid,region_ed4){
    end=start+tmp_wid
    mid=(start+tmp_wid)/2    
    locus_ed4 <- region_ed4[pos>=start & pos <= end]
    tmp_mat <- cbind(c(NROW(locus_ed4[ed4>1]),NROW(locus_ed4[ed4<1])),chr_prop)
    print(tmp_mat)
    ft_res <- fisher.test(tmp_mat)
    out <- c(mid=mid,pval=ft_res$p.value)
  },chr_prop,chr_ed4,tmp_wid=5000000,region_ed4,mc.cores = 4)
  out_dt <- data.table(do.call(rbind,out_stat))
  # print(out_dt)
  out_dt[,chr:=chr_name]
  # print(out_dt)
  # cbind(chr==chr_name,do.call(rbind,out_stat))
})

eval_dt <- data.table(do.call(rbind,evals))
eval_dt[,pval:=-10*log(p.adjust(pval,method = "bonferroni"),base = 10)]
eval_dt
eval_dt[,chr:=as.factor(chr)]



plot_f <- paste("plots/6792.10.mappr-test.png",sep="")
p <- ggplot(eval_dt,aes(x=mid,y=pval,color=chr))
p <- p + geom_point() 
p <- p + facet_grid(.~chr,space = "free_x",scales = "free_x" ) 
p <- p + scale_color_manual(values = rep(c("blue","red"),5))
p <- p + theme(axis.text.x = element_blank(),axis.ticks.x = element_blank(),panel.spacing.x = unit(0,"lines")) #+ geom_hline(aes(yintercept=1))
p <- p + guides(color=F)
p
ggsave(plot_f,width = wid,height = hei,dpi = resol)
