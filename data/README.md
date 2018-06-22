# MASH paper data files

This folder contains original data files and processed data files used
in the mash analysis of the GTEx data. Other files include example
data sets used to illustrate the data processing and analysis
pipelines, and additional data used to generate the tables and figures
for the manuscript.

## GTEx summary data

+ `MatrixEQTLSumStats.Portable.Z.rds`: contains random and strong eQTL
data for gene-snp pairs in GTEx V6 data-set. See gtexdata.Rmd or
gtexdata.html for more information about this file.

+ `MatrixEQTLSumStats.Portable.ld2.Z.rds`: a subset of
`MatrixEQTLSumStats.Portable.Z.rds` where the linkage disequilibrium
(LD) between any pair of SNPs is at most 0.2.
