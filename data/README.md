# GTEx summary statistics data-set

- `MatrixEQTLSumStats.Portable.Z.rds`: contains random and strong eQTL data for gene-snp pairs in GTEx V6 data-set.
  - `strong.*`: the strongest gene-snp pairs used to learn prior matrices; their posterior are also of interest
  - `random.*`: a random set of gene-snp pairs used to fit the mash mixture
  - `random.test.*`: another random set of gene-snp pairs used to evaluate potential overfitting issue of MASH model

- `MatrixEQTLSumStats.Portable.ld2.Z.rds`: a subset of `MatrixEQTLSumStats.Portable.Z.rds` where the maximum of Linkage disequilibrium (LD) between SNPs is 0.2.
