# %%
import pandas as pd
from Bio import SeqIO 
import os

# %%
path = "./logs"
def get_contig_names(path):
    contig_list = []  # Initialize the contig list
    for file in os.listdir(path):
        if file.endswith(".log"):
            with open(os.path.join(path, file), "r") as f_in:
                contents = f_in.read()
                if "bad contigs, where alphabet is less than 4" in contents:
                    contig_names = []
                    lines = contents.split('\n')
                    for line in lines:
                        if any(line.startswith(prefix) for prefix in ["JAAAJ", "BCH", "KN84"]):
                            contig_names.append(line.strip())
                    contig_list.extend(contig_names)  # Extend the global list with found contig names
    print(contig_list)  # Print the final contig list
    return contig_list  # Return the contig list after processing all files

contig_list = get_contig_names(path)  # Store the result in a variable

# %%
# Read in the fasta files in genomes directory and remove the contigs that are in the list
path = "./genomes"
for file in os.listdir(path):
    if file.endswith("fasta.masked"):
        with open(os.path.join(path, file), "r") as f_in:
            # Read in the fasta file
            records = list(SeqIO.parse(f_in, "fasta"))
            print(f"Processing file: {file}, Number of records: {len(records)}")  # Debugging
            # Remove the contigs that are in the list
            filtered_records = [record for record in records if record.id not in contig_list]
            print(f"Number of records after filtering: {len(filtered_records)}")  # Debugging
            # Write the new fasta file
            with open(os.path.join(path, file.replace("fasta.masked", "masked_filtered.fasta")), "w") as f_out:
                SeqIO.write(filtered_records, f_out, "fasta")


