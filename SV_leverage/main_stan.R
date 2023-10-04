rm(list=ls())

y <- 100.0*as.vector(read.table("returns_sp500_99_09.txt")$V1)
N <- length(y)
chains <- 8L

fit.s <- rstan::stan("model.stan",data=list(N=N,y=y),chains=chains)

m <- rstan::summary(fit.s)$summary

# note; sampler does not converge, and in particular produces a rho\approx 0.
# Therefore, not included in table.
