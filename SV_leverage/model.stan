
data {
  int<lower=0> N;
  vector[N] y;
}


parameters {
  real<lower=-1,upper=1> rho;
  real<lower=0> tsigma;
  vector[N+1] zb;
}

transformed parameters{
  real sigma;
  real sdfac;
  real mnfac;
  vector[N+1] z;
  vector[N] expfac;
  sigma = sqrt(0.1/tsigma);
  sdfac = sqrt(1.0-square(rho));
  mnfac = rho/sigma;
  z[1] = zb[1];
  for(t in 2:(N+1)){
    z[t] = z[t-1] + sigma*zb[2];
    expfac[t-1] = exp(0.5*z[t-1]);
  }

}


model {
  // priors
  target += chi_square_lpdf(tsigma|10.0);
  // prior on rho is uniform on (-1,1)

  // improper latent specification
  for(t in 2:(N+1)){
    target += normal_lpdf(zb[t]|0.0,1.0);
  }

  // likelihood
  for(t in 1:N){
    target += normal_lpdf(y[t]|expfac[t]*mnfac*(z[t+1]-z[t]),expfac[t]*sdfac);
  }

}


