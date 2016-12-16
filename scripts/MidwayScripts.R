library('mash')
library('ExtremeDeconvolution')

t.stat=read.table("~/jul3/maxz.txt")
v.j=matrix(rep(1,ncol(t.stat)*nrow(t.stat)),ncol=ncol(t.stat),nrow=nrow(t.stat))
mean.mat=matrix(rep(0,ncol(t.stat)*nrow(t.stat)),ncol=ncol(t.stat),nrow=nrow(t.stat))
lambda.mat=as.matrix(read.table("~//jul3/zsfa_lambda.out"))
factor.mat=as.matrix(read.table("~//jul3/zsfa_F.out"))

ms=deconvolution.em.with.bovy(t.stat,factor.mat,v.j,lambda.mat,K=3,P=3)
#saveRDS(ms,"msnovemberwithfunccopy.rds")

max.step=readRDS("../aug3rank3/max.step3.rds")
z.stat=read.table("../maxz.txt")
rownames(z.stat)=NULL
colnames(z.stat)=NULL
library('mash')


v.j=matrix(rep(1,ncol(z.stat)*nrow(z.stat)),ncol=ncol(z.stat),nrow=nrow(z.stat))

lambda.mat=as.matrix(read.table("../zsfa_lambda.out"))
factor.mat=as.matrix(read.table("../zsfa_F.out"))

A="withzero"

covmat=compute.hm.covmat.all.max.step(b.hat=z.stat,se.hat=v.j,z.stat,v.j,Q=5,lambda.mat,A=A,factor.mat,max.step=max.step,zero=TRUE)

source("/project/mstephens/gtex/scripts/SumstatQuery.R")

ndat <- GetSS("null", "/project/mstephens/gtex/analysis/april2015/query/MatrixEQTLSumStats.h5")

train.z=ndat$z[1:20000,]
rownames(train.z)=NULL
colnames(train.z)=NULL

train.v=matrix(rep(1,ncol(train.z)*nrow(train.z)),ncol=ncol(train.z),nrow=nrow(train.z))

tim=proc.time()

compute.hm.train.log.lik(train.b = train.z,se.train = train.v,covmat = covmat,A,pen=TRUE) ##compute the HM weights on training data
proc.time()-tim


pis=readRDS(paste0("pis",A,".rds"))$pihat
z.stat=read.table("../maxz.txt")

tim=proc.time()
weightedquants=lapply(seq(1:nrow(z.stat)),function(j){total.quant.per.snp(j,covmat,b.gp.hat=z.stat,se.gp.hat = v.j,pis,A,checkpoint = FALSE)})