#! /bin/bash

PATH_TO_PHENO="/media/daria/DaryaNika/GWAS_neuro_project/fusion_twas-master/$2/mod_*"
PATH_OUT=$3

tissue=$(basename $1)
tissue_dir=${tissue%%\.pos}

set -e
mkdir "$PATH_OUT"
mkdir "$PATH_OUT/${tissue_dir}"

for pheno in $PATH_TO_PHENO
do
	filename=$(basename $pheno)
	ID=${filename%%\.sumstats}
	echo $ID
	./make_twas_chr.sh $pheno $ID $tissue_dir $PATH_OUT $1 &> "$PATH_OUT/${tissue_dir}/${ID}.log" 
done
