if(1==1){
load("Computations")
mm <- getMonitor(fit)[[1]]
mm2 <- getMonitor(fit.v2)[[1]]
mf <- getMonitor(fit.h)[[1]]
}
npars <- dim(mm)[1]
neffs<-mm[,"n_eff"]
neffs2<-mm2[,"n_eff"]
neffs.h<-mf[,"n_eff"]
cr <- sum(get_CPU_time(fit)[,"sampling"])
cr2 <- sum(get_CPU_time(fit.v2)[,"sampling"])
ch <- sum(get_CPU_time(fit.h)[,"sampling"])



tab <- matrix(0.0,6,8)

tab[1,1] <- round(cr)
tab[1,2] <- round(mm["nu","mean"],1)
tab[1,3] <- round(mm["nu","sd"],2)
tab[1,4] <- mm["nu","n_eff"]
tab[1,5] <- round(min(neffs[1:(npars-1)]))
tab[1,6] <- round(median(neffs[1:(npars-1)]))
tab[1,7] <- max(neffs[1:(npars-1)])
tab[2,4:7] <- round(tab[1,4:7]/(cr),3)
tab[1,8] <- max(mm[,"Rhat"])


tab[3,1] <- round(cr2)
tab[3,2] <- round(mm2["nu","mean"],1)
tab[3,3] <- round(mm2["nu","sd"],2)
tab[3,4] <- mm2["nu","n_eff"]
tab[3,5] <- round(min(neffs2[1:(npars-1)]))
tab[3,6] <- round(median(neffs2[1:(npars-1)]))
tab[3,7] <- max(neffs2[1:(npars-1)])
tab[4,4:7] <- round(tab[3,4:7]/(cr2),3)
tab[3,8] <- max(mm2[,"Rhat"])

tab[5,1] <- round(ch)
tab[5,2] <- round(mf["nu","mean"],1)
tab[5,3] <- round(mf["nu","sd"],2)
tab[5,4] <- mf["nu","n_eff"]
tab[5,5] <- round(min(neffs.h[1:(npars-1)]))
tab[5,6] <- round(median(neffs.h[1:(npars-1)]))
tab[5,7] <- max(neffs.h[1:(npars-1)])
tab[6,4:7] <- round(tab[5,4:7]/(ch),3)
tab[5,8] <- max(mf[,"Rhat"])

#print(xtable::xtable(tab),file="table_wishart_SV.tex")
print(tab)
