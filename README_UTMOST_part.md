This repository corresponds to a project in the first semester in Bioinformatics institute.

Project name: Comprehensive analysis of shared biologic architecture between neurologic and psychiatric traits

The aim of the project: Analysis of the correlation between neurological and psychiatric diseases based on the results of genome-wide association analysis (GWAS) and transcriptomic association analysis (TWAS / UTMOST)

Authors: D.Nilanorova, L.Protsenko, K.Senkevich

In this repo we perform all steps of GWAS-data analysis. Our work was logically separated to TWAS and UTMOST parts and different files and scripts correspond to these two parts. 


Using UTMOST (Unified Test For Molecular Signatures), at the first step we imputed the level of gene expression according to GWAS summary statistics data and GTEx reference data, then at the second step we tested the hypothesis about the association between trait of interest and the imputed expression of each gene in 44 tissues. At the last step, we performed a cross-tissue test for each gene to summarize all the statistics into a powerful metric and get the list of genes significantly associated with disease. 

To find biological pathways, we used gprofiler (https://biit.cs.ut.ee/gprofiler/convert) web-server. 

UTMOST installation requirements:
The software is developed and tested in Linux and Mac OS environments.
Python 2.7
numpy (>=1.11.1)
scipy (>=0.18.1)
pandas (>=0.18.1)
rpy2 (==2.8.6)
R is needed for GBJ testing.
GBJ (0.5.0)

Command line parameters to use UTMOST single tissue association test for 44 tissues:

--model_db_path (Path to gene expression imputation model (estimated weights/effect sizes of cis-eQTLs)).
--covariance (Path to file containing covariance information).
--gwas_folder (Folder containing GWAS summary statistics data)
--gwas_file_pattern (The file patten of gwas file (file name of summary statistics if not segmented by chromosomes)).
--snp_column  (Argument with the name of the column containing the RSIDs).
--effect_allele_column (Argument with the name of the column containing the effect allele).
--non_effect_allele_column (Argument with the name of the column containing the non-effect allele).
--beta_column (The column containing -effect size estimator for each SNP- in the input GWAS files).
--pvalue_column (The column containing -PValue for each SNP- in the input GWAS files).
--output_file (Path where results will be saved to).


Command line parameters to calculate gene-trait associations in 44 tissues by joint GBJ test:

--weight_db (Name of weight db in data folder (imputation models)).
--input_folder (Name of folder containing single-tissue association results (generated before)).
--cov_dir (Path where covariance results are).
--output_dir (Path where results will be saved to).
--gene_info (File containing the all the genes tested)
--start_gene_index (Index of the starting gene in intermediate/gene_info.txt (for parallel computing purpose, could test multiple gene at the same time to reduce computation time)).
--end_gene_index (Index of the ending gene in intermediate/gene_info.txt (for parallel computing purpose, could test multiple gene at the same time to reduce computation time)).

Together these 2 tests give the list of genes with p-values. To find significant genes, we used FDR p-value correction with the threshold equal to 0.05. 
Reference data (GTEx and covariance matrices) can be downloaded from https://github.com/Joker-Jerome/UTMOST)

All command line operations are wrapped into script UTMOST_pipeline.sh.
All R operations are wrapped into UTMOST_analisys.R file.

