library(zoo)
library(factorstochvol)
data("exrates", package = "stochvol")
m <- 3
n <- 1095
y <- 100 * logret(tail(exrates[, seq_len(m)], n + 1))
y <- zoo(y, order.by = tail(exrates$date, n))

chains <- 8L

options(mc.cores = 4L)
fit.s <- rstan::stan("model.stan",data=list(N=n,y=as.matrix(y)),chains=chains)




nms <- c()
for(i in 1:n) for(j in 1:6) nms <- c(nms,paste0("z[",i,",",j,"]"))

m <- summary(fit.s)$summary
t <- sum(rstan::get_elapsed_time(fit.s)[,"sample"])


print(round(t))
print(round(max(m[c("nu",nms),"Rhat"]),3))

print(round(m["nu","mean"],1))
print(round(m["nu","sd"],2))
print(round(m["nu","n_eff"]))
print(round(m["nu","n_eff"]/t,3))

print(round(min(m[nms,"n_eff"])))
print(round(min(m[nms,"n_eff"])/t,3))

print(round(median(m[nms,"n_eff"])))
print(round(median(m[nms,"n_eff"])/t,3))

print(round(max(m[nms,"n_eff"])))
print(round(max(m[nms,"n_eff"])/t,3))

