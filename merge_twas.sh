#! /bin/bash

set -e

#$1-a full path to a directory with twas results

for tissue in $1*/
do
        echo $tissue
        Rscript merge_twas.R $tissue
done

