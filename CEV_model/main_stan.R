rm(list=ls())

y <- as.vector(read.table("asdatasmall.dat")$V1)

chains <- 8L
init1 <- list(x=y)
init <- list(init1,init1,init1,init1,init1,init1,init1,init1)



fit.s <- rstan::stan("model.stan",
                     data=list(N=length(y),
                               y=y,
                               Delta=1.0/252.0),
                     chains=chains,
                     init=init)

# failed to converge, discontinued...


