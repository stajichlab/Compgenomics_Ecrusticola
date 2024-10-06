#!/usr/bin/bash -l
#SBATCH -p batch --time 3-0:00:00 --ntasks 16 --nodes 1 --mem 24G --out logs/predict.%a.log

module load funannotate

# this will define $SCRATCH variable if you don't have this on your system you can basically do this depending on
# where you have temp storage space and fast disks
# SCRATCH=/tmp/${USER}_$$
# mkdir -p $SCRATCH 
module load workspace/scratch

CPU=1
if [ $SLURM_CPUS_ON_NODE ]; then
    CPU=$SLURM_CPUS_ON_NODE
fi

BUSCO=fungi_odb10 # This could be changed to the core BUSCO set you want to use
INDIR=genomes
OUTDIR=annotate
PREDS=$(realpath prediction_support)
mkdir -p $OUTDIR
SAMPFILE=samples.csv
N=${SLURM_ARRAY_TASK_ID}

if [ ! $N ]; then
    N=$1
    if [ ! $N ]; then
        echo "need to provide a number by --array or cmdline"
        exit
    fi
fi
MAX=`wc -l $SAMPFILE | awk '{print $1}'`

if [ $N -gt $MAX ]; then
    echo "$N is too big, only $MAX lines in $SAMPFILE"
    exit
fi
export AUGUSTUS_CONFIG_PATH=$(realpath Augustus/config)
export FUNANNOTATE_DB=/bigdata/stajichlab/shared/lib/funannotate_db

IFS=,
tail -n +2 $SAMPFILE | sed -n ${N}p | while read SPECIES PHYLUM
do
    BASE=$(echo -n "$SPECIES" | perl -p -e 's/\s+/_/g')
    echo "sample is $BASE"
    MASKED=$(realpath $INDIR/reformat_$BASE.fasta.masked)
    if [ ! -f $MASKED ]; then
      echo "Cannot find reformat_$BASE.fasta.masked in $INDIR - may not have been run yet"
      exit
    fi
    if [[ -f $PREDS/$BASE.genemark.gtf ]]; then
    funannotate predict --cpus $CPU --keep_no_stops --busco_db $BUSCO --optimize_augustus \
        --min_training_models 100 --AUGUSTUS_CONFIG_PATH $AUGUSTUS_CONFIG_PATH \
        -i $INDIR/reformat_$BASE.fasta.masked --protein_evidence $FUNANNOTATE_DB/uniprot_sprot.fasta \
        -s "$SPECIES"  -o $OUTDIR/$BASE --genemark_gtf $PREDS/$BASE.genemark.gtf
    else
    funannotate predict --cpus $CPU --keep_no_stops --busco_db $BUSCO --optimize_augustus \
	--min_training_models 100 --AUGUSTUS_CONFIG_PATH $AUGUSTUS_CONFIG_PATH \
	-i $INDIR/reformat_$BASE.fasta.masked --protein_evidence $FUNANNOTATE_DB/uniprot_sprot.fasta \
	-s "$SPECIES"  -o $OUTDIR/$BASE --tmpdir $SCRATCH
    fi
done