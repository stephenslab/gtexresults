# gtexresults_mash

The purpose of this repo is to store the results of  the mixture model, which uses a mixture of multivariate normals to estimate the effect size of a genetic variant on gene expression across 44 tissues, as ascertained from the GTEX project.

## Using this Repo

In this directory, under the folder *scripts* you will find the notated script, `MidwayScripts.Rmd` to reproduce the results found in Urbut et al.

1) You'll note that the input data necessary to run this analysis is all available under inputs. This may take some time to run, and so we recommend using a cluster or submittable file system. We have conveniently provided the user with the outputs of running mash in **Results_Data**.

This repo is organized so that you can run Mash using the gteX data contained in **Inputs** to produce the parameters and posteriors from mashr.

2) The script, `MidwayScripts.Rmd` here will help you to produce several sets of files
	
	1)`ms=deconvolution.em.with.bovy(t.stat,factor.mat,v.j,lambda.mat,K=3,	P=3)`

produces an object with the denoised matrices for feeding into the *mash* covariance code. The *factor.mat* and *lambda.mat* called within have been produced by SFA and are single rank factors and loadings approximating the empirical covariance.

2)`covmat=compute.hm.covmat.all.max.step(b.hat=z.stat,se.hat=v.j,t.stat=z.stat,Q=5,lambda.mat,A=A,factor.mat,max.step=max.step,zero=TRUE)$covmat` 

produces a list of covariance matrices entitled *covmat"A".rds* upon which to base the mixture of multivariate normals. 

3) `compute.hm.train.log.lik(train.b = train.z,se.train = train.v,covmat = covmat,A,pen=TRUE) ##compute the HM weights on training data`

uses the set of randomly chosen genes to train our model and produces a matrix of likelihoods and corresponding hierarchical weights, *pis.rds* which represent the mixture proportions.

4) Finally, `weightedquants=lapply(seq(1:nrow(z.stat)),function(j){total.quant.per.snp(j,covmat,b.gp.hat=z.stat,se.gp.hat = v.j,pis,A,checkpoint = FALSE)})`

produces 6 .txt files containing the posterior means, upper and lower tail probabilities, null probabilites, and lfsr for all J genes across 44 conditions.

###Producing Figures

If you wish to produce all the results from the paper without running mashr first, the directory **Plots_for_Paper** has a .Rmd to neatly produce the results for each figure neatly. Because we have provided the results from running Mash on the gtex data in **Results_Data** you need not run mashr on the gtex data, and can instead use this output to produce the figures.