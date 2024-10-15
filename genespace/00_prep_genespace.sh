#!/usr/bin/bash -l
#SBATCH -p short --out logs/prep_genespace.log

module load biopython

mkdir -p peptide cds bed dna gff


# our local annotation
SOURCE=../annotate/annotate/

for STRAIN in $(ls $SOURCE | grep Exo)
do
    GFF=$(ls $SOURCE/$STRAIN/predict_results/*.gff3)
    DIR=$(dirname $GFF)
    INPREF=$(basename $GFF .gff3)
    PREF=$(echo -n $INPREF | perl -p -e 's/\-/_/g')
    cp $GFF gff/$PREF.gff
    cp $DIR/$INPREF.scaffolds.fa dna/$PREF.fasta
    grep -P "\tmRNA\t" $GFF |  cut -f 1,4,5,9 | perl -p -e 's/ID=([^\;]+);.+/$1/' > bed/$PREF.bed
    # take first isoform for simplicity
    cat $DIR/$INPREF.cds-transcripts.fa | ./scripts/get_longest.py > cds/$PREF.fa
    cat $DIR/$INPREF.proteins.fa | ./scripts/get_longest.py > peptide/$PREF.fa
    perl -i -p -e 's/>(\S+).+/>$1/' peptide/$PREF.fa
done
