load("Computations")

t <- sum(pdmphmc::get_CPU_time(fit)[,"sampling"])
m <- pdmphmc::getMonitor(fit)[[1]]

max.Rhat <- max(m[,"Rhat"])

tab <- matrix(0.0,7,4)

tab[1,1] <- m["alpha","mean"]
tab[1,2] <- m["alpha","sd"]
tab[1,3] <- m["alpha","n_eff"]
tab[1,4] <- m["alpha","n_eff"]/(t)

tab[2,1] <- m["beta","mean"]
tab[2,2] <- m["beta","sd"]
tab[2,3] <- m["beta","n_eff"]
tab[2,4] <- m["beta","n_eff"]/(t)

tab[3,1] <- m["sx_gen","mean"]
tab[3,2] <- m["sx_gen","sd"]
tab[3,3] <- m["sx_gen","n_eff"]
tab[3,4] <- m["sx_gen","n_eff"]/(t)

tab[4,1] <- m["gam_gen","mean"]
tab[4,2] <- m["gam_gen","sd"]
tab[4,3] <- m["gam_gen","n_eff"]
tab[4,4] <- m["gam_gen","n_eff"]/(t)

tab[5,1] <- m["sy_gen","mean"]
tab[5,2] <- m["sy_gen","sd"]
tab[5,3] <- m["sy_gen","n_eff"]
tab[5,4] <- m["sy_gen","n_eff"]/(t)

tab[6,1] <- m["x1_gen","mean"]
tab[6,2] <- m["x1_gen","sd"]
tab[6,3] <- m["x1_gen","n_eff"]
tab[6,4] <- m["x1_gen","n_eff"]/(t)

tab[7,1] <- m["xT_gen","mean"]
tab[7,2] <- m["xT_gen","sd"]
tab[7,3] <- m["xT_gen","n_eff"]
tab[7,4] <- m["xT_gen","n_eff"]/(t)
