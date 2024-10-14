# Load the UpSetR library
library("UpSetR")

# Load the data
orthogroups_df <- read.table("Orthogroups.GeneCount.tsv", header = TRUE, stringsAsFactors = FALSE)

# Select species columns, excluding the first one
selected_species <- colnames(orthogroups_df)[3:(ncol(orthogroups_df) - 1)]

# Convert counts to binary presence/absence
orthogroups_df[orthogroups_df > 0] <- 1

# Remove the rows where all species have a value of 1 (i.e., shared by all species)
orthogroups_df <- orthogroups_df[rowSums(orthogroups_df[selected_species]) != length(selected_species), ]

# Save the UpSet plot as PNG
png(file = "upset_plot.png", width = 1200, height = 800)  # Increase dimensions

# Create the UpSet plot without the shared intersection
upset(orthogroups_df, 
      nsets = length(selected_species), 
      sets = rev(selected_species), 
      keep.order = TRUE, 
      order.by = "freq")

dev.off()  # Close the PNG device
