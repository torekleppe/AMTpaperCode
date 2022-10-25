
load("Computations")

toP <- function(v){
  if(length(v)==6){
    L <- diag(3)
    L[2:3,1] <- v[4:5]
    L[3,2] <- v[6]
    Lam <- diag(exp(v[1:3]))
  }
  return(L%*%Lam%*%t(L))
}

chain <- 1
n <- 3
nele <- n*(n+1)/2
TT <- dim(y)[1]
a<-fit@pointSamples[,chain,]

niter <- dim(a)[1]
nchains <- dim(a)[2]



cvs <- array(0.0,dim=c(niter,TT,n,n))
for(t in 1:TT){
  for(iter in 1:2001){
    zcol <- a[iter,((t-1)*nele+1):(t*nele)]
    cvs[iter,t,,] <- solve(toP(zcol))
  }
}

sds <- matrix(0.0,3*n,TT)
corrs <- matrix(0.0,9,TT)
colnames(sds)<-rownames(y)
colnames(corrs)<-rownames(y)
for(t in 1:TT){
  for(i in 1:n){
    sds[((i-1)*3+1):(3*i),t] <- quantile(sqrt(cvs[1002:2001,t,i,i]),probs=c(0.1,0.5,0.9))
  }

  corrs[1:3,t] <- quantile(cvs[1002:2001,t,1,2]/sqrt(cvs[1002:2001,t,1,1]*cvs[1002:2001,t,2,2]),probs=c(0.1,0.5,0.9))
  corrs[4:6,t] <- quantile(cvs[1002:2001,t,1,3]/sqrt(cvs[1002:2001,t,1,1]*cvs[1002:2001,t,3,3]),probs=c(0.1,0.5,0.9))
  corrs[7:9,t] <- quantile(cvs[1002:2001,t,2,3]/sqrt(cvs[1002:2001,t,2,2]*cvs[1002:2001,t,3,3]),probs=c(0.1,0.5,0.9))



}

tgrid <- seq(from=2008,to=2012+94/365,length.out=TT)

corrnames <- c("AUD - CAD correlation", "AUD - CHF correlation", "CAD - CHF correlation")

pdf("wishRW.pdf",width=14,height = 7)
par(mfrow=c(2,n))
for(i in 1:n){
  plot(tgrid,abs(y[,i]),col="grey",type="l",ylim=c(0,4),
       xlab="time (year)",ylab="volatility (SD)",
       main=colnames(y)[i],cex.lab=1.4,cex.axis=1.4)
  lines(tgrid,sds[(i-1)*n+1,],col="red")
  lines(tgrid,sds[(i-1)*n+2,],col="black",lwd=2)
  lines(tgrid,sds[(i-1)*n+3,],col="blue")
}
for(i in 1:3){
plot(tgrid,corrs[3*(i-1)+1,],type="l",col="red",ylim=c(-1,1),
     xlab="time (year)",ylab="correlation",main=corrnames[i],cex.lab=1.4,cex.axis=1.4)
lines(tgrid,corrs[3*(i-1)+2,],col="black",lwd=2)
lines(tgrid,corrs[3*(i-1)+3,],col="blue")
}
dev.off()










