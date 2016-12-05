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
compared to their effects in other tissues. (FIXME: 
link to `diffplot.html` shows why these genes are selected).

## Procedures
Analysis is coded in pipeline `2SNP.sos`. The `extract` workflow in the pipeline
selected the following SNPs for these genes:
```
"","gene","SNP_Brain","SNP_Other"
"1","ENSG00000025772.7","20_42804635_T_C_b37","20_43589041_G_A_b37"
"2","ENSG00000056661.9","17_36904739_GC_G_b37","17_36904739_GC_G_b37"
"3","ENSG00000064012.17","2_202184331_C_T_b37","2_202145612_C_T_b37"
"4","ENSG00000089486.12","16_4525265_C_T_b37","16_4594671_C_T_b37"
"5","ENSG00000104472.5","8_142442538_A_G_b37","8_141526038_T_C_b37"
"6","ENSG00000108384.10","17_57068108_T_C_b37","17_56804230_G_A_b37"
"7","ENSG00000112977.11","5_10761009_C_G_b37","5_10680547_T_C_b37"
"8","ENSG00000120088.10","17_44336651_T_C_b37","17_44233589_T_C_b37"
"9","ENSG00000135744.7","1_230849872_C_T_b37","1_230849886_T_G_b37"
"10","ENSG00000136059.10","3_38030899_G_A_b37","3_38001432_C_T_b37"
"11","ENSG00000140265.8","15_44277216_C_T_b37","15_43671355_A_G_b37"
"12","ENSG00000145214.9","4_967331_C_A_b37","4_970724_A_T_b37"
"13","ENSG00000149054.10","11_7725092_C_T_b37","11_6962971_C_T_b37"
"14","ENSG00000160766.10","1_155194980_T_C_b37","1_155172379_G_A_b37"
"15","ENSG00000164124.6","4_159150467_G_A_b37","4_159092633_A_G_b37"
"16","ENSG00000177084.12","12_133259752_C_T_b37","12_133234741_C_CGTGT_b37"
"17","ENSG00000181240.9","19_6436305_C_T_b37","19_6436305_C_T_b37"
"18","ENSG00000187824.4","17_10633358_C_T_b37","17_10633181_A_G_b37"
"19","ENSG00000188732.6","7_23719779_G_A_b37","7_23733072_A_G_b37"
"20","ENSG00000189171.9","1_153600778_G_A_b37","1_153604519_G_A_b37"
"21","ENSG00000189316.3","7_64364866_T_C_b37","7_64334166_T_C_b37"
"22","ENSG00000198794.7","15_74513228_T_C_b37","15_75292699_C_T_b37"
"23","ENSG00000225439.2","2_74373342_A_T_b37","2_74368578_C_T_b37"
"24","ENSG00000249846.2","3_129843468_G_T_b37","3_129841378_G_A_b37"
"25","ENSG00000264247.1","18_72256641_G_T_b37","18_72260234_T_C_b37"
"26","ENSG00000267508.1","19_44901056_TAA_T_b37","19_44902190_G_A_b37"
"27","ENSG00000272030.1","1_153021592_C_A_b37","1_153605909_G_A_b37"
```

## Results
Result is organized in [this table](http://surbut.github.io/gtexresults_matrixash/TwoSNP) 
with rows being genes and columns tissues.
Each cell entry has two sub-columns and each column has two numbers. The two
numbers on the left column are effect size estimates from single SNP analysis for each SNP. 
The numbers on the right column are estimates from joint analysis. Significance levels are
marked by asterisks in R style. These numbers are marked red when estimates have opposite signs 
from single SNP analysis yet same sign from joint analysis, and blue vise versa.
column  the first column
