#!/usr/bin/bash -l
#SBATCH --nodes=1
#SBATCH --ntasks=16 --mem 16gb
#SBATCH --output=logs/annotfunc.%a.log
#SBATCH --time=2-0:00:00
#SBATCH -p intel -J annotfunc

module unload miniconda2 miniconda3 perl python
module load funannotate
module load phobius

export FUNANNOTATE_DB=/bigdata/stajichlab/shared/lib/funannotate_db
CPUS=$SLURM_CPUS_ON_NODE
OUTDIR=annotate
INDIR=genomes
SAMPFILE=samples.csv
BUSCO=fungi_odb10

if [ -z $CPUS ]; then
  CPUS=1
fi

N=${SLURM_ARRAY_TASK_ID}

if [ -z $N ]; then
  N=$1
  if [ -z $N ]; then
    echo "need to provide a number by --array or cmdline"
    exit
  fi
fi
MAX=`wc -l $SAMPFILE | awk '{print $1}'`

if [ $N -gt $MAX ]; then
  echo "$N is too big, only $MAX lines in $SAMPFILE"
  exit
fi
IFS=,
tail -n +2 $SAMPFILE | sed -n ${N}p | while read SPECIES PHYLUM 
do
  BASE=$(echo -n "$SPECIES" | perl -p -e 's/\s+/_/g')
  echo "$BASE"
  MASKED=$(realpath $INDIR/$BASE.fasta.masked)
  if [ ! -f $MASKED ]; then
    echo "Cannot find $BASE.fasta.masked in $INDIR - may not have been run yet"
    exit
  fi
  ANTISMASHRESULT=$OUTDIR/$name/annotate_misc/antiSMASH.results.gbk
  echo "$name $species"
  if [[ ! -f $ANTISMASHRESULT && -d $OUTDIR/$name/antismash_local ]]; then
    ANTISMASH=$OUTDIR/$name/antismash_local/${SPECIES}_$name.gbk
    if [ ! -f $ANTISMASH ]; then
      echo "CANNOT FIND $ANTISMASH in $OUTDIR/$name/antismash_local"
    else
      rsync -a $ANTISMASH $ANTISMASHRESULT
    fi
  fi
  # need to add detect for antismash and then add that
  funannotate annotate --busco_db $BUSCO -i $OUTDIR/$BASE --species "$SPECIES" --cpus $CPUS $MOREFEATURE $EXTRAANNOT
done