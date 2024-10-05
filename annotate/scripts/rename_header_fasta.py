# %%
import pandas as pd
from Bio import SeqIO 
import os


# %%

path = "./genomes/"
# obtain genome file names that are masked for repeats
for file in os.listdir(path):
    if file.endswith(".masked"):
        print(file)
        # Read in each of the files
        with open(os.path.join(path, file), "r") as f:
            contents = f.read()
        sequences = contents.split(">")[1:]
        # split the header from the sequence
        for sequence in sequences:
            # split the header from the sequence by the first newline
            header, seq = sequence.split("\n", 1)
            # get the contig name
            contig = header.split(" ")[0]
            new_header = f">{contig}"
            # rename the file so it doesn't overwrite the original
            new_file_name = os.path.join(path, f"reformat_{file}")
            with open(new_file_name, "w") as f:
                # write the new header and sequence to the file
                f.write(new_header + "\n" + seq)
            


