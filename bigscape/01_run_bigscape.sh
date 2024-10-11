#!/usr/bin/bash -l
#SBATCH -p intel -c 48 -N 1 -n 1 --mem 128gb --out logs/bigscape.%A.log
CPU=2
if [ $SLURM_CPUS_ON_NODE ]; then
  CPU=$SLURM_CPUS_ON_NODE
fi
module load bigscape
module load db-pfam
mkdir -p Bigscape
bigscape.py --mibig --include_singletons --inputdir antismash --outputdir Bigscape --pfam_dir $PFAM_DB -c $CPU