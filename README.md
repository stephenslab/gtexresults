## What's included

This repo contains some of the original scripts used to produce results
from Urbut et al. 

If you want to run mashr for yourself, we suggest starting with
the software available [here](https://github.com/stephenslab/mashr).

*Describe structure of repo here.*

## Quick Start

*Give brief instructions on how to use this repo.*

## Setup

*Give setup & installation instructions here.*

## Using this Repo

In this directory, under the folder *scripts* you will find the
notated script, `MidwayScripts.Rmd` to reproduce the results found in
Urbut et al.

1) The input data necessary to run this analysis is
all available under inputs. This may take some time to run, and so we
recommend using a cluster or submittable file system. We have provided
the outputs of running mash in `Data_vhat`.

This repo is organized so that you can run Mash using the gteX data
contained in **Inputs** to produce the parameters and posteriors from
mashr.

2) The script, `MidwayScripts.Rmd` here will help you to produce several sets of files
	
	1)`ms=deconvolution.em.with.bovy(t.stat,factor.mat,v.j,lambda.mat,K=3,	P=3)`

produces an object with the denoised matrices for feeding into the
*mash* covariance code. The *factor.mat* and *lambda.mat* called
within have been produced by SFA and are single rank factors and
loadings approximating the empirical covariance.

2)`covmat=compute.hm.covmat.all.max.step(b.hat=z.stat,se.hat=v.j,t.stat=z.stat,Q=5,lambda.mat,A=A,factor.mat,max.step=max.step,zero=TRUE)$covmat` 

produces a list of covariance matrices entitled *covmat"A".rds* upon
which to base the mixture of multivariate normals.

3) `compute.hm.train.log.lik(train.b = train.z,se.train = train.v,covmat = covmat,A,pen=TRUE) ##compute the HM weights on training data`

uses the set of randomly chosen genes to train our model and produces
a matrix of likelihoods and corresponding hierarchical weights,
*pis.rds* which represent the mixture proportions.

4) Finally, `weightedquants=lapply(seq(1:nrow(z.stat)),function(j){total.quant.per.snp(j,covmat,b.gp.hat=z.stat,se.gp.hat = v.j,pis,A,checkpoint = FALSE)})`

produces 6 .txt files containing the posterior means, upper and lower
tail probabilities, null probabilites, and lfsr for all J genes across
44 conditions.

### Figure plotting

The directory **Plots_for_Paper_vmat** contains .Rmd files to plot figures from the paper,
using our results which are provided in **Results_Data**. 

[Here is the link to the index](https://stephenslab.github.io/gtexresults_mash/Plots_for_Paper_vmat/IndexofPlots.html)
discussing the reproduction of all of the plots.

## License

*Add details of license here.*

## Contributors

*List people here who contributed to this project.*
