
#include "amt.hpp"

using namespace amt;

struct model{


  DATA_MATRIX(y);


  size_t n;
  size_t nele;
  size_t T;
  Eigen::VectorXd zeroVec;


  void preProcess(){
    n = y.cols();

    T = y.rows();
    nele = (n*(n+1))/2;
    zeroVec.resize(n);
    zeroVec.setZero();

  }

  template < class varType, class tensorType, bool storeNames>
  void operator()(amt::amtModel<varType,tensorType,storeNames> &model__){

    PARAMETER_MATRIX(Z,nele,T,0.0);
    PARAMETER_SCALAR(nu,250.0);



    std::vector<SPDmatrix<varType> > spds;
    spds.reserve(T);
    for(size_t i = 0;i<T;i++) spds.emplace_back(n,Z.col(i));


    model__ += normal_ld(nu,250.0,20.0);

    //model__+=wishartDiagScale_ld(spds[0],initDiag,20.0);
    model__+=multi_normal_prec_ld<double,double,varType>(y.row(0),zeroVec,spds[0]);

    for(size_t t=1;t<T;t++){
      model__+=wishartRW1_ld(spds[t],spds[t-1],nu);
      model__+=multi_normal_prec_ld<double,double,varType>(y.row(t),zeroVec,spds[t]);
    }

    //model__.generated(asDouble(nu),"nu");




  }// operator()
};

