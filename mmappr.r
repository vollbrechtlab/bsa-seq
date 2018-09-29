#install.packages("ggplot2")
#install.packages("data.table")
#install.packages("naturalsort")
#install.packages("reshape2")
#install.packages("dplyr")
#source("http://bioconductor.org/biocLite.R")
#biocLite("edgeR")
#biocLite("goseq")
#install.packages("fields")
#install.packages("locfit")

library("ggplot2")
library("data.table")
library("naturalsort")
library("scales")
#library("dplyr")
library("splines")
library("locfit")
#library("Cairo")
#library("MASS")


#options(bitmapType='cairo')

args <- commandArgs(trailingOnly = TRUE)
#args <- c("mpileup/ra3_ki11_str.30.nuc","mpileup/ra3_ki11_wk.30.nuc","plots/ra3_ki11","ra3_ki11 Data", 30)
args <- c("mpileup/trial2.6876_mut.30.nuc","mpileup/trial2.6876_norm.30.nuc","6876","6876 Data", 30)

wt_f <- args[1]
mt_f <- args[2]

print(wt_f)
print(mt_f)

min_dep <- as.numeric(args[5])
cols <- c("A","C","G","T")

print("Loading Wild Type data")
wt <- fread(wt_f,header = T)
wt[,(cols):=lapply(.SD,"/",dep),.SDcols = cols]

print("Loading Mutant data")
mt <- fread(mt_f,header = T)
mt[,(cols):=lapply(.SD,"/",dep),.SDcols = cols]

shared_pos <- merge(wt[,.(chr,pos)],mt[,.(chr,pos)],by = c("chr","pos"))

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

#if(TRUE){

tmp_ed <- chr_ed4
data.table::setorder(tmp_ed,chr,pos)

write.table(chr_ed4,file = paste("ed4/",args[3],".",min_dep,".tsv",sep = ""),quote = F,sep = "\t",row.names = F)


plot_f <- paste("plots/",args[3],".ed4.",min_dep,".point.png",sep="")
p <- ggplot(tmp_ed,aes(x=pos,y=ed4,color=chr))
p <- p + geom_point() 
p <- p + facet_grid(.~chr,space = "free_x",scales = "free_x" ) 
p <- p + scale_color_manual(values = rep(c("blue","red"),5))
p <- p + theme(axis.text.x = element_blank(),axis.ticks.x = element_blank(),panel.spacing.x = unit(0,"lines")) #+ geom_hline(aes(yintercept=1))
p <- p + guides(color=F)
p
ggsave(plot_f,width = wid,height = hei,dpi = resol)


plot_f <- paste("plots/",args[3],".ed4.",min_dep,".smooth.png",sep="")
nn_prop=0.2
p <- ggplot(tmp_ed,aes(x=pos,y=ed4,color=chr))
p <- p + stat_smooth(method=locfit,formula=y~lp(x,nn=nn_prop)) #geom_point()
p <- p + scale_x_continuous(breaks=seq(min(tmp_ed$pos),max(tmp_ed$pos),by=20000000),labels=comma)
p <- p + facet_grid(.~chr,space = "free_x",scales = "free_x" ) 
p <- p + theme(axis.text.x= element_blank(),axis.ticks.x = element_blank(),panel.spacing.x = unit(0,"lines"))
p <- p + guides(color=F)
p
ggsave(plot_f,width = wid,height = hei,dpi = resol)

