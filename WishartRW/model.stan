functions {
  matrix toP3(row_vector zt){
    matrix[3,3] Lt;
    matrix[3,3] Lam;
    Lt[1,1] = 1.0;
    Lt[2,1] = 0.0;
    Lt[3,1] = 0.0;
    Lt[1,2] = zt[4];
    Lt[2,2] = 1.0;
    Lt[3,2] = 0.0;
    Lt[1,3] = zt[5];
    Lt[2,3] = zt[6];
    Lt[3,3] = 1.0;
    Lam[1,1] = exp(zt[1]);
    Lam[1,2] = 0.0;
    Lam[1,3] = 0.0;
    Lam[2,1] = 0.0;
    Lam[2,2] = exp(zt[2]);
    Lam[2,3] = 0.0;
    Lam[3,1] = 0.0;
    Lam[3,2] = 0.0;
    Lam[3,3] = exp(zt[3]);
    return(quad_form_sym(Lam,Lt));
  }
}


data {
  int<lower=0> N;
  matrix[N,3] y;
}


parameters {
  real<lower=0> nu;
  matrix[N,6] z;
}

transformed parameters{
  array[N] matrix[3,3] P;
  vector[N] ldet;
  vector[3] zeroVec;
  real invNu;
  invNu = 1.0/nu;
  zeroVec[1] = 0.0;
  zeroVec[2] = 0.0;
  zeroVec[3] = 0.0;

  for(t in 1:N){
    P[t] = toP3(z[t]);
    ldet[t] = 3.0*z[t,1] + 2.0*z[t,2] + z[t,3];
  }
}

model {
  // prior
  target += normal_lpdf(nu|250.0,20.0);

  // latent process and observations
  target += multi_normal_prec_lpdf(y[1]|zeroVec,P[1]);

  for(t in 2:N){
    target += wishart_lpdf(P[t]|nu,invNu*P[t-1]);
    target += multi_normal_prec_lpdf(y[t]|zeroVec,P[t]);
  }

  // add jacobian of transformation
  target += sum(ldet);
}

