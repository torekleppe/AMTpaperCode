
data {
  int<lower=0> N;
  vector[N] y;
  real Delta;
}


parameters {
  real alpha;
  real beta;
  real logsigmaxSq;
  real<lower=0> gamma;
  real logsigmaySq;
  vector[N] x;
}

transformed parameters{
  real sigmax;
  real sigmay;
  real sdFac;
  sigmax = exp(0.5*logsigmaxSq);
  sigmay = exp(0.5*logsigmaySq);
  sdFac = sigmax*sqrt(Delta);
}

model {
  // priors
  target += normal_lpdf(alpha|0.0,10.0/Delta);
  target += normal_lpdf(beta|1/Delta,10.0/Delta);
  // remaining priors are flat

  // latent process and observations
  target += normal_lpdf(x[1]|0.09569,0.01);
  target += normal_lpdf(y[1]|x[1],sigmay);

  for(t in 2:N){
    target += normal_lpdf(x[t]|x[t-1]+Delta*(alpha-beta*x[t-1]),sdFac*pow(x[t-1],gamma));
    target += normal_lpdf(y[t]|x[t],sigmay);
  }

}

