source("R/mmappr.R")
source("R/mappr-locus.R")

#trial1

mappr("mpileup/trial1.6792_mut.10.nuc","mpileup/trial1.6792_norm.10.nuc","trial1.6792",10)
mappr_locus("ed4/trial1.6792.10.tsv","trial1.6792",10,2000000,1000000)


mappr("mpileup/trial1.6876_mut.10.nuc","mpileup/trial1.6876_norm.10.nuc","trial1.6876",10)
mappr_locus("ed4/trial1.6876.10.tsv","trial1.6876",10,2000000,1000000)


mappr("mpileup/trial1.6972_mut.10.nuc","mpileup/trial1.6972_norm.10.nuc","trial1.6972",10)
mappr_locus("ed4/trial1.6972.10.tsv","trial1.6972",10,2000000,1000000)

mappr("mpileup/trial1.fea2-nc350_str.10.nuc","mpileup/trial1.fea2-nc350_wk.10.nuc","trial1.fea2-NC350",10)
mappr_locus("ed4/trial1.fea2-NC350.10.tsv","trial1.fea2-NC350",10,2000000,1000000)

mappr("mpileup/trial1.ra3-ki11_str.10.nuc","mpileup/trial1.ra3-ki11_wk.10.nuc","trial1.ra3-Ki11",10)
mappr_locus("ed4/trial1.ra3-Ki11.10.tsv","trial1.ra3-Ki11",10,20000000,5000000)


#trial2

mappr("mpileup/trial2.6792_mut.10.nuc","mpileup/trial2.6792_norm.10.nuc","trial2.6792",10)
mappr_locus("ed4/trial2.6792.10.tsv","trial2.6792",10,2000000,1000000)

mappr("mpileup/trial2.6876_mut.10.nuc","mpileup/trial2.6876_norm.10.nuc","trial2.6876",10)
mappr_locus("ed4/trial2.6876.10.tsv","trial2.6876",10,2000000,1000000)

tmp_data <- fread("mappr/trial2.6876.10.mappr-locus.tsv")
tmp_data[order(log.pval,decreasing = T)]


plot(tmp_data[chr=="Chr6"]$mid,tmp_data[chr=="Chr6"]$log.pval)
