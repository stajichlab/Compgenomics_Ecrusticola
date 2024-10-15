#!/usr/bin/env Rscript
# download the latest version of GENESPACE from github
if (!requireNamespace("devtools", quietly = TRUE))
    install.packages("devtools")
devtools::install_github("jtlovell/GENESPACE")
library(GENESPACE)
###############################################
# -- change paths to those valid on your system
# should just make this pwd
wd <- "~/shared/projects/BioCrusts/MossCrust/genomics/exophiala_compgen/genespace/"
path2mcscanx <- "/opt/linux/rocky/8.x/x86_64/pkgs/MCScanX/r51_g97e74f4"
###############################################

	gpar <- init_genespace(
		genomeIDs = c('Rhodotorula_araucariae_NRRL_Y_17376',
		'Rhodotorula_dairenensis_NRRL_Y_2504',
		'Rhodotorula_diobovata_NRRL_Y_7196',
		'Rhodotorula_evergladensis_DBVPG_7922',
		'Rhodotorula_graminis_NRRL_Y_2474',
		'Rhodotorula_mucilaginosa_NRRL_Y_2510',
		'Rhodotorula_paludigena_NRRL_Y_12923',
		'Rhodotorula_sp._DBVPG_7947',
		'Rhodotorula_sphaerocarpa_NRRL_Y_7192'),
		outgroup = NULL,
		ploidy = rep(1,1,1,1,1,1,1,1,1),
		diamondUltraSens = TRUE,
		wd = wd,
		orthofinderInBlk = FALSE,
		nCores = 48,
		path2orthofinder = "orthofinder",
		path2diamond = "diamond",
		path2mcscanx = path2mcscanx,
	)

# -- accomplish the run
out <- run_genespace(gpar,overwrite = T)
