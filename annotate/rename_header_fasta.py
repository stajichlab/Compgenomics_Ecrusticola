# %%
import pandas as pd
from Bio import SeqIO 
import os


# %%
import os

path = "./genomes/"
# obtain genome file names that are masked for repeats
for file in os.listdir(path):
    if file.endswith("fasta.masked"):
        print(file)
        # Read in each of the files
        with open(os.path.join(path, file), "r") as f_in:
            contents = f_in.read()

        # Split the file by each sequence (ignoring the first empty element before the first ">")
        sequences = contents.split(">")[1:]

        # Reformat and write each sequence to a new file
        new_file_name = os.path.join(path, f"reformat_{file}")
        with open(new_file_name, "w") as f_out:
            i = 0
            for sequence in sequences:
                i += 1
                # Split the header from the sequence by the first newline
                header, seq = sequence.split("\n", 1)
                # Remove any internal newlines in the sequence and ensure sequence is on a single line
                seq = seq.replace("\n", "")
                # Get the contig name (first part of the header)
                contig = header.split(" ")[0]
                new_header = f">{contig}"
                # Remove any zeros from the contig name
                new_header = new_header.replace("0", "")
                # Write the new header and index and sequence to the file
                f_out.write(new_header + str(i) + "\n")
                f_out.write(seq + "\n")


            


