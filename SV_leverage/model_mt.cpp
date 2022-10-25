#include "amt.hpp"

using namespace amt;

struct model{


  DATA_VECTOR(y);



  void preProcess(){

  }

  template < class varType, class tensorType, bool storeNames>
  void operator()(amt::amtModel<varType,tensorType,storeNames> &model__){

    PARAMETER_VECTOR(zb,y.size()+1);
    PARAMETER_SCALAR(t_rho,0.0);
    PARAMETER_SCALAR(t_sigma,1.491654876777717); // default correspond to sigma=0.15

    // priors

    // sigma^2 \sim 10*0.01/\chi^2_10
    model__ += expGamma_ld(t_sigma,5.0,2.0);
    varType sigma = exp(0.5*(-2.302585092994046 - t_sigma));
    varType lprec = inv(square(sigma));
    model__.generated(asDouble(sigma),"sigma");

    // rho \sim uniform(-1,1)
    model__ += invLogitUniform_ld(t_rho);
    varType rho = -1.0 + 2.0*inv_logit(t_rho);
    model__.generated(asDouble(rho),"rho");



    // transformations and latent state prior
    VectorXv z(y.size()+1);
    z.coeffRef(0) = zb.coeff(0);
    for(size_t t=1;t<y.size()+1;t++) {
      z.coeffRef(t) = z.coeff(t-1) + sigma*zb.coeff(t);
      model__+=normal_ld(zb.coeff(t),0.0,1.0);
    }

    // observation likelihood
    varType sdfac = sqrt(1.0-square(rho));
    varType mnfac = rho/sigma;
    varType expfac;
    for(size_t i=0;i<y.size();i++){
      expfac = exp(0.5*z.coeff(i));
      model__ += normal_ld(y.coeff(i),expfac*mnfac*(z.coeff(i+1)-z.coeff(i)),expfac*sdfac);
    }



    model__.generated(asDouble(z.coeff(0)),"z0");
    model__.generated(asDouble(z.coeff(y.size())),"zT");
  }// operator()
};




