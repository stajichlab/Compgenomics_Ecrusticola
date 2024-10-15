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
# Rename columns in data1
colnames(data1)[-1] <- paste0("Other_", colnames(data1)[-1])
# Create the second data frame
data2 <- read.table(header = TRUE, text = "
ACC	FAM_02532	FAM_02527	FAM_02525	FAM_02523	FAM_02520	FAM_02518	FAM_02514	FAM_02515	FAM_02591	FAM_00014	FAM_00011	FAM_00001	FAM_00002	FAM_02545	FAM_02543	FAM_02534	FAM_02624	FAM_02610	FAM_02585	FAM_02558
Exophiala_lecanii-corni	1	1	1	1	1	1	1	1	0	0	0	0	0	0	0	0	0	0	0	0
Exophiala_alcalophila	0	0	0	0	0	0	0	0	0	1	1	1	1	0	0	0	0	0	0	0
Exophiala_xenobiotica	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	1
Exophiala_spinifera	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	0
Exophiala_viscosa	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	1	1	1
Exophiala_sideris	0	0	0	0	0	0	0	0	0	0	0	0	0	1	1	1	1	1	1	1
Exophiala_mesophila	0	0	0	0	0	0	0	0	1	0	0	0	0	0	0	0	0	0	0	0
")
# Rename columns in data1
colnames(data2)[-1] <- paste0("NRPS_", colnames(data2)[-1])
# Create additional data frames
data3 <- read.table(header = TRUE, text = "
ACC	FAM_02626	FAM_02625	FAM_02611	FAM_02600	FAM_02587	FAM_02573	FAM_02571	FAM_02566	FAM_02562	FAM_02561	FAM_02556	FAM_02555	FAM_02544	FAM_02530	FAM_02522	FAM_02521	FAM_00003	FAM_00006
Exophiala_lecanii-corni	0	0	0	0	0	0	0	0	0	0	0	0	0	1	1	1	0	0
Exophiala_alcalophila	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	1
Exophiala_sideris	0	0	0	0	0	0	0	0	0	0	0	0	1	0	0	0	0	0
Exophiala_xenobiotica	0	0	0	0	0	0	1	1	1	1	1	1	0	0	0	0	0	0
Exophiala_spinifera	0	0	0	0	1	1	0	0	0	0	0	0	0	0	0	0	0	0
Exophiala_mesophila	0	0	0	1	0	0	0	0	0	0	0	0	0	0	0	0	0	0
Exophiala_viscosa	0	1	1	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
Exophiala_crusticola	1	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
")
# Rename columns in data1
colnames(data3)[-1] <- paste0("PKSI_", colnames(data3)[-1])

data4 <- read.table(header = TRUE, text = "
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

colnames(data4)[-1] <- paste0("Terpene_", colnames(data4)[-1])

data5 <- read.table(header = TRUE, text = "
ACC	FAM_02629	FAM_02574	FAM_02588	FAM_02563	FAM_02513	FAM_02532	FAM_00013	FAM_02540	FAM_02536
Exophiala_xenobiotica	0	0	0	1	0	0	0	0	0
Exophiala_alcalophila	0	0	0	0	0	0	1	0	0
Exophiala_spinifera	0	1	1	0	0	0	0	0	0
Exophiala_mesophila	0	0	0	0	1	0	0	0	0
Exophiala_lecanii-corni	0	0	0	0	1	1	0	0	0
Exophiala_viscosa	0	0	0	0	0	0	0	0	1
Exophiala_sideris	0	0	0	0	0	0	0	1	1
Exophiala_crusticola	1	0	0	0	0	0	0	0	0
")

colnames(data5)[-1] <- paste0("PKS_other", colnames(data5)[-1])

# Combine data frames
combined_data <- Reduce(function(x, y) full_join(x, y, by = "ACC"), list(data1, data2, data3, data4, data5))

# Replace NA values with 0
combined_data[is.na(combined_data)] <- 0

# Remove the first column (ACC)
row_names <- combined_data$ACC
combined_data <- combined_data[,-1]
rownames(combined_data) <- row_names

# Convert data frame to matrix for heatmap
heatmap_matrix <- as.matrix(combined_data)


# Save the heatmap as a PNG image

pdf("my_plot.pdf", width = 10, height = 8)  # Specify dimensions in inches


# Create heatmap
pheatmap(heatmap_matrix, 
         scale = "none", 
         clustering_distance_rows = "euclidean", 
         clustering_distance_cols = "euclidean", 
         clustering_method = "complete", 
         show_rownames = TRUE, 
         show_colnames = TRUE, 
         fontsize_row = 6, 
         fontsize_col = 6)

dev.off()  # Close the graphical device to save the image
