require(pdmphmc)

y <- as.vector(read.table("asdatasmall.dat")$V1)

chains <- 8L

mdl <- pdmphmc::build("model.cpp",process.type = "RM")

fit <- run(mdl,data=list(y=y),
           chains=chains,cores=4L,
           store.pars = c("alpha","beta","logsxSq","tgam","logsySq"))

m <- getMonitor(fit)[[1]]

save.image("Computations")
