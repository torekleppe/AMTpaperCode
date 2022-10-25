/*
 * Note: not intended to be run using Riemannian sampler!!!
 *
 */


#include "amt.hpp"

using namespace amt;

struct model{


  DATA_VECTOR(y);
  DATA_INT(addTauMean);
  void preProcess(){

  }

  template < class varType, class tensorType, bool storeNames>
  void operator()(amt::amtModel<varType,tensorType,storeNames> &model__){

    PARAMETER_VECTOR(zb,y.size()-1);
    PARAMETER_VECTOR(xb,y.size());
    PARAMETER_VECTOR(taub,y.size());
    PARAMETER_SCALAR(lambda,0.0);

    size_t T = y.size();

    model__+= expGamma_ld(lambda,5.0,1.0/0.5);
    varType latSD = exp(-0.5*lambda);
    varType lprec = exp(lambda);
    /*  note see DRHMC paper for definition
     * lat(0..T-1) : z
     * lat(T..2*T-1) : x
     * lat(2*T..3*T-1) : tau
     */

    // transformations
    triDiagChol<varType> Lz(T-1,lprec+0.5,2.0*lprec+0.5,-lprec);
    VectorXv z(T-1);
    Lz.LT_solve(zb,z);


    triDiagChol<varType> Lx(T,lprec+0.5,2.0*lprec+0.5,-lprec);
    VectorXv x(T);
    Lx.LT_solve(xb,x);

    VectorXv expmz(T-1);
    VectorXv G4diag(T);
    VectorXv Pyy(T);

    for(size_t i=0;i<T-1;i++) expmz.coeffRef(i) = exp(-z.coeff(i));
    for(size_t i=0;i<T;i++) G4diag.coeffRef(i) = exp(-x.coeff(i));
    if(addTauMean>0){
      for(size_t i=0;i<T;i++) Pyy.coeffRef(i) = G4diag.coeff(i)*y.coeff(i);
    }

    G4diag.coeffRef(0) += expmz.coeff(0);
    for(size_t i=1;i<T-1;i++) G4diag.coeffRef(i) += expmz.coeff(i-1)+expmz.coeff(i);
    G4diag.coeffRef(T-1) += expmz.coeff(T-2);

    triDiagChol<varType> Ltau(G4diag,-expmz);
    VectorXv tau;
    Ltau.LT_solve(taub,tau);

    if(addTauMean>0){
      Ltau.L_solve_inplace(Pyy);
      Ltau.LT_solve_inplace(Pyy);
      tau += Pyy;
    }






    // initial observation
    model__+= normal_ld(y.coeff(0),tau.coeff(0),exp(0.5*x.coeff(0)));

    for(size_t t=1;t<T;t++){
      // z-dynamics
      if(t<T-1) model__+= normal_ld(z.coeff(t),z.coeff(t-1),latSD);
      // x-dynamics
      model__+= normal_ld(x.coeff(t),x.coeff(t-1),latSD);
      // tau-dynamics
      model__+= normal_ld(tau.coeff(t),tau.coeff(t-1),exp(0.5*z.coeff(t-1)));
      // observations
      model__+= normal_ld(y.coeff(t),tau.coeff(t),exp(0.5*x.coeff(t)));
    }

    // correct for non-trivial transformations
    model__+=targetIncrement(-Lz.LlogDet() -Lx.LlogDet() - Ltau.LlogDet());


    model__.generated(asDouble(z),"z");
    model__.generated(asDouble(x),"x");
    model__.generated(asDouble(tau),"tau");

    model__.generated(asDouble(latSD),"sigma");
    model__.generated(asDouble(lambda),"lambda_gen");

  }// operator()
};




