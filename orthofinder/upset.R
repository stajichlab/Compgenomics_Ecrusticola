library("UpSetR")
library("grid")

# Load the data
orthogroups_df <- read.table("Orthogroups.GeneCount.tsv", header = TRUE, stringsAsFactors = FALSE)

# Select species columns
selected_species <- colnames(orthogroups_df)[2:(ncol(orthogroups_df) - 1)]
selected_species

# Convert counts to binary presence/absence
orthogroups_df[orthogroups_df > 0] <- 1

# Print the first few rows of the dataframe for preview
print(head(orthogroups_df, n = 20))

# Create a custom color vector for the intersections
# Blue for intersections containing Exophiala_crusticola, red otherwise
set_colors <- ifelse(orthogroups_df$Exophiala_crusticola == 1, "blue", "red")

# Save the UpSet plot as PNG with increased dimensions
png(file = "upset_plot.png", width = 1200, height = 800)
upset(orthogroups_df, nsets = ncol(orthogroups_df), sets = rev(selected_species), 
      keep.order = TRUE, order.by = "freq", 
      main.bar.color = set_colors)  # Set the colors for the intersections

# Add custom text to the middle of the plot using grid.text
grid.text("Core genome = 3610", x = .62, y = .7, gp = gpar(fontsize = 15, col = "black"))

dev.off()  # Close the PNG device
