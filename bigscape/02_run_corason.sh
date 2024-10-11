#!/usr/bin/bash -l
#SBATCH -p intel -c 48 -N 1 -n 1 --mem 128gb --out logs/Corason.%A.log
CPU=2
if [ $SLURM_CPUS_ON_NODE ]; then
  CPU=$SLURM_CPUS_ON_NODE
fi
module load bigscape
module load db-pfam
corason.pl -g --list gbk_list.tsv -q RHTO_03752.fasta scaffold_9.region001.gbk