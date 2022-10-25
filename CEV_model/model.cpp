#include "amt.hpp"

using namespace amt;

struct model{


  DATA_VECTOR(y);

  double Delta;
  double sqrtDelta;

  void preProcess(){
    Delta = 1.0/252.0;
    sqrtDelta = sqrt(Delta);
  }

  template < class varType, class tensorType, bool storeNames>
  void operator()(amt::amtModel<varType,tensorType,storeNames> &model__){

    PARAMETER_VECTOR(x,y.size(),y);

    PARAMETER_SCALAR(alpha,0.0099);
    PARAMETER_SCALAR(beta,0.168);
    PARAMETER_SCALAR(logsxSq,-1.783196);
    PARAMETER_SCALAR(tgam,-2.0);
    PARAMETER_SCALAR(logsySq,-15.04788);

    size_t T = y.size();

    // priors and transformations

    model__+=normal_ld(alpha,0.0,10.0/Delta);
    model__+=normal_ld(beta,1.0/Delta,10.0/Delta);



    varType sx = exp(0.5*logsxSq);

    model__+=invLogitUniform_ld(tgam);
    varType gam = 10.0*inv_logit(tgam); // gamma \sim uniform(0.0,10.0)

    varType sy = exp(0.5*logsySq);

    // latent process

    model__ += normal_ld(x.coeff(0),0.09569,0.01);
    varType mn,sd;
    varType sxSqrtDel = sx*sqrtDelta;
    for(size_t t=1;t<T;t++){
      mn = x.coeff(t-1) + Delta*(alpha-beta*x.coeff(t-1));
      sd = sxSqrtDel*pow(x.coeff(t-1),gam);
      model__ += normal_ld(x.coeff(t),mn,sd);
    }

    // observation noise
    model__ += normal_ld(y,x,sy);


    model__.generated(asDouble(alpha),"alpha_gen");
    model__.generated(asDouble(beta),"beta_gen");
    model__.generated(asDouble(sx),"sx_gen");
    model__.generated(asDouble(gam),"gam_gen");
    model__.generated(asDouble(sy),"sy_gen");
    model__.generated(asDouble(x.coeff(0)),"x1_gen");
    model__.generated(asDouble(x.coeff(T-1)),"xT_gen");


  }// operator()
};




