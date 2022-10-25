#include "amt.hpp"

using namespace amt;

struct model{


  DATA_IVECTOR(y);
  DATA_IVECTOR(site);
  DATA_MATRIX(sppd);

  int p;
  int n;
  int nsite;

  void preProcess(){
    p = sppd.cols();
    n = sppd.rows();
    nsite = site.maxCoeff()+1;
  }

  template < class varType, class tensorType, bool storeNames>
  void operator()(amt::amtModel<varType,tensorType,storeNames> &model__){


    PARAMETER_SCALAR(logSsq);
    PARAMETER_VECTOR(random_eff,nsite);
    PARAMETER_VECTOR(beta_level,p);
    PARAMETER_VECTOR(beta_zi,p);



    model__ += expGamma_ld(logSsq,1.0,1.0);
    varType sigma = exp(0.5*logSsq);
    model__.generated(asDouble(sigma),"sigma");

    model__ += normal_ld(beta_level,0.0,10.0);
    model__ += normal_ld(beta_zi,0.0,10.0);
    model__ += normal_ld(random_eff,0.0,sigma);

    VectorXv eta;
    VectorXv g;
    matVecProd(sppd,beta_level,eta);
    matVecProd(sppd,beta_zi,g);

    for(int i=0;i<n;i++){
      model__+= ziPoisson_log_lm(
        y.coeff(i),
        eta.coeff(i)+random_eff.coeff(site.coeff(i)),
        g.coeff(i));
    }

  }// operator()
};




