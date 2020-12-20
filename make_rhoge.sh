#! /bin/bash
PATH_OUT="${6}/${4}"
mkdir "${6}/${4}"

while read line
do
	long_pheno=$(echo $line | awk -F ' ' '{print $1}')
	echo $long_pheno
	short_pheno=$(echo $line | awk -F ' ' '{print $2}')
        echo $short_pheno
        N=$(echo $line | awk -F ' ' '{print $3}')
        echo $N

	if [ $long_pheno != $3 ]
	then
		Rscript make_rhoge.R $2 $long_pheno $short_pheno $N $3 $4 $5 $PATH_OUT
	fi
done < $1
