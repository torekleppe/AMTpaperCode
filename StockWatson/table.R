
load("Computations")

y <- as.vector(read.table("USdata_updated.txt")$x)
TT <- length(y)
zr <- 1:TT
xr <- (TT+1):(2*TT)
tr <- (2*TT+1):(3*TT)

tab <- matrix(0.0,6,8)

t.h0 <- sum(pdmphmc::get_CPU_time(fit.h0)[,"sampling"])
t.h1 <- sum(pdmphmc::get_CPU_time(fit.h1)[,"sampling"])
t <- sum(pdmphmc::get_CPU_time(fit)[,"sampling"])

m.h0 <- pdmphmc::getMonitor(fit.h0)[[1]]
m.h1 <- pdmphmc::getMonitor(fit.h1)[[1]]
m <- pdmphmc::getMonitor(fit)[[1]]

tab[1,1] <- round(t.h0)
tab[3,1] <- round(t.h1)
tab[5,1] <- round(t)

tab[1,2] <- round(max(m.h0[,"Rhat"]),3)
tab[3,2] <- round(max(m.h1[,"Rhat"]),3)
tab[5,2] <- round(max(m[,"Rhat"]),3)

tab[1,3] <- round(m.h0["sigma","mean"],2)
tab[3,3] <- round(m.h1["sigma","mean"],2)
tab[5,3] <- round(m["sigma","mean"],2)

tab[1,4] <- round(m.h0["sigma","sd"],2)
tab[3,4] <- round(m.h1["sigma","sd"],2)
tab[5,4] <- round(m["sigma","sd"],2)

tab[1,5] <- m.h0["sigma","n_eff"]
tab[3,5] <- m.h1["sigma","n_eff"]
tab[5,5] <- m["sigma","n_eff"]

tab[2,5] <- round(m.h0["sigma","n_eff"]/(t.h0),1)
tab[4,5] <- round(m.h1["sigma","n_eff"]/(t.h1),1)
tab[6,5] <- round(m["sigma","n_eff"]/(t),1)

tab[1,6] <- min(m.h0[grep("z[",rownames(m.h0),fixed=TRUE),"n_eff"])
tab[3,6] <- min(m.h1[grep("z[",rownames(m.h1),fixed=TRUE),"n_eff"])
tab[5,6] <- min(m[zr,"n_eff"])

tab[2,6] <- round(tab[1,6]/(t.h0),1)
tab[4,6] <- round(tab[3,6]/(t.h1),1)
tab[6,6] <- round(tab[5,6]/(t),1)

tab[1,7] <- min(m.h0[grep("x[",rownames(m.h0),fixed=TRUE),"n_eff"])
tab[3,7] <- min(m.h1[grep("x[",rownames(m.h1),fixed=TRUE),"n_eff"])
tab[5,7] <- min(m[xr,"n_eff"])

tab[2,7] <- round(tab[1,7]/(t.h0),1)
tab[4,7] <- round(tab[3,7]/(t.h1),1)
tab[6,7] <- round(tab[5,7]/(t),1)

tab[1,8] <- min(m.h0[grep("tau[",rownames(m.h0),fixed=TRUE),"n_eff"])
tab[3,8] <- min(m.h1[grep("tau[",rownames(m.h1),fixed=TRUE),"n_eff"])
tab[5,8] <- min(m[tr,"n_eff"])

tab[2,8] <- round(tab[1,8]/(t.h0),1)
tab[4,8] <- round(tab[3,8]/(t.h1),1)
tab[6,8] <- round(tab[5,8]/(t),1)
