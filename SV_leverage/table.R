rm(list=ls())
load("Computations")

m.o <- pdmphmc::getMonitor(fit.opt)[[1]]
m.u <- pdmphmc::getMonitor(fit.uopt)[[1]]
m.h <- pdmphmc::getMonitor(fit.h)[[1]]

t.o <- sum(pdmphmc::get_CPU_time(fit.opt)[,"sampling"])
t.u <- sum(pdmphmc::get_CPU_time(fit.uopt)[,"sampling"])
t.h <- sum(pdmphmc::get_CPU_time(fit.h)[,"sampling"])

tab <- matrix(0.0,4,6)
tab[1,1] <- round(t.o)
tab[1,2] <- round(max(m.o[,"Rhat"]),3)

tab[3,1] <- round(t.h)
tab[3,2] <- round(max(m.h[,"Rhat"]),3)

tab[1,3] <- m.o["rho","n_eff"]
tab[3,3] <- m.h["rho","n_eff"]

tab[1,4] <- m.o["sigma","n_eff"]
tab[3,4] <- m.h["sigma","n_eff"]

tab[1,5] <- m.o["z0","n_eff"]
tab[3,5] <- m.h["z0","n_eff"]

tab[1,6] <- m.o["zT","n_eff"]
tab[3,6] <- m.h["zT","n_eff"]

tab[2,3:6] <- round(tab[1,3:6]/t.o,2)
tab[4,3:6] <- round(tab[3,3:6]/t.h,2)
