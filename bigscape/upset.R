# Load required libraries
library("dplyr")
library("pheatmap")

# Create the first data frame
data1 <- read.table(header = TRUE, text = "
ACC	FAM_02570	FAM_02564	FAM_02560	FAM_02554	FAM_02529	FAM_02526	FAM_02524	FAM_02520	FAM_02519	FAM_00014	FAM_00010	FAM_00009	FAM_00005	FAM_00002	FAM_00000	FAM_02542	FAM_02541	FAM_02617	FAM_02610	FAM_02547
Exophiala_lecanii-corni	0	0	0	0	1	1	1	1	1	0	0	0	0	0	0	0	0	0	0	0
Exophiala_alcalophila	0	0	0	0	0	0	0	0	0	1	1	1	1	1	1	0	0	0	0	0
Exophiala_xenobiotica	1	1	1	1	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
Exophiala_viscosa	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	1	1
Exophiala_sideris	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	1	1	1	1
")

# Create the second data frame
data2 <- read.table(header = TRUE, text = "
ACC	FAM_02615	FAM_02620	FAM_02604	FAM_02597	FAM_02603	FAM_02578	FAM_02586	FAM_02572	FAM_02565	FAM_02568	FAM_02516	FAM_02531	FAM_02622	FAM_00004	FAM_00007	FAM_00012	FAM_02539	FAM_02552	FAM_02550	FAM_02538
Exophiala_lecanii-corni	0	0	0	0	0	0	0	0	0	0	1	1	1	1	0	0	0	0	0	0
Exophiala_alcalophila	0	0	0	0	0	0	0	0	0	0	0	0	1	1	1	1	0	0	0	0
Exophiala_mesophila	0	0	1	1	1	0	0	0	0	0	0	0	1	0	0	0	0	0	0	0
Exophiala_sideris	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	1	1	1
Exophiala_crusticola	0	0	0	0	0	0	0	0	0	0	0	0	1	0	0	0	0	0	1	0
Exophiala_viscosa	1	1	0	0	0	0	0	0	0	0	0	0	1	0	0	0	0	0	1	1
Exophiala_xenobiotica	0	0	0	0	0	0	0	1	1	1	0	0	1	0	0	0	0	0	0	0
Exophiala_spinifera	0	0	0	0	0	1	1	1	0	0	0	0	0	0	0	0	0	0	0	0
")


# Set row names for both data frames
rownames(data1) <- data1$ACC
data1 <- data1[, -1]  # Remove the ACC column
rownames(data2) <- data2$ACC
data2 <- data2[, -1]  # Remove the ACC column

# Convert data frames to include row names as a column
data1_with_names <- data.frame(ACC = rownames(data1), data1)
data2_with_names <- data.frame(ACC = rownames(data2), data2)

# Combine the data frames
combined_data <- full_join(data1_with_names, data2_with_names, by = "ACC")

# Set the row names back to ACC
rownames(combined_data) <- combined_data$ACC
combined_data <- combined_data[, -1]  # Remove the ACC column

# View the combined data frame
print(combined_data)

# Save the heatmap as a PNG image
png("heatmap_exophiala_species.png", width = 800, height = 600)  # Specify the file name and dimensions

# Create a heatmap from the combined data
pheatmap(combined_data,
         clustering_distance_rows = "euclidean",
         clustering_distance_cols = "euclidean",
         clustering_method = "complete",
         display_numbers = TRUE,
         fontsize_number = 8,
         main = "Combined Heatmap of Exophiala Species")

dev.off()  # Close the graphical device to save the image
