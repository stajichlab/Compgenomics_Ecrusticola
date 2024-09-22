#!/bin/bash -l
#SBATCH --ntasks 16 --mem 8G -p short --error logs/rename.%j.err --output logs/orthofinder.%j.log --time 48:00

FILES="metadata_modified.tsv"

# Set the internal field separator to tab
IFS=$'\t'

# Read the specified line number (N) and process the fields
tail -n +2 "$FILES" | sed -n "${N}p" | while read -r Path filename Assembly_Accession Assembly_Name Organism_Name Organism_Infraspecific_Names_Breed Organism_Infraspecific_Names_Strain Organism_Infraspecific_Names_Cultivar Organism_Infraspecific_Names_Ecotype Organism_Infraspecific_Names_Isolate Organism_Infraspecific_Names_Sex Annotation_Name Assembly_Level Assembly_Release_Date WGS_project_accession Assembly_Stats_Contig_N50 Assembly_Stats_Scaffold_N50 Assembly_Stats_Number_of_Scaffolds Annotation_BUSCO_Complete_ Annotation_BUSCO_Single_Copy_ Annotation_BUSCO_Duplicated_ Annotation_BUSCO_Fragmented_ Annotation_BUSCO_Missing_ Annotation_BUSCO_Lineage_ Assembly_Sequencing_Tech directory extension new_name; do 
    mv "$Path" "$directory"/"$new_name"
done
