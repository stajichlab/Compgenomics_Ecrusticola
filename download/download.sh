#!/usr/bin/bash -l
#SBATCH -p short -c 48 --mem 64gb --out logs/01_genome_download.log

module load ncbi_datasets
module load workspace/scratch

FOLDER=assemblies
METADATA_FILE=lib/filtered_metadata.tsv

CPU=8
if [ $SLURM_CPUS_ON_NODE ]; then
  CPU=$SLURM_CPUS_ON_NODE
fi

mkdir -p "$FOLDER"

IFS=$'\t'
tail -n +2 "$METADATA_FILE" | while read -r ACCESSION ASSEMBLY ORGANISM_NAME _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
do
  # Replace spaces with underscores in variables
  SANITIZED_ACCESSION=$(echo "$ACCESSION" | tr ' ' '_')
  SANITIZED_ORGANISM_NAME=$(echo "$ORGANISM_NAME" | tr ' ' '_')

  # Construct sanitized file paths
  GENOMIC_DIR="ncbi_dataset/ncbi_dataset/data/$SANITIZED_ACCESSION"
  TARGET_FILE="$FOLDER/${SANITIZED_ACCESSION}_${SANITIZED_ORGANISM_NAME}.fasta"

  # Check if the target file already exists
  if [ ! -s "$TARGET_FILE" ]; then
    # Download genome dataset
    datasets download genome accession "$ACCESSION" --include genome

    # Check if download was successful
    if [ -f "ncbi_dataset.zip" ]; then
      unzip -o -d ncbi_dataset ncbi_dataset.zip

      # Check for .fna files in the genomic directory
      fna_files=("$GENOMIC_DIR"/*.fna)

      if compgen -G "${fna_files}" > /dev/null; then
        # Move each .fna file to the target location
        for fna_file in "${fna_files[@]}"; do
          mv "$fna_file" "$TARGET_FILE"
          echo "Moved $fna_file to $TARGET_FILE"
        done
      else
        echo "Warning: No .fna files found for accession $ACCESSION"
      fi
    else
      echo "Error: Download failed for accession $ACCESSION"
    fi
  else
    echo "File $TARGET_FILE already exists; skipping."
  fi
done
