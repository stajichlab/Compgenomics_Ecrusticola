#!/bin/bash -l
#SBATCH --ntasks 16 --mem 8G -p short --error logs/orthofinder.%j.err -o logs/orthofinder.%j.log --time 48:00

module load ncbi-blast
module load orthofinder

which orthofinder

CPU=8

input_dir=assemblies

orthofinder -a $CPU -f $input_dir 
