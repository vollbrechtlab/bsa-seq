library("ggplot2")
library("data.table")
library("naturalsort")
library("scales")
library("splines")
library("locfit")


mappr <- function(wt_f,mt_f,sample_name,min_dep){
  print(wt_f)
  print(mt_f)
  cols <- c("A","C","G","T")
  
  print("Loading Wild Type data")
  wt <- fread(wt_f,header = T)
  wt[,(cols):=lapply(.SD,"/",dep),.SDcols = cols]
  
  print("Loading Mutant data")
  mt <- fread(mt_f,header = T)
  mt[,(cols):=lapply(.SD,"/",dep),.SDcols = cols]
  
  shared_pos <- merge(wt[dep>min_dep,.(chr,pos)],mt[dep>min_dep,.(chr,pos)],by = c("chr","pos"))
  
  wt_filt <- merge(wt,shared_pos,by = c("chr","pos"))
  mt_filt <- merge(mt,shared_pos,by = c("chr","pos"))
  
  diff = wt_filt[,cols,with=F] - mt_filt[,cols,with=F]
  diff_sq = diff^2
  ed4 <- sqrt(rowSums(diff_sq))^4
  
  chr_ed4 <- cbind(wt_filt[,.(chr,pos)],ed4)
  chrs = naturalsort(unique(chr_ed4$chr))
  chr_ed4$chr = factor(chr_ed4$chr,levels = chrs)
  
  print("Plotting Graph")
  wid = 11
  hei = 8.5
  resol=300
  
  tmp_ed <- chr_ed4
  data.table::setorder(tmp_ed,chr,pos)
  
  write.table(chr_ed4,file = paste("ed4/",sample_name,".",min_dep,".tsv",sep = ""),quote = F,sep = "\t",row.names = F)
  
  dim(tmp_ed)
  tmp_ed[ed4>0]
  
  plot_f <- paste("plots/",sample_name,".ed4.",min_dep,".point.png",sep="")
  p <- ggplot(tmp_ed[ed4>0],aes(x=pos,y=ed4,color=chr))
  p <- p + geom_point() 
  p <- p + facet_grid(.~chr,space = "free_x",scales = "free_x" ) 
  p <- p + scale_color_manual(values = rep(c("blue","red"),5))
  p <- p + theme(axis.text.x = element_blank(),axis.ticks.x = element_blank(),panel.spacing.x = unit(0,"lines")) #+ geom_hline(aes(yintercept=1))
  p <- p + guides(color=F)
  p
  ggsave(plot_f,width = wid,height = hei,dpi = resol)
  
  
  plot_f <- paste("plots/",sample_name,".ed4.",min_dep,".smooth.png",sep="")
  nn_prop=0.1
  p <- ggplot(tmp_ed,aes(x=pos,y=ed4,color=chr))
  p <- p + stat_smooth(method=locfit,formula=y~lp(x,nn=nn_prop)) #geom_point()
  p <- p + scale_x_continuous(breaks=seq(min(tmp_ed$pos),max(tmp_ed$pos),by=20000000),labels=comma)
  p <- p + facet_grid(.~chr,space = "free_x",scales = "free_x" ) 
  p <- p + theme(axis.text.x= element_blank(),axis.ticks.x = element_blank(),panel.spacing.x = unit(0,"lines"))
  p <- p + guides(color=F)
  p
  ggsave(plot_f,width = wid,height = hei,dpi = resol)

}