library("UpSetR")

# Load the data
orthogroups_df <- read.table("Orthogroups.GeneCount.tsv", header = TRUE, stringsAsFactors = FALSE)

# Select species columns
selected_species <- colnames(orthogroups_df)[2:(ncol(orthogroups_df) - 1)]
selected_species

# Convert counts to binary presence/absence
orthogroups_df[orthogroups_df > 0] <- 1

# Print the first few rows of the dataframe for preview
print(head(orthogroups_df, n = 20))

# Filter out the intersection where all selected species are present
filtered_data <- orthogroups_df[!(orthogroups_df$Exophiala_crusticola == 1 & 
                                  orthogroups_df$Exophiala_xenobiotica == 1 & 
                                  orthogroups_df$Exophiala_spinifera == 1 & 
                                  orthogroups_df$Exophiala_viscosa == 1 & 
                                  orthogroups_df$Exophiala_sideris == 1 & 
                                  orthogroups_df$Exophiala_mesophila == 1 & 
                                  orthogroups_df$Exophiala_lecanii.corni == 1 & 
                                  orthogroups_df$Exophiala_alcalophila == 1), ]

# Save the UpSet plot as PNG with increased dimensions
png(file = "upset_plot.png", width = 1200, height = 800)
upset(filtered_data, nsets = ncol(filtered_data), sets = rev(selected_species), 
      keep.order = TRUE, order.by = "freq")
dev.off()  # Close the PNG device
