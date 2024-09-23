library("UpSetR")

# Load the data
orthogroups_df <- read.table("Orthogroups.GeneCount.tsv", header = TRUE, stringsAsFactors = FALSE)

# Select species columns
selected_species <- colnames(orthogroups_df)[2:(ncol(orthogroups_df) - 1)]
selected_species

# Preview the data
print(head(orthogroups_df))  # Print first few rows
print(dim(orthogroups_df))    # Check dimensions

# Convert counts to binary presence/absence
orthogroups_df[orthogroups_df > 0] <- 1

# Save the UpSet plot as PNG
png(file = "upset_plot.png", width = 1200, height = 800)  # Increase dimensions
upset(orthogroups_df, nsets = ncol(orthogroups_df), sets = rev(selected_species), 
      keep.order = TRUE, order.by = "freq")
dev.off()  # Close the PNG device
