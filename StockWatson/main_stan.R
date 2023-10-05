rm(list=ls())

y <- as.vector(read.table("USdata_updated.txt")$x)

T <- length(y)

chains <- 8L

fit.s.0 <- rstan::stan("model.stan",data=list(T=T,y=y,addTauMean=0L),chains=chains)
fit.s.1 <- rstan::stan("model.stan",data=list(T=T,y=y,addTauMean=1L),chains=chains)

save.image("Computations_stan")

t.0 <- sum(rstan::get_elapsed_time(fit.s.0)[,"sample"])
t.1 <- sum(rstan::get_elapsed_time(fit.s.1)[,"sample"])
m.0 <- rstan::summary(fit.s.0)$summary
m.1 <- rstan::summary(fit.s.1)$summary

print(round(t.0))
print(round(t.1))

zt <- paste0("z[",1:(T-1),"]")
xt <- paste0("x[",1:T,"]")
taut <- paste0("tau[",1:T,"]")
all <- c("sigma",zt,xt,taut)
print(round(max(m.0[all,"Rhat"]),3))
print(round(max(m.1[all,"Rhat"]),3))

print(round(m.0["sigma","mean"],2))
print(round(m.1["sigma","mean"],2))

print(round(m.0["sigma","sd"],2))
print(round(m.1["sigma","sd"],2))

print(round(m.0["sigma","n_eff"]))
print(round(m.1["sigma","n_eff"]))

print(round(m.0["sigma","n_eff"]/t.0,1))
print(round(m.1["sigma","n_eff"]/t.1,1))

print(round(min(m.0[zt,"n_eff"])))
print(round(min(m.1[zt,"n_eff"])))

print(round(min(m.0[zt,"n_eff"])/t.0,1))
print(round(min(m.1[zt,"n_eff"])/t.1,1))

print(round(min(m.0[xt,"n_eff"])))
print(round(min(m.1[xt,"n_eff"])))

print(round(min(m.0[xt,"n_eff"])/t.0,1))
print(round(min(m.1[xt,"n_eff"])/t.1,1))

print(round(min(m.0[taut,"n_eff"])))
print(round(min(m.1[taut,"n_eff"])))

print(round(min(m.0[taut,"n_eff"])/t.0,1))
print(round(min(m.1[taut,"n_eff"])/t.1,1))


