#!/usr/bin/env Rscript

require(data.table)

args = commandArgs(trailingOnly=TRUE)

current_path <- args[1]
tissue <- basename(current_path)
print(tissue)
setwd(current_path)

#a function to merge all twas results from all chromosomes for 1 phenotype in 1 tissue (without MHC locus)
merge_all_data <- function (my_path){
  folder_files <- list.files(path = my_path, pattern = "_\\d*.dat$", ignore.case = T, full.names = T)
  do.call(rbind, lapply(folder_files, function(x) fread(x, stringsAsFactors = F, header = T)))
}

#create a list of directories with files to be merged
PATH_PHENO <- list.dirs(path = current_path, full.names = T, recursive = F)

#If we want to save all merged results
for (dir in  PATH_PHENO){
  tmp <- merge_all_data(dir)
  name <- basename(dir)
  write.table(tmp, paste0(name, '_', tissue, '_all', '.tsv'), sep='\t', row.names = F)
}
