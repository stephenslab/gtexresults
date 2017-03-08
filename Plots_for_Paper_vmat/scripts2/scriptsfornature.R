library('mashr')

source("/project/mstephens/gtex/scripts/SumstatQuery.R")

ndat <- GetSS("null", "/project/mstephens/gtex/analysis/april2015/query/MatrixEQTLSumStats.h5")


##This is how the vhat was generated

#max_absz = apply(abs(ndat$z),1, max)
#nullish = which(max_absz < 2)
#nz = dat$z[nullish,]
#vhat = cor(nz)
#saveRDS(vhat,file = "vhat.RDS")


max.step=readRDS("max.steps3033.rds")
z.stat=read.table("../maxz.txt")
rownames(z.stat)=NULL
colnames(z.stat)=NULL


v.mat=readRDS("~/test.train/vhat.RDS")


v.j=matrix(rep(1,ncol(z.stat)*nrow(z.stat)),ncol=ncol(z.stat),nrow=nrow(z.stat))



lambda.mat=as.matrix(read.table("../zsfa_lambda.out"))
factor.mat=as.matrix(read.table("../zsfa_F.out"))

A="withvhat"

covmat=compute.hm.covmat.all.max.step(b.hat=z.stat,se.hat=v.j,t.stat=z.stat,Q=5,lambda.mat,A=A,factor.mat=factor.mat,max.step=max.step,zero=TRUE)$covmat


train.z=as.matrix(read.table("../withzero/trainz.txt"))
#train.z=ndat$z[1:20000,]
rownames(train.z)=NULL
colnames(train.z)=NULL
train.v=train.z/train.z


#compute.hm.train.log.lik.pen.vmat(train.b = train.z,covmat = covmat,A = A,pen = 1,train.s = train.v,cormat = v.mat)

pis=readRDS(paste0("pis",A,".rds"))$pihat
z.stat=read.table("../maxz.txt")

tim=proc.time()
weightedquants=lapply(seq(1:nrow(z.stat)),function(j){
  total.quant.per.snp.with.vmat(j=j, covmat=covmat, b.gp.hat=z.stat, cormat=v.mat, se.gp.hat=v.j, pis=pis, A=A, checkpoint = FALSE)})
tim-proc.time()
