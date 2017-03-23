
thresh_inconsistent=function(effectsize,thresh,sigs){
  z= sapply(seq(1:nrow(effectsize)),function(x){
    l=sigs[x,];p=effectsize[x,];plow=p[which(l<thresh)];##grab only those posterior means that are 'significant'
    if(length(plow)==0){return("FALSE")}##for ones who show no significants, they can't be heterogenous
    else{pos=sum(plow>0);neg=sum(plow<0);pos*neg!=0}
  })
  return(sum(z==TRUE))}


het.norm=function(effectsize){
  t(apply(effectsize,1,function(x){
    x/x[which.max(abs(x))]
  }))}


sign.norm=function(effectsize){
  t(apply(effectsize,1,function(x){
    x/sign(x[which.max(abs(x))])
  }))}

sign.tissue.func=function(normdat){
  apply(normdat,1,function(x){
    sum(x<0)})}



#het.func=function(normdat,threshold){
#apply(abs(normdat),1,function(x){sum(x>threshold)})}

het.func=function(normdat,threshold){
    apply((normdat),1,function(x){sum(x>threshold)})}


hlindex=function(normdat,sigdat,thresh1,thresh2){
    hl=NULL
    for(j in 1:nrow(normdat)){
        hl[j]=sum(normdat[j,]>thresh1&sigdat[j,]<thresh2)}
    return(hl)}

het.index.two=function(data,thresh){
    t(apply(data,1,function(x){
        maxx=x[which.max(abs(x))]
        if(maxx==0){h=0}
        else{
            normx=x/x[which.max(abs(x))]
            
            h=sum(normx>thresh)}
        
        return(h)
        
    }))}



#rmse function to compute rmse
rmse=function(truth,estimate){
    sqrt( mean( (truth-estimate)^2) )
}