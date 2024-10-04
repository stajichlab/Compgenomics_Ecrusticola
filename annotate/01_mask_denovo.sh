#!/usr/bin/bash -l
#SBATCH -p batch --time 2-0:00:00 --ntasks 8 --nodes 1 --mem 24G --out logs/mask.%a.log

# Determine the number of CPUs to use
CPU=1
if [ -n "$SLURM_CPUS_ON_NODE" ]; then
    CPU=$SLURM_CPUS_ON_NODE
fi

INDIR=genomes
OUTDIR=genomes

mkdir -p repeat_library

SAMPFILE=samples.csv
N=${SLURM_ARRAY_TASK_ID}

# Check if N is set, if not, check for command-line argument
if [ -z "$N" ]; then
    N=$1
    if [ -z "$N" ]; then
        echo "Need to provide a number by --array or command line."
        exit 1
    fi
fi

# Get the maximum number of samples from the sample file
MAX=$(wc -l < "$SAMPFILE")
if [ "$N" -gt "$MAX" ]; then
    echo "$N is too big; only $MAX lines in $SAMPFILE."
    exit 1
fi

IFS=,
# Process the specific sample
tail -n +2 "$SAMPFILE" | sed -n "${N}p" | while read -r SPECIES PHYLUM; do
    name=$(echo "$SPECIES" | tr ' ' '_')

    # Check if the input fasta file exists
    if [ ! -f "$INDIR/${name}.fasta" ]; then
        echo "Cannot find $name in $INDIR - may not have been run yet."
        exit 1
    fi
    echo "Processing $name..."

    # Check if the output masked fasta file already exists
    if [ ! -f "$OUTDIR/${name}.masked.fasta" ]; then
        module load RepeatMasker || { echo "Failed to load RepeatMasker"; exit 1; }
        module load RepeatModeler || { echo "Failed to load RepeatModeler"; exit 1; }

        export AUGUSTUS_CONFIG_PATH=$(realpath lib/augustus/3.3/config)

        LIBRARY=""
        if [ -f "repeat_library/${name}-families.fa" ]; then
            LIBRARY=$(realpath "repeat_library/${name}-families.fa")
        fi
        echo "LIBRARY is $LIBRARY"

        mkdir "$name.mask.$$"
        pushd "$name.mask.$$" || { echo "Failed to enter directory"; exit 1; }

        # Run RepeatMasker
        RepeatMasker -pa "$CPU" -e ncbi -dir "../$OUTDIR" -lib "../repeat_library/${name}-families.fa" "../$INDIR/${name}.fasta"

        mv repeatmodeler-library.*.fasta "../repeat_library/${name}.repeatmodeler-library.fasta"
        mv funannotate-mask.log "../logs/masklog_long.$name.log"

        popd || { echo "Failed to return to the previous directory"; exit 1; }
        # Uncomment if you want to remove the temporary directory
        rm -r "$name.mask.$$"
    else
        echo "Skipping ${name} as it has already been masked."
    fi
done
