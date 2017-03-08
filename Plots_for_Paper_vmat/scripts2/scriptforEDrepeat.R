library('mashr')
library('ExtremeDeconvolution')
t.stat=read.table("~/jul3/maxz.txt")
s.j=matrix(rep(1,ncol(t.stat)*nrow(t.stat)),ncol=ncol(t.stat),nrow=nrow(t.stat))
v.mat=readRDS("~/test.train/vhat.RDS")
v.j=list()
for(i in 1:nrow(t.stat)){v.j[[i]]=v.mat}
mean.mat=matrix(rep(0,ncol(t.stat)*nrow(t.stat)),ncol=ncol(t.stat),nrow=nrow(t.stat))
lambda.mat=as.matrix(read.table("~//jul3/zsfa_lambda.out"))
factor.mat=as.matrix(read.table("~//jul3/zsfa_F.out"))
permsnp=10
K=3;P=3;R=44
init.cov=init.covmat(t.stat=t.stat,factor.mat = factor.mat,lambda.mat = lambda.mat,K=K,P=P)
init.cov.list=list()
for(i in 1:K){init.cov.list[[i]]=init.cov[i,,]}
head(init.cov.list)

ydata=  t.stat
xamp= rep(1/K,K)
xcovar= init.cov.list
fixmean= TRUE     
ycovar=  v.j     
xmean=   mean.mat   
projection= list();for(l in 1:nrow(t.stat)){projection[[l]]=diag(1,R)}

e=extreme_deconvolution(ydata=ydata,ycovar=ycovar,xamp=xamp,xmean=xmean,xcovar=init.cov.list,fixmean=T,projection=projection)

true.covs=array(dim=c(K,R,R))
for(i in 1:K){true.covs[i,,]=e$xcovar[[i]]}
pi=e$xamp

max.step=list(true.covs=true.covs,pi=pi)
saveRDS(max.step,paste0("max.steps303",P,".rds"))


ms=deconvolution.em.with.bovy(t.stat,factor.mat,v.j,lambda.mat,K=3,P=3)
saveRDS(ms,"mswithfunction.rds")

all.equal(ms,max.step)