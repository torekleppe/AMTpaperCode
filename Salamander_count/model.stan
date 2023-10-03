functions {
  real poisson_zi_lpmf_(int y, real eta, real g){
    if(y==0){
      return log(exp(g)+exp(-exp(eta))) - log1p_exp(g);
    } else {
      return poisson_log_lpmf(y|eta) - log1p_exp(g);
    }
  }
}


// The input data is a vector 'y' of length 'N'.
data {
  int<lower=0> N;
  int<lower=0> D;
  int<lower=0> Nsite;
  array[N] int<lower=0> y;
  array[N] int<lower=0> site;
  matrix[N,D] sppd;
}

// The parameters accepted by the model. Our model
// accepts two parameters 'mu' and 'sigma'.
parameters {
  real<lower=0> sigmaSq;
  vector[Nsite] random_eff;
  vector[D] beta_level;
  vector[D] beta_zi;
}

transformed parameters{
  real sigma;
  vector[N] eta;
  vector[N] g;
  sigma = sqrt(sigmaSq);

  for(i in 1:N){
    eta[i] =  random_eff[site[i]] + dot_product(sppd[i],beta_level);
    g[i] = dot_product(sppd[i],beta_zi);
  }
}

model {
  // priors
  target += exponential_lpdf(sigmaSq|1.0);
  target += normal_lpdf(random_eff|0.0,sigma);
  target += normal_lpdf(beta_level|0.0,10.0);
  target += normal_lpdf(beta_zi|0.0,10.0);

  // likelihood
  for(i in 1:N){
    target += poisson_zi_lpmf_(y[i],eta[i],g[i]);
  }

}

