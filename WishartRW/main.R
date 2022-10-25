library(zoo)
library(factorstochvol)
data("exrates", package = "stochvol")
m <- 3
n <- 1095
y <- 100 * logret(tail(exrates[, seq_len(m)], n + 1))
y <- zoo(y, order.by = tail(exrates$date, n))

chains <- 8L


mdl <- pdmphmc::build("model.cpp",process.type = "RM")
fit <- pdmphmc::run(mdl,data=list(y=as.matrix(y)),chains=chains,cores=4L)
pdmphmc::clean.model(mdl)

mdl.v2 <- pdmphmc::build("model.cpp",process.type = "RM",include="-D __WISHARTRW1_VARIANT2__")
fit.v2 <- pdmphmc::run(mdl.v2,data=list(y=as.matrix(y)),chains=chains,cores=4L)
pdmphmc::clean.model(mdl.v2)

mdl.h <- pdmphmc::build("model.cpp",process.type = "HMC")
fit.h <- pdmphmc::run(mdl.h,data=list(y=as.matrix(y)),chains=chains,cores=4L)
pdmphmc::clean.model(mdl.h)



save.image("Computations")

