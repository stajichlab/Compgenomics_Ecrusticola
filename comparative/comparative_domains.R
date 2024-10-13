library(tidyverse)
library(fmsb)
library(grid)
library(broom)
library(gridExtra)
library(ComplexUpset)
library(UpSetR)
library(viridis)
library(ggplot2)

pdf("plots/CAZY_plots.pdf")

####CAZY analysis####
chosen=c("Exophiala_alcalophila", "Exophiala_crusticola", "Exophiala_lecanii-corni", "Exophiala_mesophila", "Exophiala_sideris", "Exophiala_spinifera", "Exophiala_viscosa", "Exophiala_xenobiotica")

cazy.files=data.frame(names=str_replace(list.files("CAZY/"), ".tsv", "")) %>%
    filter(names %in% chosen) %>%
    mutate(loc=paste("CAZY/", names, ".tsv", sep=""))

print(cazy.files)  # Debug statement

cazy.raw=cazy.files$loc %>% map_dfr(read.delim, .id="source", header=F) %>%
    left_join(cazy.files %>% select(source, Genome)) %>%
    select(-source)

print(head(cazy.raw))  # Debug statement

cazy=cazy.raw %>%
    select(V3, V1, Genome) %>%
    rename(Name=`V3`, CAZY=`V1`) %>%
    separate(Name, into=c("Strain", "Accession"), sep="\\|") %>%
    mutate(CAZY=str_replace_all(CAZY, ".hmm", ""))

print(head(cazy))  # Debug statement

cazy.counts=cazy %>%
    group_by(Genome, CAZY) %>%
    summarize(Count=n_distinct(Accession)) %>%
    group_by(Genome) %>%
    mutate(n=sum(Count)) %>%
    group_by(CAZY) %>%
    mutate(n_Genomes=length(unique(Genome)), Genomes=toString(unique(Genome)))

print(head(cazy.counts))  # Debug statement

cazy.composition=cazy.counts %>%
    group_by(Genome) %>%
    summarize(n=sum(n_Genomes), CAZYs=list(unique(CAZY)))

print(cazy.composition)  # Debug statement

cazy.unique=cazy.counts %>%
    filter(n_Genomes==1) %>%
    group_by(Genome) %>%
    summarize(n=n_distinct(CAZY), cazy=list(unique(CAZY)))

print(cazy.unique)  # Debug statement

cazy.dat=cazy.counts %>%
    filter(n_Genomes>1) %>%
    select(-n_Genomes) 

print(head(cazy.dat))  # Debug statement

cazy.phylo=levels(as.factor(cazy.dat$Genome))[c(1, 2, 5, 6, 7, 3, 4)]

cazy.upset.dat=cazy.composition$CAZYs
names(cazy.upset.dat)=cazy.composition$Genome

cazy.uplt=UpSetR::upset(fromList(cazy.upset.dat), sets=cazy.phylo, mb.ratio = c(0.55, 0.45), order.by = "freq", keep.order = TRUE)

cazy.uplt
grid.text("CAZY UpSet Plot",x = 0.65, y=0.95, gp=gpar(fontsize=20))

#CAZY enrichment
# Ensure the enrich function is defined or imported
# cazy.res=enrich(cazy.dat, var="CAZY", group="Genome")

# Add more debug statements as needed for the rest of the code
