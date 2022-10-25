
#include "amt.hpp"

using namespace amt;

struct model{


  DATA_VECTOR(y);

  void preProcess(){

  }

  template < class varType, class tensorType, bool storeNames>
  void operator()(amt::amtModel<varType,tensorType,storeNames> &model__){

    PARAMETER_VECTOR(lat,3*y.size());
    PARAMETER_SCALAR(lambda,0.0);

    size_t T = y.size();

    model__+= expGamma_ld(lambda,5.0,1.0/0.5);
    varType latSD = exp(-0.5*lambda);

    /*  note see DRHMC paper for definition
     * lat(0..T-1) : z
     * lat(T..2*T-1) : x
     * lat(2*T..3*T-1) : tau
     */

    // initial observation
    model__+= normal_ld(y.coeff(0),lat.coeff(2*T),exp(0.5*lat.coeff(T)));

    for(size_t t=1;t<T;t++){
      // z-dynamics
      model__+= normal_ld(lat.coeff(t),lat.coeff(t-1),latSD);
      // x-dynamics
      model__+= normal_ld(lat.coeff(T+t),lat.coeff(T+t-1),latSD);
      // tau-dynamics
      model__+= normal_ld(lat.coeff(2*T+t),lat.coeff(2*T+t-1),exp(0.5*lat.coeff(t-1)));
      // observations
      model__+= normal_ld(y.coeff(t),lat.coeff(2*T+t),exp(0.5*lat.coeff(T+t)));
    }


    model__.generated(asDouble(latSD),"sigma");
    model__.generated(asDouble(lambda),"lambda_gen");

  }// operator()
};




