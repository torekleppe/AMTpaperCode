rm(list=ls())
require(pdmphmc)

y <- 100.0*as.vector(read.table("returns_sp500_99_09.txt")$V1)

chains <- 8L
Tmax <- 10000


mdl.opt <- pdmphmc::build("model_opt.cpp",process.type = "RM")
fit.opt <- pdmphmc::run(mdl.opt,Tmax=Tmax,data=list(y=y),
                        store.pars=c("t_sigma","t_rho"),
                        chains=chains,cores=4L)

mdl.uopt <- pdmphmc::build("model_unopt.cpp",process.type = "RM")
fit.uopt <- pdmphmc::run(mdl.uopt,Tmax=Tmax,data=list(y=y),
                          store.pars=c("t_sigma","t_rho"),
                          chains=chains,cores=4L)

mdl.h <- pdmphmc::build("model_mt.cpp",process.type = "HMC")
fit.h <- pdmphmc::run(mdl.h,Tmax=Tmax,data=list(y=y),
                        store.pars=c("t_sigma","t_rho"),
                        chains=4L,cores=4L)

save.image("Computations")


