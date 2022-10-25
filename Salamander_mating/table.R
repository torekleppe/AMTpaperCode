if(1==1){
load("Computations")
mh <- getMonitor(fit.h)[[1]]
m <- getMonitor(fit)[[1]]
th <- mean(get_CPU_time(fit.h)[,"sampling"])
t <- mean(get_CPU_time(fit)[,"sampling"])
}
tab <- matrix(0.0,11,4)


tab[1,1] <- t*8
tab[1,2] <- max(m[,"Rhat"])
tab[1,3] <- th*8
tab[1,4] <- max(mh[,"Rhat"])
tab[2,1] <- m["WF[1,1]","n_eff"]
tab[2,2] <- m["WF[1,1]","n_eff"]/(8*t)
tab[2,3] <- mh["WF[1,1]","n_eff"]
tab[2,4] <- mh["WF[1,1]","n_eff"]/(8*th)

tab[3,1] <- m["WF[2,1]","n_eff"]
tab[3,2] <- m["WF[2,1]","n_eff"]/(8*t)
tab[3,3] <- mh["WF[2,1]","n_eff"]
tab[3,4] <- mh["WF[2,1]","n_eff"]/(8*th)

tab[4,1] <- m["WF[2,2]","n_eff"]
tab[4,2] <- m["WF[2,2]","n_eff"]/(8*t)
tab[4,3] <- mh["WF[2,2]","n_eff"]
tab[4,4] <- mh["WF[2,2]","n_eff"]/(8*th)

tab[5,1] <- m["WM[1,1]","n_eff"]
tab[5,2] <- m["WM[1,1]","n_eff"]/(8*t)
tab[5,3] <- mh["WM[1,1]","n_eff"]
tab[5,4] <- mh["WM[1,1]","n_eff"]/(8*th)

tab[6,1] <- m["WM[2,1]","n_eff"]
tab[6,2] <- m["WM[2,1]","n_eff"]/(8*t)
tab[6,3] <- mh["WM[2,1]","n_eff"]
tab[6,4] <- mh["WM[2,1]","n_eff"]/(8*th)

tab[7,1] <- m["WM[2,2]","n_eff"]
tab[7,2] <- m["WM[2,2]","n_eff"]/(8*t)
tab[7,3] <- mh["WM[2,2]","n_eff"]
tab[7,4] <- mh["WM[2,2]","n_eff"]/(8*th)

tab[8,1] <- m["kappaF","n_eff"]
tab[8,2] <- m["kappaF","n_eff"]/(8*t)
tab[8,3] <- mh["kappaF","n_eff"]
tab[8,4] <- mh["kappaF","n_eff"]/(8*th)

tab[9,1] <- m["kappaM","n_eff"]
tab[9,2] <- m["kappaM","n_eff"]/(8*t)
tab[9,3] <- mh["kappaM","n_eff"]
tab[9,4] <- mh["kappaM","n_eff"]/(8*th)

rnames <- rownames(m)
betars <- grep("beta",rnames,fixed=TRUE)

tab[10,1] <- min(m[betars,"n_eff"])
tab[10,2] <- min(m[betars,"n_eff"])/(8*t)
tab[10,3] <- min(mh[betars,"n_eff"])
tab[10,4] <- min(mh[betars,"n_eff"])/(8*th)

brs <- c(grep("b12f",rnames,fixed=TRUE),grep("b12m",rnames,fixed=TRUE),grep("b3f",rnames,fixed=TRUE),grep("b3m",rnames,fixed=TRUE))

tab[11,1] <- min(m[brs,"n_eff"])
tab[11,2] <- min(m[brs,"n_eff"])/(8*t)
tab[11,3] <- min(mh[brs,"n_eff"])
tab[11,4] <- min(mh[brs,"n_eff"])/(8*th)

tab[,1] <- round(tab[,1])
tab[,3] <- round(tab[,3])
tab[2:11,2] <- round(tab[2:11,2],1)
tab[2:11,4] <- round(tab[2:11,4],1)


