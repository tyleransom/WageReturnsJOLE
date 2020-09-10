#include "prok3_calc.h"
#include "prok3Input.h"
#include "prok3Output.h"
#include <math.h>
#include <vector>
#include <omp.h>
#include <string.h>
#include "cmatrix"
#include "prok3_aux.h"
#include "prok3_constrPerm.h"
#include "mainComp3.h"
#include "mainCompAux3.h"
#include "acceptValue3.h"
#include "allIter3.h"
#include "derivObs3.h"


typedef techsoft::matrix<double> Matrix;
typedef std::valarray<double> Vector;


void calculateProk3(const struct prok3Input* inputs, struct prok3Output* outputs)
{
   	
	std::vector<double> xxmat_aux; /*copying the regressors */
    std::copy(inputs->xxmat, inputs->xxmat + inputs->xxmat_size, std::back_inserter(xxmat_aux));
    //double * xxmat_aux = & xxmat_aux_m[0]; /* updating both draw-specific and non-draw specific missing variables */

    std::vector<double> one_over_sigma(inputs->d_sigma);
    std::vector<double> one_over_sigma_sq(inputs->d_sigma);
    std::vector<double> minus_half_one_over_sigma_sq(inputs->d_sigma);
    std::vector<double> one_over_sigma_cub(inputs->d_sigma);
    std::vector<double> log_one_over_sigma_abs_pi(inputs->d_sigma); 
	 //////mexPrintf("one_over_sigma_sq[0] is %f[0]\n",one_over_sigma_sq[0]);
    
    for(unsigned ii = 0; ii < inputs->d_sigma; ++ii) /* transformations of the variances for the idiosyncratic shocks */
    {
        double sigma_aux = inputs->sigma[ii]; 
        one_over_sigma[ii] = 1.0/sigma_aux;
        one_over_sigma_sq[ii] = one_over_sigma[ii]/sigma_aux;
        minus_half_one_over_sigma_sq[ii] = -0.5*one_over_sigma_sq[ii];
        one_over_sigma_cub[ii] = one_over_sigma_sq[ii]/sigma_aux;
        log_one_over_sigma_abs_pi[ii] = log(sqrt(1/(2*M_PI))*(1 / fabs(sigma_aux)));
    }
	double mNF=inputs->maxNumFa;
	double mNumFa1 = std::max(mNF,1.);
	unsigned mNumFa = mNumFa1;
	double mNFP=inputs->maxFPoints;
	double mFPoints1 = std::max(mNFP,1.);
	unsigned mFPoints = mFPoints1;
	double mNEP=inputs->maxEPoints;
	double mEPoints1 = std::max(mNEP,1.);
	unsigned mEPoints = mEPoints1;
	
	
	unsigned mapp = mNumFa*mFPoints;
	unsigned mapp1 = mapp*mEPoints;
	unsigned mapp2 = mEPoints*mFPoints;
	unsigned mapp3 = mEPoints*mNumFa;
		
	double facValues[mNumFa][mapp2]; /* values of the factors */
	memset(facValues, 0., sizeof(double) * mapp1);
	
	double facProb[mNumFa][mFPoints]; /* probabilities of the factors */
	memset(facProb, 0., sizeof(double) * mapp);
	
	int facGroup[mNumFa][mapp2]; /* identity of the subgroup of the factors */
	memset(facGroup, 0, sizeof(int) * mapp1);
	
	int facEva[mNumFa][mapp2]; /* identity of the evaluation point of the factors */
	memset(facEva, 0, sizeof(int) * mapp1);
	
	double facProbN[mNumFa][mapp2]; /* probabilities of the factors - numerator */
	memset(facProbN, 0., sizeof(double) * mapp1);
	
	double facProbN1[mNumFa][mFPoints]; /* probabilities of the  - numerator auxilary */
	memset(facProbN1, 0., sizeof(double) * mapp);
	
	double facProbD = 0.; /* probabilities of the factors - log of denominator (sum) */
	
	std::vector<unsigned> tmat(mNumFa,0);
	tmat[0]=1;

		
	for(unsigned ds=0;ds<inputs->maxNumFa;++ds) /* getting values and probabilities for discrete factors */
	{
		tmat[ds] = inputs->fmat[ds]*inputs->feva[ds];
		//mexPrintf("inputs->ftyp[%d] is %d\n\n",ds,inputs->ftyp[ds]);
		
		if(inputs->ftyp[ds]==2 || inputs->ftyp[ds]==4){
			unsigned pa = inputs->fmat[ds]-1;
			
			std::vector<double> lin_proj_pr(pa);
			std::vector<double> exp_lin_proj_pr(pa);
			double denom = 1.;
			double maxexp = inputs->probMin; /* highest value to solve the infinity issue */
			
			for(unsigned qs=0;qs<pa;++qs) /* looping over points */
			{
				lin_proj_pr[qs] = inputs->omega[inputs->indFirCoefWgts[ds]+qs];
				facProbN1[ds][qs] = lin_proj_pr[qs];
				maxexp = std::max(maxexp,lin_proj_pr[qs]);
				exp_lin_proj_pr[qs] = exp(lin_proj_pr[qs]);
				denom += exp_lin_proj_pr[qs];
			}
			
			if (maxexp>=inputs->auxInf) {  /* making sure there is no plus infinity */
				double auxInf_adj = inputs->auxInf - maxexp; /*adjustment addend */
				denom = exp(auxInf_adj);
								
				for(unsigned qss=0;qss<pa;++qss) /* looping over points */
				{
					lin_proj_pr[qss] += auxInf_adj;
					facProbN1[ds][qss] = lin_proj_pr[qss];
					exp_lin_proj_pr[qss] = exp(lin_proj_pr[qss]);          
					denom += exp_lin_proj_pr[qss];        
				}
			}
			
			facProbD += log(denom);
			
			for(unsigned qas=0;qas<pa;++qas) /* looping over points */
			{
				facProb[ds][qas] = exp_lin_proj_pr[qas]/denom;
			}
			
			facProb[ds][pa] = 1/denom;
	   
			if(inputs->ftyp[ds]==2){
			
				facValues[ds][0]=-0.5;
				
				for(unsigned qs1=0;qs1<pa;++qs1) /* looping over points */
				{
					facProbN[ds][qs1]=facProbN1[ds][qs1];
					facGroup[ds][qs1]=qs1;
					
					if (qs1>0) {
					
						double denoro=1.;
						double kal1 = inputs->ksi[inputs->indFirCoefPts[ds]+qs1-1];
						
						if (kal1>=inputs->auxInf) {
							double auxInf_adj1 = inputs->auxInf - kal1; /*adjustment addend */
							kal1 += auxInf_adj1;
							denoro = exp(auxInf_adj1);
						}
						
						double kal = exp(kal1);
						facValues[ds][qs1] = kal/(denoro+kal)-0.5;
					}
				}
				
				facValues[ds][pa] = 0.5;
				facGroup[ds][pa]=pa;
				//////mexPrintf("facGroup1[%d][%d] is %d\n",ds,inputs->fmat[ds],facGroup[ds][inputs->fmat[ds]]);
				
			} else {
				
				unsigned zq=inputs->indFirWgts[ds];
				unsigned kq=inputs->indFirCoefMns[ds];
				unsigned rq=inputs->indFirCoefVars[ds];
				for(unsigned qs2=0;qs2<inputs->fmat[ds];++qs2) /* looping over points */
				{
					unsigned xq = qs2*inputs->feva[ds];
					for(unsigned as2=0;as2<inputs->feva[ds];++as2) /* looping over points */
					{
						facProbN[ds][xq+as2]=facProbN1[ds][qs2]+log(inputs->hhmat[zq+as2]);
						facValues[ds][xq+as2]=inputs->meanz[kq+qs2]+inputs->ggmat[zq+as2]*inputs->varz[rq+qs2];
						facGroup[ds][xq+as2]=qs2;
						facEva[ds][xq+as2]=as2;
					}
				}
			}
			
		} else {
			
			unsigned zq1=inputs->indFirWgts[ds];
			unsigned kq1=inputs->indFirCoefMns[ds];
			unsigned rq1=inputs->indFirCoefVars[ds];

			for(unsigned as3=0;as3<inputs->feva[ds];++as3) /* looping over points */
			{
				facProbN[ds][as3]=log(inputs->hhmat[zq1+as3]);
				facEva[ds][as3]=as3;
				
				if(inputs->ftyp[ds]==3){
				
					facValues[ds][as3]=inputs->meanz[kq1]+inputs->ggmat[zq1+as3]*inputs->varz[rq1];
					
					// ////mexPrintf("facEva[%d][%d] is %d\n",ds,as3,facEva[ds][as3]);
					// ////mexPrintf("facGroup[%d][%d] is %d\n",ds,as3,facGroup[ds][as3]);
					// ////mexPrintf("facValues[%d][%d] is %f\n\n",ds,as3,facValues[ds][as3]);
				
				} else {
				
					facValues[ds][as3]=inputs->ggmat[zq1+as3];
				
				}
			}
		}
	}
	
	// if (inputs->maxNumFa<1){
		
		// facValues[0][0]=0.;
		// facProb[0][0]=1.;
		// facProbN[0][0]=0.;
	// }

	#pragma omp parallel for //num_threads(1) 
    /* #pragma omp for ordered // num_threads(2) */
    
    for(int n = inputs->NA; n<inputs->NB; ++n) /* looping over individuals */
    {
					 
					 /*Auxiliary objects */
         std::vector<double> aux_obs_iter(inputs->SVarOut); /* vector for derivatives of param. for observables - for one draw */
         std::vector<double> aux_obs_cum(inputs->SVarOut,0.0); /* vector for derivatives of param. for observables - cummulative */
		 std::vector<double> aux_obs_iter_all(inputs->d_beta); /* vector for derivatives of param. for observables - for one draw, missing regressors functions of the factors */
         std::vector<double> aux_obs_cum_all(inputs->d_beta,0.0); /* vector for derivatives of param. for observables - cummulative, all regressors */
		 
		 std::vector<unsigned> aux_obs_iter_all_ind(inputs->d_beta); /* vector for derivatives of param. for observables - for one draw, missing regressors functions of the factors, indicator if visited when multiplying */
         std::vector<unsigned> aux_obs_cum_all_ind(inputs->d_beta,0); /* vector for derivatives of param. for observables - cummulative, all regressors, indicator if visited when multiplying */
         
         std::vector<double> aux_unobs_iter(inputs->d_alpha); /* vector for derivatives of param. for unobservables - for one draw */
         std::vector<double> aux_unobs_cum(inputs->d_alpha,0.0); /* vector for derivatives of param. for unobservables - cummulative */
        
         std::vector<double> aux_ids_iter(inputs->d_sigma); /* vector for derivatives of param. for variances of idiosyncratic shocks - for one draw */
         std::vector<double> aux_ids_cum(inputs->d_sigma,0.0); /* vector for derivatives of param. for variances of idiosyncratic shocks - cummulative */
		 
         std::vector<double> aux_wts_cum(inputs->numTPoints,0.0); /* vector for derivatives of param. for weights of discrete factors - cummulative, auxilary */
		 std::vector<double> aux_wts_cum_f(inputs->d_omega,0.0); /* vector for derivatives of param. for weights of discrete factors - cummulative */
		 
		 std::vector<double> aux_pts_iter(inputs->numTPoints); /* vector for derivatives of param. for points of discrete factors - for one draw */
         std::vector<double> aux_pts_cum(inputs->numTPoints,0.0); /* vector for derivatives of param. for points of idiosyncratic shocks - cummulative, auxilary */
		 std::vector<double> aux_pts_cum_f(inputs->d_ksi,0.0); /* vector for derivatives of param. for points of idiosyncratic shocks - cummulative */
		 
		 std::vector<double> aux_mean_iter(inputs->d_mean); /* vector for derivatives of param. for means of normally distrib. factors or mixture - for one draw */
         std::vector<double> aux_mean_cum(inputs->d_mean,0.0); /* vector for derivatives of param. for means of normally distrib. factors or mixture - cummulative, auxilary */
		 
		 std::vector<double> aux_var_iter(inputs->d_var); /* vector for derivatives of param. for variances of normally distrib. factors or mixture - for one draw */
         std::vector<double> aux_var_cum(inputs->d_var,0.0); /* vector for derivatives of param. for variances of normally distrib. factors or mixture - cummulative, auxilary */
    
		 std::vector<double> aux_obs_lin_it(inputs->SVarOut); /* vector with linear projections of the observables - iteration specific */
		 std::vector<double> aux_obs_lin(inputs->SVarOut,0.0); /* vector with linear projections of the observables */
		 
		 std::vector<double> aux_cont_iter(inputs->xxmat_size); /* vector with the variable part of the missing regressor - iteration specific */
		 std::vector<double> aux_cont_it_mult(inputs->SVarOut); /* vector with the variable part of the missing regressor - iteration specific, multiplied when regressor */
		 
        
		double ind_lik = 0.; /* likelihood for the particular individual */
        double adj_add = 0.; /*adjustment addend ensuring no log of 0 */
        double adj_mul = 1.; /*adjustment multiplier ensuring no log of 0 */
        double max_prob_ind = inputs->probMinMin; /* maximum value the log(ind_lik) has taken in the previous draws */
        

		/* some parameters for the dimensions of the objects related to the covariance groups */
		unsigned ing0 = inputs->NG[n];
		unsigned imeg0 = inputs->MEG[n];
		unsigned imfg0 = inputs->MFG[n];
		unsigned ikg0 = inputs->KG[n];
		unsigned imrg0 = inputs->MRG[n];
		
		unsigned inmg0 = ing0*imeg0;
		unsigned inmgf0 = inmg0*imfg0;
		unsigned inmgfr0 = inmgf0*imrg0;
		unsigned inmgfrk0 = inmgfr0*ikg0;
		
		Matrix AderAux[ing0]; /* matrix of derivatives for covariances - auxiliary - aggregate */
		
		Matrix AderAuxT[ing0]; /* matrix of derivatives for covariances - auxiliary - aggregate */
		Matrix AEpsi[ing0]; /* matrix with residuals */
        
		Matrix ALambda[ing0]; /* factor loading matrix */
		
		int LambdaN[ing0][imrg0][imeg0][imfg0]; /* number of paramters in each factor loading */
		memset(LambdaN, 0, sizeof(int) * inmgfr0);
		int LambdaP[ing0][imrg0][imeg0][imfg0][ikg0]; /* location of parameters in each factor loading */
		memset(LambdaP, 0, sizeof(int) * inmgfrk0);
		
		int LambdaL[ing0][imeg0]; /*number of non-zero columns for that row */
		memset(LambdaL, 0, sizeof(int) * inmg0);
		int LambdaI[ing0][imeg0][imfg0]; /*identity of non-zero columns for that row */
		memset(LambdaI, 0, sizeof(int) * inmgf0);
		
		double BLambda[ing0][imrg0][imeg0][imfg0]; /* separate matrices for covariance */
		memset(BLambda, 0., sizeof(double) * inmgfr0);
		int LambdaR[ing0][imeg0][imfg0]; /* number of separate matrices for covariance */
		memset(LambdaR, 0, sizeof(int) * inmgf0);
		
		Matrix APsi[ing0];
		int PsiP[ing0][imeg0];/* location of the variance */
		memset(PsiP, 0, sizeof(int) * inmg0);
		int PsiU[ing0][imeg0];/* unique id of the variable */
		memset(PsiU, 0, sizeof(int) * inmg0);
		
		Matrix ASigmaM[ing0]; /* covariance matrix */
		double DSigmaM[ing0]; /* vector of residuals for the covariance matrix */
		
		for(size_t rs=0;rs<ing0;++rs) /* setting the size of the matrices */
		{
			unsigned naux = n+inputs->N*rs;
			unsigned neqg = inputs->numEqG[naux];
			unsigned nfacg = inputs->numFacG[naux];
			ALambda[rs].resize(neqg,nfacg);
			APsi[rs].resize(neqg,neqg);
			ASigmaM[rs].resize(neqg,neqg);
			AderAux[rs].resize(neqg,nfacg);
			AderAuxT[rs].resize(neqg,nfacg);
			AEpsi[rs].resize(neqg,1);
			
		}
		
		unsigned Vt = inputs->varPerIndividual[n]; /*number of variables for a particular indivudual */
        unsigned Vt_index = inputs->rowVarIndex[n]; /* index showing where the data for Vt starts in the descrption of data for n */
		
        for(unsigned vk=0;vk<Vt;++vk) /* looping over the variables to construct linear projections for observables and form covariance matrices*/
        {
            unsigned v_index0 = Vt_index+vk; /* variable index */
			variableMainAttr vMA0 (inputs, v_index0);
			if (vMA0.type<6)
			{ /* for continuous outcome variables */                     
				
				if (vMA0.miss){ /*constructing residuals for non-missing continous variables */
					
					constructResidual(inputs, vMA0, aux_obs_lin, xxmat_aux);
					
					if (vMA0.type==2) /* filling elements of the covariance matrices - from the side of the non-missing variable*/
					{
						unsigned ifv0 = inputs->indFirCoefIds[vMA0.ivar];  /*index first param. - variances */
						variableCovAttr covAttr0 (inputs, vMA0.vdata, vMA0.ivar);
						Matrix& Psi = APsi[covAttr0.covId];
						Psi[covAttr0.auxCov][covAttr0.auxCov] = inputs->sigma[ifv0]*inputs->sigma[ifv0];
						PsiP[covAttr0.covId][covAttr0.auxCov]=ifv0;
						PsiU[covAttr0.covId][covAttr0.auxCov]=vMA0.uid;
					}
					
				} else{
					constructPermMissCont(inputs, vMA0,xxmat_aux); /* filling the observed part of the missing variables */
					
					if (vMA0.type==2) /* fiiling elements of the covariance matrices - from the side of the missing variable*/
					{
						variableCovAttr covAttr0 (inputs, vMA0.vdata, vMA0.ivar);
						unsigned ifv0 = inputs->indFirCoefIds[vMA0.ivar];  /*index first param. - variances */
						std::vector<double> multipkA(ikg0,0.); /* product of parameters for factor loadings */
						std::vector<unsigned> ivarA(ikg0); /* indentity of missing regressors */
						std::vector<unsigned> vdataA(ikg0); /* location of missing regressors */	
						std::vector<unsigned> ninkA(ikg0,0); /* number missing regressors per level - counter*/
						std::vector<unsigned> regLocA(ikg0,0); /* location of the parameters in the opt routine */
					
						unsigned boutA = 1; /*counter for multipk */
						ivarA[0] = vMA0.ivar; /* initializing identity of missing variable in the chain */
						vdataA[0] = vMA0.vdata; /* initializing data storage info */
						regLocA[0] = ifv0; /* registering the location of the variance of the idiosyncratic shock */
						multipkA[0] = inputs->sigma[ifv0]; 
					
						while (boutA>0)
						{
							unsigned boutAM1 = boutA - 1;
							unsigned noinA = variableNInclAttr (inputs, vdataA[boutAM1], ivarA[boutAM1]); /* number of outcomes in which the variable is included at this level */
							unsigned ninA = ninkA[boutAM1]; /* counter of variables at this level of missingness */
							ninkA[boutAM1] = ninA+1;
					
							if (ninkA[boutAM1]>noinA) /* going back to previous level */
							{
								boutA--;
						
							} else{
								variableInclVAttrPlus inclVarA(inputs, vdataA[boutAM1],ivarA[boutAM1],ninA);
								multipkA[boutA] = multipkA[boutAM1]*inputs->beta[inclVarA.index_coef]*inputs->xxmat[inclVarA.index_regr];
								regLocA[boutA] = inclVarA.index_coef; /*registering the location of the parameter */
							
								if (!inclVarA.miss) /* another level */
								{
									ivarA[boutA] = inclVarA.ivar;
									vdataA[boutA] = inclVarA.vdata;
									ninkA[boutA] = 0;
									boutA++; /* searching for non-missing variable */
							
								} else {
									
									variableCovAttr covAttrA (inputs, inclVarA.vdata, inclVarA.ivar);
									Matrix& Lambda = ALambda[covAttr0.covId];
									Lambda[covAttrA.auxCov][covAttr0.auxCov] += multipkA[boutA]; /*factor loading matrix */
									unsigned nrg =  LambdaR[covAttr0.covId][covAttrA.auxCov][covAttr0.auxCov]; /*number separate matrices so far */
									LambdaR[covAttr0.covId][covAttrA.auxCov][covAttr0.auxCov]++;
									BLambda[covAttr0.covId][nrg][covAttrA.auxCov][covAttr0.auxCov] = multipkA[boutA];
									unsigned boutAP =  boutA+1; /*index */
									LambdaN[covAttr0.covId][nrg][covAttrA.auxCov][covAttr0.auxCov] = boutAP; /*number of levels for that factor loading */
								
									for(unsigned ts=0;ts<boutAP;++ts) /* looping over the number of levels*/
									{
										LambdaP[covAttr0.covId][nrg][covAttrA.auxCov][covAttr0.auxCov][ts] = regLocA[ts]; /* storing the identity of the coeffiecents */
									}
								
									if (nrg<1)
									{
										LambdaI[covAttr0.covId][covAttrA.auxCov][LambdaL[covAttr0.covId][covAttrA.auxCov]] = covAttr0.auxCov; /*identity of non-zero columns for that row */
										LambdaL[covAttr0.covId][covAttrA.auxCov]++; /*number of non-zero columns for that row */
									}
									
								}
							
							}
					
						}					
					
					}
					
				}	
				
			} else {
			
				constructPermMissDisc(inputs, vMA0, aux_obs_lin, xxmat_aux);		
            }
			
        }
		
		for(size_t gs=0;gs<ing0;++gs) /*looping over covariance groups */
		{
			Matrix& Lambda = ALambda[gs];
			Matrix& Psi = APsi[gs];
			Matrix LambdaT =~ Lambda;
			ASigmaM[gs] = Lambda*LambdaT;
			ASigmaM[gs] += Psi;
			DSigmaM[gs] = ASigmaM[gs].det();
			ASigmaM[gs].inv();
		}
		
		std::vector<unsigned> zink(mNumFa,0); /* number of points already taken into consideration*/
		std::vector<unsigned> bink(mNumFa,0); /* id of the points in the discrete factors with which we work*/
		std::vector<unsigned> gink(mNumFa,0); /* id of the subgroup in the discrete factors with which we work*/
		std::vector<unsigned> eink(mNumFa,0); /* id of the valuation point with which we work*/
		std::vector<double> rmat(mNumFa,0.); /* factor values in a draw*/
		unsigned gdp =  mNumFa+1;
		std::vector<double> sum_log_probN(gdp,0.); /* sum of log weights so far*/
		unsigned zout=1;
		
		while (zout>0)
		{
			unsigned zoutM1 = zout - 1; /*id of the factor */
			unsigned zoin = tmat[zoutM1]; /* number of points the discrete factor has */
			//mexPrintf("zoin is %d\n",zoin);
			unsigned zin = zink[zoutM1]; /* counter of points for this factor already visited*/
			zink[zoutM1] = zin+1;
			bink[zoutM1] = zin;
			
					
			if (zink[zoutM1]>zoin) /* going back to previous level */
			{
				zout--;
							
			} else if (zoutM1<mNumFa){
				// ////mexPrintf("facGroup[%d][%d] is %d\n",zoutM1,zin,facGroup[zoutM1][zin]);
				gink[zoutM1] = facGroup[zoutM1][zin];
				eink[zoutM1] = facEva[zoutM1][zin];
				//mexPrintf("zoutM1 is %d\n",zoutM1);
				//mexPrintf("zin is %d\n",zin);
				//mexPrintf("bink[zoutM1] is %d\n",bink[zoutM1]);
				//mexPrintf("gink[zoutM1] is %d\n",gink[zoutM1]);
				//mexPrintf("eink[zoutM1] is %d\n",eink[zoutM1]);
				rmat[zoutM1]= facValues[zoutM1][zin];
				//mexPrintf("rmat[%d] is %f\n",zoutM1,rmat[zoutM1]);
				sum_log_probN[zout] = sum_log_probN[zoutM1] + facProbN[zoutM1][zin]; /*make sure no log of zero */
				////mexPrintf("facProbN[%d][%d] is %f\n",zoutM1,zin,facProbN[zoutM1][zin]);
				////mexPrintf("sum_log_probN[%d] is %f\n\n",zout,sum_log_probN[zout]);
				
				if (zout<mNumFa){

				
					zink[zout] = 0;
					zout++;
					
				} else {
					
					
					
					unsigned r_drawn = 0; /* start of generated variables for the person in this draw */ 
					
					double sum_log_num_disc = sum_log_probN[zout]; /*sum of the logs of the numerators of the likelihoods for discrete outcomes*/ 
					double sum_log_den_disc = facProbD; /* sum of the logs of the denominators of the likelihoods for discrete outcomes*/
					double sum_log_cont_mp = 0.; /* main part of log of prob of cont. variables */
					double sum_log_cont_ap = 0.; /* additional part of log of prob of cont. variables */
					
					aux_obs_lin_it=aux_obs_lin; /* initializing */

					
					/* Initializing the iteration-specific auxiliary objects */
					std::fill(aux_unobs_iter.begin(), aux_unobs_iter.end(), 0.0);
					std::fill(aux_obs_iter.begin(), aux_obs_iter.end(), 0.0);
					std::fill(aux_obs_iter_all.begin(), aux_obs_iter_all.end(), 0.0);
					std::fill(aux_obs_iter_all_ind.begin(), aux_obs_iter_all_ind.end(), 0.0);
					std::fill(aux_ids_iter.begin(), aux_ids_iter.end(), 0.0);
					std::fill(aux_pts_iter.begin(), aux_pts_iter.end(), 0.0);
					std::fill(aux_mean_iter.begin(), aux_mean_iter.end(), 0.0);
					std::fill(aux_var_iter.begin(), aux_var_iter.end(), 0.0);
					std::fill(aux_cont_iter.begin(), aux_cont_iter.end(), 0.0);
					std::fill(aux_cont_it_mult.begin(), aux_cont_it_mult.end(), 0.0);
					
					
							
					for(size_t js=0;js<ing0;++js) /*initializing */
					{
						AEpsi[js].null();
						AderAuxT[js].null();
					}
					
					for(unsigned vv=0; vv<Vt; ++vv) /*looping over variables */
					{
						unsigned v_index1 = Vt_index+vv; /* variable index */
						variableMainAttr vMA1 (inputs, v_index1);
						unsigned nmrd1 = variableNIterVAttr (inputs, vMA1.vdata,vMA1.ivar);
						
						if (vMA1.type==6) {    /* discrete outcome variable */    
							conmpDisc(inputs, vMA1, aux_obs_lin_it,xxmat_aux, rmat,r_drawn,sum_log_num_disc,sum_log_den_disc,aux_obs_iter,aux_unobs_iter,aux_pts_iter,aux_mean_iter,aux_var_iter,aux_obs_iter_all,aux_cont_iter,bink,gink,eink);	
								
						} else{ /* continous outcomes */
							
							if (vMA1.miss)
							{
								double aux_cont = constructResidualIter(inputs,vMA1,aux_obs_lin_it,rmat,r_drawn);
								
								if (vMA1.type==5)
								{
									unsigned ifv1 = inputs->indFirCoefIds[vMA1.ivar];  /*index first param. - variances */
									double aux_cont_der = aux_cont*one_over_sigma_sq[ifv1];
									aux_obs_iter[vMA1.uid] += aux_cont_der; /* observables */
									double aux_cont_sq = aux_cont*aux_cont;
									aux_ids_iter[ifv1] += aux_cont_sq * one_over_sigma_cub[ifv1] - one_over_sigma[ifv1]; 
									sum_log_cont_mp +=aux_cont_sq * minus_half_one_over_sigma_sq[ifv1];
									sum_log_cont_ap += log_one_over_sigma_abs_pi[ifv1];
									
								} else {
									variableCovAttr covAttr1 (inputs, vMA1.vdata, vMA1.ivar);
									Matrix& Epsi = AEpsi[covAttr1.covId];
									Epsi[covAttr1.auxCov][0]=aux_cont;
								}
								
							} else if ((!vMA1.miss) && (vMA1.nfac>0 || nmrd1>0 || vMA1.type==1)){ /* iteration-specific parts */
								constructIterMissCont(inputs,vMA1,aux_obs_lin_it,rmat,r_drawn, aux_cont_it_mult,aux_cont_iter);
								
							}						
						
						}
						
					}
					

					for(size_t zs=0;zs<ing0;++zs) /*looping over covariance groups */
					{
						unsigned IV = inputs->numEqG[n+inputs->N*zs];
						Matrix& Lambda = ALambda[zs];
						Matrix& Epsi = AEpsi[zs];
						Matrix& SigmaM = ASigmaM[zs];
					
						Matrix WWA = SigmaM*Epsi;
						Matrix EpsiT =~ Epsi;
						Matrix EW = WWA*EpsiT;
						Matrix EWE = EW*SigmaM;
						
						double trEW = EW.trace();
						sum_log_cont_mp -= trEW/2;
						sum_log_cont_ap -= (IV*log(2*M_PI)+log(DSigmaM[zs]))/2;
				
						Matrix derAux1 = EWE - SigmaM;
						double ds = 0.5;
						derAux1 *= ds; /*from overall derivative formula for covariance */
						derAux1 *= 2; /* derivative of the factor loading matrix */
					
						AderAuxT[zs] = derAux1*Lambda; 
						
						
						for(size_t iv=0; iv<IV; ++iv) /*looping over rows */
						{		
							double derivId = derAux1[iv][iv]; /*needed part of the derivative for the cov. matrix */
							unsigned ifvP = PsiP[zs][iv];
							aux_ids_iter[ifvP] += derivId*inputs->sigma[ifvP]; /* non-missing variance derivative */
							size_t psiuv=PsiU[zs][iv];
							aux_obs_iter[psiuv] += WWA[iv][0];
						}	
						
					}
						
				
					
					/* derivatives factor loadings when missing variable */
					
					for(unsigned vv4=0; vv4<Vt; ++vv4) /*looping over variables */
					{
						unsigned v_index2 = Vt_index+vv4; /* variable index */
						variableMainAttr vMA2 (inputs, v_index2);
						conmpAux(inputs, vMA2,aux_ids_iter,rmat,r_drawn,aux_obs_iter, aux_unobs_iter,aux_pts_iter,aux_mean_iter,aux_var_iter,aux_obs_iter_all, aux_cont_iter, ikg0,bink,gink,eink);				
					}        
			
					
					double aux_no_zero_1 = sum_log_num_disc - sum_log_den_disc + sum_log_cont_mp + sum_log_cont_ap;
					double lik_iter = 0.0; /*likelihood for the iteration */
					noLogZero(inputs,adj_add,adj_mul,lik_iter,aux_no_zero_1,max_prob_ind);
					/*////mexPrintf("adj_mul is %f\n",adj_mul); */
					
					/* Multiplying the derivatives with the likelihood */
					for(unsigned vv2=0; vv2<Vt; ++vv2) /*looping over variables */
					{
						unsigned v_index3 = Vt_index+vv2; /* variable index */
						variableMainAttr vMA3 (inputs, v_index3);
						correctDerivObs(inputs, vMA3,adj_mul,lik_iter,aux_obs_cum,aux_obs_iter,aux_obs_iter_all_ind,aux_obs_cum_all, aux_obs_iter_all);
						  
					}                                       
					
					for(unsigned cc2=0; cc2<inputs->d_alpha; ++cc2) /*looping over unobservable variables */
					{
						aux_unobs_cum[cc2] *= adj_mul;
						aux_unobs_cum[cc2] += lik_iter*aux_unobs_iter[cc2];
					}
						
					for(unsigned dd2=0; dd2<inputs->d_sigma; ++dd2) /*looping over variables - idiosyncratic variances */
					{
						aux_ids_cum[dd2] *= adj_mul;
						aux_ids_cum[dd2] += lik_iter*aux_ids_iter[dd2];
					}
					
					
					for(unsigned dda=0; dda<inputs->numTPoints; ++dda) /*looping over points = discrete factors */
					{
						aux_pts_cum[dda] *= adj_mul;
						aux_pts_cum[dda] += lik_iter*aux_pts_iter[dda];
						//mexPrintf("aux_pts_cum[dda] %d is %f\n",dda, aux_pts_cum[dda]);
						
					}
					
					for(unsigned ddg=0; ddg<inputs->d_mean; ++ddg) /*looping over points = discrete factors */
					{
						aux_mean_cum[ddg] *= adj_mul;
						aux_mean_cum[ddg] += lik_iter*aux_mean_iter[ddg];
					}
					
					for(unsigned ddh=0; ddh<inputs->d_var; ++ddh) /*looping over points = discrete factors */
					{
						aux_var_cum[ddh] *= adj_mul;
						aux_var_cum[ddh] += lik_iter*aux_var_iter[ddh];
					}
					
					for(unsigned ddb=0; ddb<inputs->numTPoints; ++ddb) /*looping over points = discrete factors */
					{
						aux_wts_cum[ddb] *= adj_mul;

					}
					
					for(unsigned om=0; om<inputs->maxNumFa; ++om) /*looping over factors */
					{
						if (inputs->ftyp[om]==2 || inputs->ftyp[om]==4){
							// ////mexPrintf("bink[om] is %d\n",bink[om]);
							// ////mexPrintf("gink[om] is %d\n",gink[om]);
							aux_wts_cum[inputs->indFirPts[om]+gink[om]] += lik_iter;
						}
					}
					
					for(size_t ys=0;ys<ing0;++ys) /*looping over covariance groups */
					{	
						AderAux[ys] *= adj_mul;
						AderAux[ys] += lik_iter*AderAuxT[ys];
					}
						
					/*the likelihood */
					ind_lik *= adj_mul;
					ind_lik += lik_iter; 
					
				}
			}
		}
         
  
		
           

		
		
        double one_over_ind_lik = 1/ind_lik;

		                /* Multiplying the derivatives with the likelihood for the observables with miss regressors with a variable part */
											
		for(unsigned vv2a=0; vv2a<Vt; ++vv2a) /*looping over variables - multiplying only singular derivatives for the observables */
        {
            unsigned v_index4 = Vt_index+vv2a; /* variable index */
			variableMainAttr vMA4 (inputs, v_index4);
			multDerivObsIter(inputs,vMA4,one_over_ind_lik,aux_obs_cum_all_ind, aux_obs_cum_all);    
        }
        
				/* derivatives of the covariance matrix */
		for(size_t xs=0;xs<ing0;++xs) /*looping over covariance groups */
		{		
			Matrix& derAux = AderAux[xs];
			//Matrix& LambdaA = ALambda[xs];
			
			unsigned IP = inputs->numEqG[n+inputs->N*xs];
			for(size_t ip=0; ip<IP; ++ip) /*looping over rows */
			{
				unsigned lxic = LambdaL[xs][ip]; /*non-zeros columns */
				for(unsigned cv=0; cv<lxic; ++cv) /*looping over non-zero columns */
				{
					size_t lipcv = LambdaI[xs][ip][cv]; /* id of the column */
					size_t ripcv = LambdaR[xs][ip][lipcv]; /* number of products in this cell */
					
					for(size_t ipr=0; ipr<ripcv; ++ipr) /* looping over number of products */
					{
						double coeff = BLambda[xs][ipr][ip][lipcv]; /* the factor loading */
						unsigned ncoeff = LambdaN[xs][ipr][ip][lipcv]; /* number of levels */
						double deriv = derAux[ip][lipcv]; /* derivative matrix component */
						double one_over_sigma = 1/inputs->sigma[LambdaP[xs][ipr][ip][lipcv][0]];
						aux_ids_cum[LambdaP[xs][ipr][ip][lipcv][0]] += deriv*coeff*one_over_sigma; /* variance of the missing idiosyncratic shock */
					
						for(size_t kv=1; kv<ncoeff; ++kv) /*looping over levels */
						{
							double one_over_beta = 1/inputs->beta[LambdaP[xs][ipr][ip][lipcv][kv]];
							aux_obs_cum_all[LambdaP[xs][ipr][ip][lipcv][kv]] += deriv*coeff*one_over_beta*one_over_ind_lik; /* coefficient in front of the missing variable */
						}
					
					}
				
				}
			
			}

		}		
		
        /* getting the derivatives for the observables and dividing the outputs to get the loglikelihood and its derivatives */
       
		for(unsigned vv3=0; vv3<Vt; ++vv3) /*looping over variables */
        {
            unsigned v_index5 = Vt_index+vv3; /* variable index */
			variableMainAttr vMA5 (inputs, v_index5);
			derivObsAux(inputs,vMA5,one_over_ind_lik,aux_obs_cum,aux_obs_cum_all,xxmat_aux,ikg0);
        }        
				
        for(unsigned cc3=0; cc3<inputs->d_alpha; ++cc3) /*looping over unobservables indexed */
        {
          aux_unobs_cum[cc3] *= one_over_ind_lik;
        }
		
		for(unsigned cca=0; cca<inputs->numTPoints; ++cca) /*looping over points of discrete factors */
        {
          aux_pts_cum[cca] *= one_over_ind_lik;
		  //mexPrintf("aux_pts_cum1[cca] %d is %f\n",cca, aux_pts_cum[cca]);
        }
		
		for(unsigned ccg=0; ccg<inputs->d_mean; ++ccg) /*looping over points of discrete factors */
        {
          aux_mean_cum[ccg] *= one_over_ind_lik;
        }
		
		for(unsigned cch=0; cch<inputs->d_var; ++cch) /*looping over points of discrete factors */
        {
          aux_var_cum[cch] *= one_over_ind_lik;
        }
                    
        for(unsigned ccb=0; ccb<inputs->numTPoints; ++ccb) /*looping over weights of discrete factors */
        {
          aux_wts_cum[ccb] *= one_over_ind_lik;
        }
		
		for(unsigned dd3=0; dd3<inputs->d_sigma; ++dd3) /*looping over idiosyncratic variable variances  */
        {
            aux_ids_cum[dd3] *= one_over_ind_lik;
        }
		
		for(unsigned vs=0;vs<inputs->maxNumFa;++vs) /* getting values and probabilities for discrete factors */
		{
			unsigned va = inputs->fmat[vs]-1;
			
			if(inputs->ftyp[vs]==2 || inputs->ftyp[vs]==4){
				
				for(unsigned qv=0;qv<inputs->fmat[vs];++qv) /* looping over points */
				{
					for(unsigned qva=0;qva<va;++qva) /* looping over parameters for probabilities */
					{
						if (qva==qv) {
							aux_wts_cum_f[inputs->indFirCoefWgts[vs]+qva] += aux_wts_cum[inputs->indFirPts[vs]+qv]*(1-facProb[vs][qva]);
						} else {
							aux_wts_cum_f[inputs->indFirCoefWgts[vs]+qva] -= aux_wts_cum[inputs->indFirPts[vs]+qv]*facProb[vs][qva];
						}
					}
				}
			
			}
			if (inputs->ftyp[vs]==2 && va>1) {
			
				for(unsigned qvq=1;qvq<va;++qvq) /* looping over points */
				{
					aux_pts_cum_f[inputs->indFirCoefPts[vs]+qvq-1] = aux_pts_cum[inputs->indFirPts[vs]+qvq]*(0.5-facValues[vs][qvq])*(0.5+facValues[vs][qvq]);
					//mexPrintf("aux_pts_cum_f[%d] is %f\n",inputs->indFirCoefPts[vs]+qvq-1, aux_pts_cum_f[inputs->indFirCoefPts[vs]+qvq-1]);
				}
			}
		
		}
                    
                    /*the likelihood */
        double log_ind_lik=log(ind_lik) - adj_add;

 		/*Execute the final stage of the reduction code serially. */
 		#pragma omp critical (reduction_code) 
 		{	
			outputs->logl[0] +=  log_ind_lik; /* add overall probabilities across people */
			
            for(unsigned ir = 0; ir < aux_obs_cum_all.size(); ++ir)
			{
				outputs->matrix_obs[ir] += aux_obs_cum_all[ir];
			}
			
            for(unsigned irr = 0; irr < aux_unobs_cum.size(); ++irr)
			{
				outputs->matrix_unobs[irr] += aux_unobs_cum[irr];
			}

            for(unsigned irrr = 0; irrr < aux_ids_cum.size(); ++irrr)
			{
				outputs->matrix_ids[irrr] += aux_ids_cum[irrr];
			}
			
			for(unsigned irrrr = 0; irrrr < aux_pts_cum_f.size(); ++irrrr)
			{
				outputs->matrix_pts[irrrr] += aux_pts_cum_f[irrrr];
			}
			for(unsigned irrrrr = 0; irrrrr < aux_wts_cum_f.size(); ++irrrrr)
			{
				outputs->matrix_wts[irrrrr] += aux_wts_cum_f[irrrrr];
			}
			
			for(unsigned ipr = 0; ipr < aux_mean_cum.size(); ++ipr)
			{
				outputs->matrix_mns[ipr] += aux_mean_cum[ipr];
			}
			
			for(unsigned iprr = 0; iprr < aux_var_cum.size(); ++iprr)
			{
				outputs->matrix_vars[iprr] += aux_var_cum[iprr];
			}
			
			
 		}
		
    }
	
};


