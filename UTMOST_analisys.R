#Firsly, data were formatted in a way suitable for UTMOST.
#Columns were renamed and only some columns were selected.

#It's an example for stroke disease. 

library(tidyr)
library(dplyr)
library(circlize)
library(viridis)


stroke <- read.csv('~/GWAS_data/29531354-GCST006906-EFO_0000712.h.tsv', sep = '\t')
stroke$Zscore <- stroke$hm_beta/stroke$standard_error 
stroke$SNP <- stroke$hm_rsid
stroke$A1 <- stroke$hm_effect_allele
stroke$A2 <- stroke$hm_other_allele
stroke$b <- stroke$hm_beta
stroke$p <- stroke$p_value
stroke_UTM <- stroke %>% select(SNP, A1, A2, b, p)
write.table(stroke_UTM, "/media/pro_milka/56b10cc5-cfc8-41ee-b57b-637401e16448/pro_milka/UTMOST/UTMOST/sample_data/GWAS/Stroke_GCST006906_UTMOST.txt", row.names=FALSE, quote=FALSE, sep = "\t")

#Then we used this file as an input for UTMOST software.
#To extract results from UTMOST output we did the following:

stroke <- read.csv('UPD_STROKE_Utmost.txt_GENES/UPD_STROKE_Utmost.txt_44_joint_1_17290.txt', sep = '\t')
# removing NA-raws
stroke <- na.omit(stroke)
# perform FDR p-value correction
stroke$P_FDR <- p.adjust(stroke$p_value, method = 'fdr')
stroke <- stroke[stroke$P_FDR < 0.05,]
#To save the results for UTMOST:
write.table(stroke, file="FDR/stroke_FDR.txt", row.names=FALSE, quote=FALSE, sep = "\t")


#when results for all of the traits were obtained, we calculated intersections between diseases in this way for example.
#TS means tourette syndrome.
intersect(stroke$gene, TS$gene)

#When all intersections were obtained in the way like this, we writted the values into a matrix to plot the data,

my_df_2 <- data.frame(AD = c(0, 0, 0, 0, 0, 0, 0, 0, 0), DLB = c(10, 0, 7, 0, 0, 0, 0, 0, 0),
                      PD = c(21, 0, 0, 0, 0, 0, 0, 0, 0), ADHD = c(1, 0, 1, 0, 0, 0, 0, 0, 0), 
                      AN = c(1, 1, 2, 10, 0, 0, 0, 0, 0), AUDIT = c(7, 1, 11, 2, 3, 0, 0, 0, 0), 
                      Headache = c(6, 0, 9, 6, 8, 25, 0, 0, 0), Prion = c(0, 0, 0, 1, 7, 0, 0, 0, 0),
                      Stroke = c(1, 0, 0, 0, 0, 0, 10, 0, 0))

row.names(my_df_2) = c("AD", "DLB", "PD", "ADHD", "AN", "AUDIT","Headache", "Prion", "Stroke")
mycolor <- viridis(100, alpha = 0.5, begin = 0, end = 1)
chordDiagram(
  x = my_df_2, 
  grid.col = mycolor,
  transparency = 0.1,
  directional = 1,
  direction.type = c("arrows", "diffHeight"), 
  diffHeight  = -0.04,
  annotationTrack = "grid", 
  annotationTrackHeight = c(0.05, 0.1),
  link.arr.type = "big.arrow", 
  link.sort = TRUE,
  link.largest.ontop = TRUE)



#to plot simple Venn diagramm, we used the following:

library(VennDiagram)
venn.diagram(x = list(AD$gene, PD$gene, DLB$gene), category.names = c('AD', 'PD', 'DLB'), filename = 'AD_PD_DLB.png',
             output = TRUE, imagetype = "png", scaled = FALSE, col = 'black',
             fill = c('red', 'blue', 'white'))


