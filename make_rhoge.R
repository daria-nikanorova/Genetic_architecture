#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

require(data.table)
library(dplyr)
library(reshape)
library(ggplot2)
library(superheat)
library(RHOGE)
library(MASS)
library(stringr)
library(stats)
library("RColorBrewer")

#setwd
current_path <- args[1] 
setwd(current_path)

#set phenos (2/21)
pheno1 <- paste0(args[5], "_.*_all.tsv")
short_pheno1 <- args[6]

pheno2 <- args[2]
pheno2
pheno2 <- paste0(pheno2, "_.*_all.tsv")

short_pheno2 <- args[3]
short_pheno2

N_pheno2 <- as.numeric(args[4])
N_pheno2

#a function to merge all twas results from all tissues for 1 phenotype
merge_all_data <- function (folder_files){
  do.call(rbind, lapply(folder_files, function(x) fread(x, stringsAsFactors = F, header = T)))
}

#create 2 lists of phenotypes for which correlation will be estimated
PATH_PHENO1 <- list.files(path = current_path, pattern = pheno1, recursive = T, ignore.case = T, full.names = T)
PATH_PHENO2 <- list.files(path = current_path, pattern = pheno2, recursive = T, ignore.case = T, full.names = T)

#apply a merge_all_data function to each directory, get a list
list_of_tissues_pheno1 <- lapply(PATH_PHENO1, function(x) merge_all_data(x))
list_of_tissues_pheno2 <- lapply(PATH_PHENO2, function(x) merge_all_data(x))

#for each phenotype add new variable with sample size
list_of_N <- c(as.numeric(args[7]), N_pheno2)
list_of_N

for(i in 1:length(list_of_tissues_pheno1)){
  list_of_tissues_pheno1[[i]][,'n_samples'] <- list_of_N[1] 
}

for(i in 1:length(list_of_tissues_pheno2)){
  list_of_tissues_pheno2[[i]][,'n_samples'] <- list_of_N[2] 
}

#calculate a correlation between 2 phenotypes
rhoge_2_phenos <- sapply(c(1:16), function(i){
  out <- try(rhoge.gw(list_of_tissues_pheno1[[i]], list_of_tissues_pheno2[[i]], list_of_tissues_pheno1[[1]]$n_samples[1], list_of_tissues_pheno2[[1]]$n_samples[1], regions = grch37.eur.loci))
  if (!inherits(out, "try-error")){
    rhoge.gw(list_of_tissues_pheno1[[i]], list_of_tissues_pheno2[[i]], list_of_tissues_pheno1[[1]]$n_samples[1], list_of_tissues_pheno2[[1]]$n_samples[1], regions = grch37.eur.loci)
  }else{
    data.frame(RHOGE = NA, SE = NA, TSTAT = NA, DF = NA, P = NA)
  }}
)

rhoge_cor <- sapply(c(1:16), function(i) rhoge_2_phenos[,i]$RHOGE)
rhoge_pval <- sapply(c(1:16), function(i) rhoge_2_phenos[,i]$P)

#make data frame
tissues <- c("Amygdala", "Anterior_cingulate_cortex", "Caudate", "Cerebellar_hemisphere", "Cerbellum", "Cortex", "Frontal_cortex", "Hippocampus", "Hypothalamus", "Nucleus_accumbens", "Putamen", "Spinal_cord", "Substantia_nigra", "Colon_sigmoid", "Colon_transverse", "Whole_blood" )

cor_2_phenos <- data.frame(tissue = tissues,
                           correlation = rhoge_cor, 
                           p_value = rhoge_pval,
                           log_pval = -log10(rhoge_pval))


cor_2_phenos$p_FDR <- p.adjust(cor_2_phenos$p_value, method = 'fdr', n = 320)
cor_2_phenos$p_Bonf <- p.adjust(cor_2_phenos$p_value, method = 'bonferroni', n = 320)

#create new col "significance": *-p_FDR<0.05, **-p_Bonf<0.05
cor_2_phenos <- cor_2_phenos %>% 
  mutate(significance = "-") %>% 
  mutate_at(., vars(significance), funs(ifelse((p_FDR < 0.05), "FDR significant", "non-significant"))) %>%
  mutate_at(., vars(significance), funs(ifelse((p_Bonf < 0.05), "Bonferroni significant", .)))

cor_2_phenos

#create a plot
pval <- -log10(0.05)
adj_pval <- -log10(0.05/320)

cols <- c("non-significant" = "Black", "Bonferroni significant" = "Red", "FDR significant" = "Green")

my_plot <- ggplot(cor_2_phenos, aes(x = correlation, y = log_pval)) +
  geom_point(aes(color = significance)) +
  scale_color_manual(values = cols,
                     drop = T) +
  geom_hline(yintercept = adj_pval, linetype = 2, color = "red") +
  geom_hline(yintercept = pval, linetype = 2, color = "grey") +
  geom_vline(xintercept = 0) +
  theme_classic() +
  geom_text(aes(label = tissue), vjust = -0.5, hjust = -0.05, size = 4) +
  scale_x_continuous(breaks = seq(-1, 1, 0.1), 
                     limits = c(-1, 1)) +
  scale_y_continuous(name = "-logP",
                     breaks = c(round(pval,1), round(adj_pval, 1), seq(0, 1))) +
  theme(legend.position = "none")
                  

setwd(args[8])

#save plot
ggsave(filename = paste0(short_pheno1, "_", sh_ph, "_test", ".pdf"), plot = my_plot, device = "pdf", width = 6, height = 4)

#save correlation results
write.table(cor_2_phenos, paste0(short_pheno1, "_", sh_ph, '_cor', '.tsv'), sep='\t', row.names = F)
