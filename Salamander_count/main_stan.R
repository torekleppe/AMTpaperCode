rm(list=ls())


dta <- glmmTMB::Salamanders

chains <- 8L

# for reference

glmmOut <- glmmTMB::glmmTMB(count~spp + (1|site),zi=~spp,data=dta,family = poisson)


# transform data
# make dummies for species-column
lev <- levels(dta$spp)
pp <- length(lev)
n <- length(dta$spp)

spp.d <- matrix(0.0,nrow=n,ncol=pp)
spp.d[,1] <- 1.0
for(i in 2:pp) spp.d[,i] <- as.double(dta$spp==lev[i])

y <- dta$count
site <- as.integer(dta$site)


fit.s <-rstan::stan("model.stan",data=list(
  N=as.integer(length(y)),
  D=dim(spp.d)[2],
  Nsite=as.integer(max(site)),
  y=as.vector(y),
  site=as.vector(site),
  sppd=as.matrix(spp.d)
), chains=8L)


t <- sum(rstan::get_elapsed_time(fit.s)[,"sample"])
m <- rstan::summary(fit.s)$summary

bet.eta <- paste0("beta_level[",1:7,"]")
bet.g <- paste0("beta_zi[",1:7,"]")
bb <- paste0("random_eff[",1:max(site),"]")

all <- c(bet.eta,bet.g,bb,"sigma")
print(max(m[all,"Rhat"]))
print(round(m["sigma",c("mean","sd","n_eff")],2))
print(round(m["sigma","n_eff"]/t,1))

print(round(min(m[bet.eta,"n_eff"])))
print(round(min(m[bet.eta,"n_eff"])/t,1))
