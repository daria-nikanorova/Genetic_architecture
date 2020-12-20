#!/bin/bash
cd /mnt4/pro_milka/UTMOST/sample_data/GWAS/set3/
UTMOST_path=/mnt4/pro_milka/UTMOST
TISSUE_GTEx=(Adipose_Subcutaneous Adipose_Visceral_Omentum Adrenal_Gland Artery_Aorta Artery_Coronary Artery_Tibial Brain_Anterior_cingulate_cortex_BA24 Brain_Caudate_basal_ganglia Brain_Cerebellar_Hemisphere Brain_Cerebellum Brain_Cortex Brain_Frontal_Cortex_BA9 Brain_Hippocampus Brain_Hypothalamus Brain_Nucleus_accumbens_basal_ganglia Brain_Putamen_basal_ganglia Breast_Mammary_Tissue Cells_EBV-transformed_lymphocytes Cells_Transformed_fibroblasts Colon_Sigmoid Colon_Transverse Esophagus_Gastroesophageal_Junction Esophagus_Mucosa Esophagus_Muscularis Heart_Atrial_Appendage Heart_Left_Ventricle Liver Lung Muscle_Skeletal Nerve_Tibial Ovary Pancreas Pituitary Prostate Skin_Not_Sun_Exposed_Suprapubic Skin_Sun_Exposed_Lower_leg Small_Intestine_Terminal_Ileum Spleen Stomach Testis Thyroid Uterus Vagina Whole_Blood)
for i in *_Utmost.txt; do
	echo $i
	mkdir /mnt4/pro_milka/UTMOST/sample_data/"$i"_RESULT
	for tissue in ${TISSUE_GTEx[@]}; do /usr/bin/python2.7 /mnt4/pro_milka/UTMOST/./single_tissue_association_test.py --verbosity 1 --model_db_path /mnt4/pro_milka/UTMOST/sample_data/weight_db_GTEx/${tissue}.db --covariance /mnt4/pro_milka/UTMOST/sample_data/covariance_tissue/${tissue}.txt.gz --gwas_folder /mnt4/pro_milka/UTMOST/sample_data/GWAS/set3 --gwas_file_pattern $i --snp_column SNP --effect_allele_column A1 --non_effect_allele_column A2 --beta_column b --pvalue_column p --output_file /mnt4/pro_milka/UTMOST/sample_data/"$i"_RESULT/${tissue}.csv; done
	mkdir /mnt4/pro_milka/UTMOST/sample_data/"$i"_GENES
	/usr/bin/python2.7 /mnt4/pro_milka/UTMOST/joint_GBJ_test.py --weight_db $UTMOST_path/sample_data/weight_db_GTEx/ --output_dir $UTMOST_path/sample_data/"$i"_GENES/ --cov_dir $UTMOST_path/sample_data/covariance_joint/ --input_folder $UTMOST_path/sample_data/"$i"_RESULT/ --gene_info $UTMOST_path/intermediate/gene_info.txt --output_name "$i"_44_joint --start_gene_index 1 --end_gene_index 17290
	
done
