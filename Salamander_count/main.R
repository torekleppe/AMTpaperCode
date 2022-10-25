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
site <- as.integer(dta$site)-1


# pdmphmc -computations

mdl.h <- pdmphmc::build("model.cpp")
fit.h <- pdmphmc::run(mdl.h,
                      data=list(y=y,site=site,sppd=spp.d),
                      chains=chains,cores=4L)


mdl.rmd <- pdmphmc::build("model.cpp",process.type = "RM",metric.tensor.type = "Dense")
fit.rmd <- pdmphmc::run(mdl.rmd,
                       data=list(y=y,site=site,sppd=spp.d),
                       chains=chains,cores=4L)


save.image("Computations")

