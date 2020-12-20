#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

library(stringr)
library(pheatmap)
library(tidyr)
library(dplyr)
library(ggplot2)

current_path <- args[1]
setwd(current_path)

pheno <- basename(current_path)


#create a list of files
PATH_PHENO <- list.files(path = current_path, pattern = "*.tsv", ignore.case = T, full.names = T)

list_of_phenotypes <- lapply(PATH_PHENO, function(x) read.table(x, header = TRUE, sep = "\t", ))

for (i in 1:20){
  list_of_phenotypes[[i]][2] <- round(list_of_phenotypes[[i]][2], 2)
  list_of_phenotypes[[i]]$phenos <- str_replace(basename(PATH_PHENO[i]), pattern = "_cor.tsv", "")
  list_of_phenotypes[[i]] <- list_of_phenotypes[[i]] %>% 
    dplyr::select(., c(8, 1, 2, 3, 7))
}

cor_pval_data <- do.call(rbind, list_of_phenotypes)

cor_pval_data$significance <- str_replace(cor_pval_data$significance, pattern = "Bonferroni significant", "**")
cor_pval_data$significance <- str_replace(cor_pval_data$significance, pattern = "FDR significant", "*")
cor_pval_data$significance <- str_replace(cor_pval_data$significance, pattern = "non-significant", "")

cor_pval_data$significance[is.na(cor_pval_data$significance)] <- ""

#create new col "p_txt" - this will be a text on heatmap
cor_pval_data$p_txt <- paste0(cor_pval_data$correlation, cor_pval_data$significance)  

#list of all phenotypes in analysis in desired order (in our case: neurological first)
phenotypes <- c("AD", "PD", "DLB", "metarbd", "ALS", "Epilepsy", "Headache", "Prion", "Stroke",  "ADHD", "AN", "ASD", "BD", "MDD", "OCD", "PTS", "SCZ", "TS", "AlcDep", "AUDIT", "Cannabis")

phenotypes <- phenotypes[phenotypes != pheno]

phenotypes <- unname(sapply(phenotypes, function(x) paste0(pheno, "_", x)))

cor_pval_data$phenos <- factor(cor_pval_data$phenos, levels = phenotypes)

my_plot <- ggplot(cor_pval_data, aes(x = phenos, y = tissue, fill = correlation)) +
  geom_tile(aes(x = phenos, y = tissue, fill = correlation), show.legend = T) +
  scale_fill_distiller(type = "div", palette = 5) +
  geom_text(aes(label = p_txt), size=2.5) +
  theme(axis.text.x = element_text(angle = 30, hjust = 1, size=7),
        #legend.position = "none",
        axis.title.x = element_blank(),
        axis.title.y = element_blank())

ggsave(filename = paste0("Heatmap_", pheno, ".pdf"), plot = my_plot, device = "pdf", width = 9, height = 3)

write.table(cor_pval_data, file = paste0(pheno, "_correlation.tsv"), sep = '\t', row.names = F, na = "NA")  

