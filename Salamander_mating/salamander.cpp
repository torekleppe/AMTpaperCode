
using namespace amt;

struct model{

  DATA_IVECTOR(y);

  DATA_VECTOR(fW);
  DATA_VECTOR(mW);
  DATA_VECTOR(WW);
  DATA_VECTOR(fall);

  DATA_IVECTOR(f1);
  DATA_IVECTOR(m1);
  DATA_IVECTOR(f2);
  DATA_IVECTOR(m2);

  Eigen::VectorXd wishartScale;
  Eigen::VectorXd zero2d;
  Eigen::MatrixXd fixedEff;

  void preProcess(){
    wishartScale.resize(2);
    wishartScale(0) = 1.0/1.244;
    wishartScale(1) = 1.0/1.244;
    zero2d.resize(2);
    zero2d.setZero();
    fixedEff.resize(fW.size(),5);
    fixedEff.col(0).setOnes();
    fixedEff.col(1) = fW;
    fixedEff.col(2) = mW;
    fixedEff.col(3) = WW;
    fixedEff.col(4) = fall;
  }

  template < class varType, class tensorType, bool storeNames>
  void operator()(amtModel<varType,tensorType,storeNames> &model__){

    PARAMETER_VECTOR(b3f,20);
    PARAMETER_VECTOR(b3m,20);

    PARAMETER_MATRIX(b1f_r,2,20);
    PARAMETER_MATRIX(b1m_r,2,20);



    PARAMETER_SCALAR(logKappaF);
    PARAMETER_SCALAR(logKappaM);
    PARAMETER_VECTOR(WFvals,3,0.0);
    PARAMETER_VECTOR(WMvals,3,0.0);

    PARAMETER_VECTOR(beta,5);


    SPDmatrix WF(2,WFvals);
    SPDmatrix WM(2,WMvals);



    //variance priors


    model__ += expGamma_ld(logKappaF,1.0,1.607717); //rate=0.622
    model__ += expGamma_ld(logKappaM,1.0,1.607717);

    varType kappaF_sd = exp(-0.5*logKappaF);
    varType kappaM_sd = exp(-0.5*logKappaM);

    model__ += wishartDiagScale_ld(WF,wishartScale,3.0);
    model__ += wishartDiagScale_ld(WM,wishartScale,3.0);

    // latents priors

    model__+= iid_multi_normal_prec_ld(b1f_r,zero2d,WF);
    model__+= iid_multi_normal_prec_ld(b1m_r,zero2d,WM);

    model__+= normal_ld(b3f,0.0,kappaF_sd);
    model__+= normal_ld(b3m,0.0,kappaM_sd);

    // fixed effects prior

    model__+= normal_ld(beta,0.0,100.0);

    // likelihood
    VectorXv eta;

    matVecProd(fixedEff,beta,eta);

    VectorXv b1f(40);
    VectorXv b1m(40);


    for( size_t i =0; i<20; i++){
      b1f.coeffRef(i) = b1f_r.coeff(0,i);
      b1f.coeffRef(i+20) = b1f_r.coeff(1,i);
      b1m.coeffRef(i) = b1m_r.coeff(0,i);
      b1m.coeffRef(i+20) = b1m_r.coeff(1,i);
    }
    model__.generated(asDouble(b1f),"b12f");
    model__.generated(asDouble(b1m),"b12m");



    for(std::size_t i = 0; i<240;i++){
    /*  eta.coeffRef(i) = beta.coeff(0) + beta.coeff(1)*fW.coeff(i) +
        beta.coeff(2)*mW.coeff(i) + beta.coeff(3)*WW.coeff(i) +
        beta.coeff(4)*fall.coeff(i) + b1f[f1[i]-1] + b1m[m1[i]-1];*/
      eta.coeffRef(i) += b1f[f1[i]-1] + b1m[m1[i]-1];
    }

    for(std::size_t i = 240;i<360;i++){
     /* eta.coeffRef(i) = beta.coeff(0) + beta.coeff(1)*fW.coeff(i) +
        beta.coeff(2)*mW.coeff(i) + beta.coeff(3)*WW.coeff(i) +
        beta.coeff(4)*fall.coeff(i) + b3f[f2[i-240]-1] + b3m[m2[i-240]-1];*/
      eta.coeffRef(i) += b3f[f2[i-240]-1] + b3m[m2[i-240]-1];
    }



    model__+=bernoulli_logit_lm(y,eta);

    // generated quantities

    model__.generated(std::exp(asDouble(logKappaF)),"kappaF");
    model__.generated(std::exp(asDouble(logKappaM)),"kappaM");

    model__.generated(WF,"WF");
    model__.generated(WM,"WM");

  }// operator()
};




