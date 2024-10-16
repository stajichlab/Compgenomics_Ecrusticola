#!/usr/bin/env Rscript
# download the latest version of GENESPACE from github

library(GENESPACE)
###############################################
# -- change paths to those valid on your system
# should just make this pwd
wd <- "/bigdata/stajichlab/shared/projects/BioCrusts/MossCrust/genomics/exophiala_compgen/genespace_subset/"
path2mcscanx <- "/opt/linux/rocky/8.x/x86_64/pkgs/MCScanX/r51_g97e74f4"
###############################################

	gpar <- init_genespace(
		genomeIDs = c('Exophiala_alcalophila',
		'Exophiala_crusticola',
		'Exophiala_lecanii_corni',
		'Exophiala_mesophila',
		),
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
