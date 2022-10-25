rm(list=ls())
require(pdmphmc)

chains <- 8L
y <- as.vector(read.table("USdata_updated.txt")$x)

mdl <- pdmphmc::build("model.cpp",process.type = "RM")

fit <- pdmphmc::run(mdl,data=list(y=y),chains=chains,cores=4L)


mdl.h <- pdmphmc::build("model_dr.cpp",process.type = "HMC")

fit.h0 <- pdmphmc::run(mdl.h,data=list(y=y,addTauMean=0L),chains=chains,cores=4L)
fit.h1 <- pdmphmc::run(mdl.h,data=list(y=y,addTauMean=1L),chains=chains,cores=4L)



save.image("Computations")

