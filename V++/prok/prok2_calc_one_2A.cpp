#include "prok2_calc.h"
#include "prok2Input.h"
#include "prok2Output.h"
#include <math.h>
#include <vector>
#include <omp.h>
#include <string.h>
#include "cmatrix"
#include "prok2_aux.h"
#include "prok2_constrPerm.h"
#include "mainComp.h"
#include "mainCompAux.h"
#include "acceptValue.h"
#include "allIter.h"
#include "derivObs.h"


typedef techsoft::matrix<double> Matrix;
typedef std::valarray<double> Vector;


void calculateProk2(const struct prok2Input* inputs, struct prok2Output* outputs)
{
   	
	std::vector<double> xxmat_aux; /*copying the regressors */
    std::copy(inputs->xxmat, inputs->xxmat + inputs->xxmat_size, std::back_inserter(xxmat_aux));
    //double * xxmat_aux = & xxmat_aux_m[0]; /* updating both draw-specific and non-draw specific missing variables */

    std::vector<double> one_over_sigma(inputs->d_sigma);
    std::vector<double> one_over_sigma_sq(inputs->d_sigma);
    std::vector<double> minus_half_one_over_sigma_sq(inputs->d_sigma);
    std::vector<double> one_over_sigma_cub(inputs->d_sigma);
    std::vector<double> log_one_over_sigma_abs_pi(inputs->d_sigma); 
	 //mexPrintf("one_over_sigma_sq[0] is %f[0]\n",one_over_sigma_sq[0]);
    
    for(unsigned ii = 0; ii < inputs->d_sigma; ++ii) /* transformations of the variances for the idiosyncratic shocks */
    {
        double sigma_aux = inputs->sigma[ii]; 
        one_over_sigma[ii] = 1.0/sigma_aux;
        one_over_sigma_sq[ii] = one_over_sigma[ii]/sigma_aux;
        minus_half_one_over_sigma_sq[ii] = -0.5*one_over_sigma_sq[ii];
        one_over_sigma_cub[ii] = one_over_sigma_sq[ii]/sigma_aux;
        log_one_over_sigma_abs_pi[ii] = log(sqrt(1/(2*M_PI))*(1 / fabs(sigma_aux)));
    }
	
	#pragma omp parallel for num_threads(1) 
    /* #pragma omp for ordered // num_threads(2) */
    
    for(int n = inputs->NA; n<inputs->NB; ++n) /* looping over individuals */
    {
					 
					 //mexPrintf("n is %d\n",n);
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
    
		 std::vector<double> aux_obs_lin_it(inputs->SVarOut); /* vector with linear projections of the observables - iteration specific */
		 std::vector<double> aux_obs_lin(inputs->SVarOut,0.0); /* vector with linear projections of the observables */
		 
		 std::vector<double> aux_cont_iter(inputs->xxmat_size); /* vector with the variable part of the missing regressor - iteration specific */
		 std::vector<double> aux_cont_it_mult(inputs->SVarOut); /* vector with the variable part of the missing regressor - iteration specific, multiplied when regressor */
		 
		 
        unsigned ind_draw_start = inputs->indDrawPerson[n]; /* index where the generated factors start the person in each draw */
		unsigned ind_draw_start_miss = inputs->indDrawPersonMiss[n]; /* index where the generated factors start the person in each draw - missing variables */ 
        
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
		
         
        for (unsigned drawFileIndex = 0; drawFileIndex < inputs->drawFileCount; ++drawFileIndex) /*looping over files with random draws */
        {   
		
            double* rmat = inputs->drawFiles[drawFileIndex]; /* from the vector of draws in one file*/
			double* rmatMiss = inputs->drawFilesMiss[drawFileIndex]; /* from the vector of draws in one file - missing variables*/  
            unsigned r_count_miss = 0; /*counter for missing variables - when generated*/
            unsigned r_count_miss_use = 0; /*counter for missing variables - when used */
            
            for(unsigned r=0;r<inputs->drawsCount;++r) /* looping over random draws */
			{      
                //mexPrintf("r is %d\n",r);
				unsigned r_drawn = ind_draw_start+r*inputs->numVarDrawn; /* start of generated variables for the person in this draw */ 
				
                double sum_log_num_disc = 0.; /*sum of the logs of the numerators of the likelihoods for discrete outcomes*/ 
				double sum_log_den_disc = 0.; /* sum of the logs of the denominators of the likelihoods for discrete outcomes*/
				double sum_log_cont_mp = 0.; /* main part of log of prob of cont. variables */
				double sum_log_cont_ap = 0.; /* additional part of log of prob of cont. variables */
                
				aux_obs_lin_it=aux_obs_lin; /* initializing */

                
				/* Initializing the iteration-specific auxiliary objects */
                std::fill(aux_unobs_iter.begin(), aux_unobs_iter.end(), 0.0);
                std::fill(aux_obs_iter.begin(), aux_obs_iter.end(), 0.0);
				std::fill(aux_obs_iter_all.begin(), aux_obs_iter_all.end(), 0.0);
				std::fill(aux_obs_iter_all_ind.begin(), aux_obs_iter_all_ind.end(), 0.0);
                std::fill(aux_ids_iter.begin(), aux_ids_iter.end(), 0.0);
				std::fill(aux_cont_iter.begin(), aux_cont_iter.end(), 0.0);
				std::fill(aux_cont_it_mult.begin(), aux_cont_it_mult.end(), 0.0);
						
				for(size_t js=0;js<ing0;++js) /*initializing */
				{
					AEpsi[js].null();
					AderAuxT[js].null();
				}
                
				for(unsigned vv=0; vv<Vt; ++vv) /*looping over variables */
                {
					//mexPrintf("vv is %d\n",vv);
					unsigned v_index1 = Vt_index+vv; /* variable index */
					variableMainAttr vMA1 (inputs, v_index1);
					unsigned nmrd1 = variableNIterVAttr (inputs, vMA1.vdata,vMA1.ivar);
                    
					if (vMA1.type==6) {    /* discrete outcome variable */    
						conmpDisc(inputs, vMA1, aux_obs_lin_it,xxmat_aux, rmat,r_drawn,sum_log_num_disc,sum_log_den_disc,aux_obs_iter,aux_unobs_iter,aux_obs_iter_all,aux_cont_iter);	
                            
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
							constructIterMissCont(inputs,vMA1,aux_obs_lin_it,rmat,r_drawn, rmatMiss, ind_draw_start_miss,r_count_miss, aux_cont_it_mult,aux_cont_iter);
							
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
					conmpAux(inputs, vMA2,aux_ids_iter,rmat,r_drawn,rmatMiss,ind_draw_start_miss, r_count_miss_use, aux_obs_iter, aux_unobs_iter,aux_obs_iter_all, aux_cont_iter, ikg0);				
				}        
		
                
                double aux_no_zero_1 = sum_log_num_disc - sum_log_den_disc + sum_log_cont_mp + sum_log_cont_ap;
				double lik_iter = 0.0; /*likelihood for the iteration */
				noLogZero(inputs,adj_add,adj_mul,lik_iter,aux_no_zero_1,max_prob_ind);
                
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
			// //Matrix& LambdaA = ALambda[xs];
			
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
                    
        for(unsigned dd3=0; dd3<inputs->d_sigma; ++dd3) /*looping over idiosyncratic variable variances  */
        {
            aux_ids_cum[dd3] *= one_over_ind_lik;
        }
                    
                    /*the likelihood */
        double log_ind_lik=log(ind_lik/(inputs->numDraws)) - adj_add;

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
			
 		}
		
    }
	
};


