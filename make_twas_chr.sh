#! /bin/bash

PATH_WEIGHTS=$5
PATH_WEIGHTS_DIR="/media/daria/DaryaNika/GWAS_neuro_project/fusion_twas-master/WEIGHTS/ALL_genes"
PATH_REF_LD="/media/daria/DaryaNika/GWAS_neuro_project/fusion_twas-master/LDREF/1000G.EUR."

set -e
mkdir "$4/$3/$2"

for chr in {1..22..1}
do
        echo "chromosome ${chr}"

        Rscript FUSION.assoc_test.R \
                        --sumstats $1 \
                        --weights $PATH_WEIGHTS \
                        --weights_dir $PATH_WEIGHTS_DIR \
                        --ref_ld_chr $PATH_REF_LD \
                        --chr $chr \
                        --out "${4}/${3}/${2}/${2}_${chr}.dat"
done

