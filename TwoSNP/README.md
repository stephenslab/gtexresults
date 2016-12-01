# Two SNP regression analysis
## Problem
We are interested in evaluating change in effect size estimate from
1 SNP vs 2 SNP model. Specifically for given gene we want to take 2 SNPs:
one with largest z score in brain tissues and the other with largest z score in non-brain tissues. 
Then for each tissue in GTEx we perform the following regression analyses:

* Expression level vs. (SNP A + SNP B)
* Expression level vs. SNP A
* Expression level vs. SNP B

We will plot the estimated effect sizes and standard error to
show how effect estimates may change.

@surbut has selected from GTEx analysis a list of 27 genes 
whose eQTL across brain tissues are in different directions
compared to their effects in other tissues. These genes are:
```
"1" "ENSG00000025772.7
"2" "ENSG00000056661.9
"3" "ENSG00000064012.17
"4" "ENSG00000089486.12
"5" "ENSG00000104472.5
"6" "ENSG00000108384.10
"7" "ENSG00000112977.11
"8" "ENSG00000120088.10
"9" "ENSG00000135744.7
"10" "ENSG00000136059.10
"11" "ENSG00000140265.8
"12" "ENSG00000145214.9
"13" "ENSG00000149054.10
"14" "ENSG00000160766.10
"15" "ENSG00000164124.6
"16" "ENSG00000177084.12
"17" "ENSG00000181240.9
"18" "ENSG00000187824.4
"19" "ENSG00000188732.6
"20" "ENSG00000189171.9
"21" "ENSG00000189316.3
"22" "ENSG00000198794.7
"23" "ENSG00000225439.2
"24" "ENSG00000249846.2
"25" "ENSG00000264247.1
"26" "ENSG00000267508.1
"27" "ENSG00000272030.1
```
FIXME: link to `diffplot.html`

## Procedures
Analysis is coded in pipeline `2SNP.sos`.
