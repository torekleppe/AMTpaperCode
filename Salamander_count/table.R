if(1==0){
rm(list=ls())
load("Computations")

m.h <- pdmphmc::getMonitor(fit.h)[[1]]
m.r <- pdmphmc::getMonitor(fit.rmd)[[1]]

t.h <- sum(pdmphmc::get_CPU_time(fit.h)[,"sampling"])
t.r <- sum(pdmphmc::get_CPU_time(fit.rmd)[,"sampling"])

}

tab <- matrix(0.0,4,8)
tab[1,1] <- round(t.r)
tab[3,1] <- round(t.h)
tab[1,2] <- round(max(m.r[,"Rhat"]),3)
tab[3,2] <- round(max(m.h[,"Rhat"]),3)

tab[1,3] <- round(m.r["sigma","mean"],2)
tab[3,3] <- round(m.h["sigma","mean"],2)

tab[1,4] <- round(m.r["sigma","sd"],2)
tab[3,4] <- round(m.h["sigma","sd"],2)

tab[1,5] <- round(m.r["sigma","n_eff"])
tab[3,5] <- round(m.h["sigma","n_eff"])

rnms <- row.names(m.r)
feta <- grep("beta_level",rnms,fixed=TRUE)

tab[1,6] <- round(min(m.r[feta,"n_eff"]))
tab[3,6] <- round(min(m.h[feta,"n_eff"]))

fg <- grep("beta_zi",rnms,fixed=TRUE)

tab[1,7] <- round(min(m.r[fg,"n_eff"]))
tab[3,7] <- round(min(m.h[fg,"n_eff"]))

fre <- grep("random_eff",rnms,fixed=TRUE)

tab[1,8] <- round(min(m.r[fre,"n_eff"]))
tab[3,8] <- round(min(m.h[fre,"n_eff"]))

tab[2,5:8] <- round(tab[1,5:8]/t.r,1)
tab[4,5:8] <- round(tab[3,5:8]/t.h,1)

print(tab)
