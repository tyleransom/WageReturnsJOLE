#include "marg_calc.h"
#include "margInput.h"
#include "margOutput.h"
#include <math.h>
#include <vector>
#include <omp.h>
#include <string.h>

void calculateMarg(const struct margInput* inputs, struct margOutput* outputs)
{
	//mexPrintf("1");
	std::vector<double> one_over_sigma(inputs->d_sigmaM);
    std::vector<double> one_over_sigma_sq(inputs->d_sigmaM);
    std::vector<double> minus_half_one_over_sigma_sq(inputs->d_sigmaM);
    std::vector<double> one_over_sigma_abs_pi(inputs->d_sigmaM); 
	 ////mexPrintf("one_over_sigma_sq[0] is %f[0]\n",one_over_sigma_sq[0]);
    
    for(unsigned ii = 0; ii < inputs->d_sigmaM; ++ii) /* transformations of the variances for the idiosyncratic shocks */
    {
        double sigma_aux = inputs->gammaM[inputs->d_betaM+inputs->d_alphaM+ii]; 
        one_over_sigma[ii] = 1.0/sigma_aux;
        one_over_sigma_sq[ii] = one_over_sigma[ii]/sigma_aux;
        minus_half_one_over_sigma_sq[ii] = -0.5*one_over_sigma_sq[ii];
        one_over_sigma_abs_pi[ii] = sqrt(1/(2*M_PI))*(1 / fabs(sigma_aux));
    }
	
	unsigned mea1 = inputs->sizeoutputFM;
	unsigned mei1 = inputs->sizeoutputFM*inputs->numindivM;
	unsigned mw1 = inputs->numDrawsM*inputs->numindivM;
	unsigned mmu1 = inputs->numindivM*inputs->maxNumFa;

	
	
	std::vector<double> outputMEA(mea1,0.);
	std::vector<double> outputMEI(mei1,0.);
	std::vector<double> outputMW(mw1,0.);
	std::vector<double> outputMMU(mmu1,0.);
	std::vector<double> probIterF(inputs->numindivM,0.);
	
	//#pragma omp parallel for num_threads(8) 
	
	for(int n = 0; n<inputs->numindivM; ++n) /* looping over individuals */
    {
		//mexPrintf("\n\n   N is %d\n\n",n);
		
		unsigned ind_draw_start = inputs->indDrawPersonM[n];
		unsigned weight_start = n*inputs->numDrawsM;
			
		for(unsigned r=0;r<inputs->numDrawsM;++r) /* looping over random draws */
		{    
		
			unsigned r_drawn = ind_draw_start+r*inputs->numVarDrawnM; /* start of generated variables for the person in this draw */
			unsigned w_drawn = weight_start+r; /*start of weights */
			
			std::vector<double> regM; /*copy of regressors */
			std::copy(inputs->regrM, inputs->regrM + inputs->regrM_size, std::back_inserter(regM));
			
			std::vector<double> defM; /*copy of default values for sums */
			std::copy(inputs->defauM, inputs->defauM + inputs->defauM_size, std::back_inserter(defM));
			
			std::vector<double> probIter(inputs->SSVarM+1,0.); /*probability at each level */
			
			probIter[0]=inputs->drawWeightsM[w_drawn]; /*initializing */
			
			std::vector<double> outcIter(inputs->SSVarM*inputs->maxNumOutVarM,0);  /*matrix for keeping track of generated probabilities from discrete choices (*/
			
			std::vector<unsigned> condIter(inputs->SSVarM,0); /*number of conditions realized at this iteration */ 
			std::vector<double> oldVal(inputs->SSVarM,-999.); /*values from previous iteration */ 
			
			std::vector<double> IntermOutc(inputs->sizeoutputIM,0.); /*intermediary outcomes */

			
			std::vector<unsigned> nink(inputs->SSVarM,0); /* number of outcomes already taken into consideration*/	
			unsigned bout = 1; /*counter for exit */
			
			//mexPrintf("\n DRAW is %d\n\n",r);
			//mexPrintf("probIter0[%d]is at %f\n",0,probIter[0]);
			
			while (bout>0)
			{
				unsigned boutM1 = bout - 1;
				unsigned noin = inputs->numOutVarM[boutM1]; /* number of choices the variable can take */
				unsigned nin = nink[boutM1]; /* counter of outcomes for this variable already visited*/
				nink[boutM1] = nin+1;
				if (inputs->typeVarIdM[boutM1]==5 ) { // && boutM1>=inputs->thresholdvarM){ /*fixed discrete value before threshold */
					if (inputs->fixedvarvalueM[boutM1*inputs->numindivM+n]>-998){
						if (nin==0){
							nink[boutM1] = inputs->fixedvarvalueM[boutM1*inputs->numindivM+n];
						}
						noin = 1;
					} else if (boutM1<inputs->thresholdvarM){
						noin=1;
					}
				}
				
				if (nink[boutM1]>noin && nin>0) /* going back to previous level */
				{
					bout--;
						
				} else if (boutM1<inputs->SSVarM){
				

					
					unsigned paka=1;
					
					
					if (oldVal[boutM1]>-998){
						
						//mexPrintf("bout (old) is %d\n",bout);
						
						if (inputs->typeVarIdM[boutM1]==5){
					
							unsigned jout=oldVal[boutM1];
							
							for(unsigned lr1=0;lr1<inputs->XnumInclOutcM[boutM1];++lr1) /* looping over participating outcomes draws */
							{
								unsigned indoutc1 = lr1*inputs->SSVarM+boutM1;
								
								if (inputs->XindInclOutcAlterM[indoutc1]==jout){
									
									unsigned indoutcvar1 = inputs->XindInclOutcIdM[indoutc1];
									
									if (inputs->XindInclOutcTyp2M[indoutc1]==1){
										condIter[indoutcvar1]--;
										
									} else { 
										double pout1=1.;
										
										if (inputs->XindInclOutcTyp1M[indoutc1]==1) {
											pout1 *= inputs->XindInclOutcMultM[indoutc1];
										}
										
										
										if (inputs->XindInclOutcTyp3M[indoutc1]==0){
											regM[inputs->indRegrM[indoutcvar1]*inputs->numindivM+n*inputs->numRegrM[indoutcvar1]+inputs->XindInclOutcRegM[indoutc1]] -= pout1;
											
										} else {
											defM[inputs->indRegrM[indoutcvar1]*inputs->numindivM+n] -= pout1;
										}
									}
								}			
							}
							
							unsigned iuid2 = inputs->uniqueVarIdIM[boutM1];
							unsigned bwr = inputs->numOutVarM[boutM1];
							for(unsigned r1z=0;r1z<bwr;++r1z) 
							{
								IntermOutc[iuid2+r1z]=0.;
							}
							
						} else {
						
							for(unsigned lr2=0;lr2<inputs->XnumInclOutcM[boutM1];++lr2) /* looping over participating outcomes draws */
							{
								unsigned indoutc2 = lr2*inputs->SSVarM+boutM1;
								unsigned indoutcvar2 = inputs->XindInclOutcIdM[indoutc2];
								double jout1 = oldVal[boutM1];
								
								if (inputs->XindInclOutcTyp2M[indoutc2]==1){
									if (jout1>inputs->XindInclOutcMinValM[indoutc2] && jout1<inputs->XindInclOutcMaxValM[indoutc2]){
										
										condIter[indoutcvar2]--;
									
									}
										
								} else {
									
									if (inputs->XindInclOutcTyp1M[indoutc2]==1) {
										jout1 *= inputs->XindInclOutcMultM[indoutc2];
									}
									
									
									if (inputs->XindInclOutcTyp3M[indoutc2]==0){
										regM[inputs->indRegrM[indoutcvar2]*inputs->numindivM+n*inputs->numRegrM[indoutcvar2]+inputs->XindInclOutcRegM[indoutc2]] -= jout1;
										
									} else {
										defM[inputs->indRegrM[indoutcvar2]*inputs->numindivM+n] -= jout1;
									}
								
								}
							}
						
							unsigned iuid3 = inputs->uniqueVarIdIM[boutM1];
							IntermOutc[iuid3]=0.;
						
						}
						oldVal[boutM1]=-999;
					}
						
					if ((condIter[boutM1]==inputs->numCondVarM[boutM1]) && ((inputs->fixedvarvalueM[boutM1*inputs->numindivM+n]>-998) || (boutM1>=inputs->thresholdvarM) || (inputs->typeVarIdM[boutM1]!=5))) { // should be ==4 once we integrate over epsilon
						
						//mexPrintf("\nBOUT is %d\n\n",bout);
						
						if (inputs->typeVarIdM[boutM1]==5){
						
							//mexPrintf("alternative is %d\n\n",nink[boutM1]);
						
							unsigned kwra = inputs->numOutVarM[boutM1];
							unsigned iuid = inputs->uniqueVarIdIM[boutM1];
							
							if ((nink[boutM1]==1 || inputs->fixedvarvalueM[boutM1*inputs->numindivM+n]>-998) && boutM1>=inputs->thresholdvarM ){ /*initializing for discrete choices */
								unsigned ireg = inputs->indRegrM[boutM1]*inputs->numindivM+n*inputs->numRegrM[boutM1];
								unsigned kwr = kwra-1;
								std::vector<double> gout(kwr,0.);
								std::vector<double> gout1(kwr,0.);
								unsigned nreg = inputs->numRegrM[boutM1];
								unsigned iobs = inputs->indFirCoefObM[boutM1];
								unsigned iunobs = inputs->indFirCoefUnobM[boutM1];
								unsigned nfac = inputs->numFaM[boutM1];
								for(unsigned zr=0;zr<inputs->numinterM[boutM1];++zr) /* looping over interactions*/
								{
									unsigned indexint = zr*inputs->SSVarM+boutM1;
									regM[ireg+inputs->interbothM[indexint]] = regM[ireg+inputs->interoneM[indexint]]*regM[ireg+inputs->intertwoM[indexint]]*inputs->intermultM[indexint];	
								}

								double vout=1.;
							
								for(unsigned wr=0;wr<kwr;++wr) 
								{
									for(unsigned fr1=0;fr1<nreg;++fr1) 
									{
										//mexPrintf("regM[%d] is %f\n",ireg+fr1, regM[ireg+fr1]);
										//mexPrintf("gammaM[%d] is %f\n",iobs+nreg*wr+fr1, inputs->gammaM[iobs+nreg*wr+fr1]);
										gout[wr] += regM[ireg+fr1]*inputs->gammaM[iobs+nreg*wr+fr1];
									}
						
									for(unsigned nr1=0;nr1<nfac;++nr1) /* looping over random draws */
									{
										//mexPrintf("inputs->drawFilesM[%d] is %f\n",r_drawn+inputs->factorIdM[nr1*inputs->SSVarM+boutM1], inputs->drawFilesM[r_drawn+inputs->factorIdM[nr1*inputs->SSVarM+boutM1]]);
										//mexPrintf("gammaM[%d] is %f\n",inputs->d_betaM+iunobs+nfac*wr+nr1, inputs->gammaM[inputs->d_betaM+iunobs+nfac*wr+nr1]);
										gout[wr] += inputs->drawFilesM[r_drawn+inputs->factorIdM[nr1*inputs->SSVarM+boutM1]]*inputs->gammaM[inputs->d_betaM+iunobs+nfac*wr+nr1];
									}
									gout1[wr] = exp(gout[wr]);
									vout +=gout1[wr];
								}
							
								for(unsigned wr1=0;wr1<kwr;++wr1) 
								{
									outcIter[inputs->SSVarM*wr1+boutM1] = gout1[wr1]/vout;
								}
							
								outcIter[inputs->SSVarM*kwr+boutM1] = 1/vout;
								
								if (inputs->fixedvarvalueM[boutM1*inputs->numindivM+n]>-998) { // && boutM1>=inputs->thresholdvarM){ /*update probability with fixed value after start */
									
									unsigned kwrz = inputs->fixedvarvalueM[boutM1*inputs->numindivM+n]-1;
									for(unsigned wr1z=0;wr1z<kwra;++wr1z) 
									{
										outcIter[inputs->SSVarM*wr1z+boutM1] = outcIter[inputs->SSVarM*kwrz+boutM1];
									}
								}

							}
							
							
							if (inputs->fixedvarvalueM[boutM1*inputs->numindivM+n]>-998) { // && boutM1>=inputs->thresholdvarM){ /*update probability with fixed value after start */
									
								unsigned kwrzz = inputs->fixedvarvalueM[boutM1*inputs->numindivM+n]-1;
								for(unsigned wr1zz=0;wr1zz<kwra;++wr1zz) 
								{
									IntermOutc[iuid+wr1zz]=0.;
								}
								IntermOutc[iuid+kwrzz]=1.;
							} else {
							
								IntermOutc[iuid+nink[boutM1]-1]=1.;
							}
							
							
							if (boutM1>=inputs->thresholdvarM && inputs->fixedvarvalueM[boutM1*inputs->numindivM+n]>-998) {
								probIter[boutM1]=probIter[boutM1]*outcIter[inputs->SSVarM*nin+boutM1];
								probIter[bout]=probIter[boutM1];
							} else if (boutM1>=inputs->thresholdvarM && inputs->fixedvarvalueM[boutM1*inputs->numindivM+n]<-998){
								probIter[bout]=probIter[boutM1]*outcIter[inputs->SSVarM*nin+boutM1];
							} else {
								probIter[bout]=probIter[boutM1];
							}
					
							for(unsigned lr=0;lr<inputs->XnumInclOutcM[boutM1];++lr) /* looping over participating outcomes draws */
							{
								
								unsigned indoutc = lr*inputs->SSVarM+boutM1;
								if (inputs->XindInclOutcAlterM[indoutc]==nink[boutM1]){
									
									
									unsigned indoutcvar = inputs->XindInclOutcIdM[indoutc];
								
									if (inputs->XindInclOutcTyp2M[indoutc]==1){
										condIter[indoutcvar]++;
										
									} else { 
										double pout=1.;
										
										if (inputs->XindInclOutcTyp1M[indoutc]==1) {
											pout *= inputs->XindInclOutcMultM[indoutc];
										}
										
										if (inputs->XindInclOutcTyp3M[indoutc]==0){
											regM[inputs->indRegrM[indoutcvar]*inputs->numindivM+n*inputs->numRegrM[indoutcvar]+inputs->XindInclOutcRegM[indoutc]] += pout;
											
										} else {
											defM[inputs->indRegrM[indoutcvar]*inputs->numindivM+n] += pout;
										}
									}
								}		
							}
							
							oldVal[boutM1]=nink[boutM1];
							
						} else {
							double newVal=0.;
							double prob_aux=1.;
							unsigned iuid1 = inputs->uniqueVarIdIM[boutM1];
							if (inputs->typeVarIdM[boutM1]==4){
								
								if(inputs->fixedvarvalueM[boutM1*inputs->numindivM+n]>-998 && boutM1<inputs->thresholdvarM){
									
									newVal=inputs->fixedvarvalueM[boutM1*inputs->numindivM+n];
								
								} else {
							
									newVal=defM[inputs->indRegrM[boutM1]*inputs->numindivM+n];
								}
								
							} else {
								
								double yout=0.; 
								unsigned ireg = inputs->indRegrM[boutM1]*inputs->numindivM+n*inputs->numRegrM[boutM1];
								unsigned nreg = inputs->numRegrM[boutM1];
								unsigned iobs = inputs->indFirCoefObM[boutM1];
								unsigned iunobs = inputs->indFirCoefUnobM[boutM1];									
								unsigned nfac = inputs->numFaM[boutM1];
								
								for(unsigned zr=0;zr<inputs->numinterM[boutM1];++zr) /* looping over interactions*/
								{
									mexPrintf("zr1 is %d\n",zr+1);
									
									
									unsigned indexint = zr*inputs->SSVarM+boutM1;
									mexPrintf("regM_m is %f\n",inputs->intermultM[indexint]);
									mexPrintf("regM_1 is %f\n",regM[ireg+inputs->interoneM[indexint]]);
									mexPrintf("regM_2 is %f\n",regM[ireg+inputs->intertwoM[indexint]]);
									mexPrintf("regM_b1 is %d\n",regM[ireg+inputs->interbothM[indexint]]);
									regM[ireg+inputs->interbothM[indexint]] = regM[ireg+inputs->interoneM[indexint]]*regM[ireg+inputs->intertwoM[indexint]]*inputs->intermultM[indexint];
									mexPrintf("regM_b is %f\n",regM[ireg+inputs->interbothM[indexint]]);
								}

								for(unsigned fr=0;fr<nreg;++fr) 
								{	
									mexPrintf("fr1 is %d\n",fr+1);
									mexPrintf("regM[%d] is %f\n",ireg+fr, regM[ireg+fr]);
									mexPrintf("gammaM[%d] is %f\n",iobs+fr, inputs->gammaM[iobs+fr]);
									double gaf= regM[ireg+fr]*inputs->gammaM[iobs+fr];
									mexPrintf("gaf is %f\n",gaf);
									yout += regM[ireg+fr]*inputs->gammaM[iobs+fr];  
								}
						
								for(unsigned nr=0;nr<nfac;++nr) /* looping over random draws */
								{
									mexPrintf("inputs->drawFilesM[%d] is %f\n",r_drawn+inputs->factorIdM[nr*inputs->SSVarM+boutM1], inputs->drawFilesM[r_drawn+inputs->factorIdM[nr*inputs->SSVarM+boutM1]]);
									mexPrintf("gammaM[%d] is %f\n",inputs->d_betaM+iunobs+nr, inputs->gammaM[inputs->d_betaM+iunobs+nr]);
									double gaf1= inputs->drawFilesM[r_drawn+inputs->factorIdM[nr*inputs->SSVarM+boutM1]]*inputs->gammaM[inputs->d_betaM+iunobs+nr];
									mexPrintf("gaf1 is %f\n",gaf1);
									yout += inputs->drawFilesM[r_drawn+inputs->factorIdM[nr*inputs->SSVarM+boutM1]]*inputs->gammaM[inputs->d_betaM+iunobs+nr];
								}
								
								mexPrintf("yout is %f\n",yout);
								
								if(inputs->fixedvarvalueM[boutM1*inputs->numindivM+n]>-998){
							
									newVal=inputs->fixedvarvalueM[boutM1*inputs->numindivM+n];
									
									if (inputs->typeVarIdM[boutM1]==2 && boutM1>=inputs->thresholdvarM){ /*update probability with fixed value after start */
										unsigned ifv1 = inputs->indFirCoefIdsM[boutM1];
										double auxie = inputs->fixedvarvalueM[boutM1*inputs->numindivM+n] - yout;
										double aux_sq = auxie*auxie;
										double aux_new=exp(aux_sq * minus_half_one_over_sigma_sq[ifv1]);
										prob_aux = aux_new*one_over_sigma_abs_pi[ifv1];
										//mexPrintf("prob_aux is %f\n",prob_aux);
									}
								
								} else {
									
									newVal = yout; /* add id shock if 2 */
								
								}
							}
							

							probIter[boutM1]=probIter[boutM1]*prob_aux;
							probIter[bout]=probIter[boutM1];
							
							for(unsigned lr0=0;lr0<inputs->XnumInclOutcM[boutM1];++lr0) /* looping over participating outcomes draws */
							{
								unsigned indoutc0 = lr0*inputs->SSVarM+boutM1;
								unsigned indoutcvar0 = inputs->XindInclOutcIdM[indoutc0];
								double pout1 = newVal;
								
								if (inputs->XindInclOutcTyp2M[indoutc0]==1){
									if (pout1>inputs->XindInclOutcMinValM[indoutc0] && pout1<inputs->XindInclOutcMaxValM[indoutc0]){
										
										condIter[indoutcvar0]++;
									
									}
										
								} else {
									
									if (inputs->XindInclOutcTyp1M[indoutc0]==1) {
										pout1 *= inputs->XindInclOutcMultM[indoutc0];
									}
									
									
									if (inputs->XindInclOutcTyp3M[indoutc0]==0){
										regM[inputs->indRegrM[indoutcvar0]*inputs->numindivM+n*inputs->numRegrM[indoutcvar0]+inputs->XindInclOutcRegM[indoutc0]] += pout1;
										
									} else {
										defM[inputs->indRegrM[indoutcvar0]*inputs->numindivM+n] += pout1;
									}
								
								}
							}
							
							oldVal[boutM1]=newVal;
							IntermOutc[iuid1]=newVal;
							
							if (inputs->typeVarIdM[boutM1]==4 && inputs->fixedvarvalueM[boutM1*inputs->numindivM+n]>-998 && boutM1>=inputs->thresholdvarM){
							
								double gasw = abs(inputs->fixedvarvalueM[boutM1*inputs->numindivM+n]-newVal);
								if (gasw>0.0001){
									paka=paka-1;
								}
							}
						
						}
						
					} else if (inputs->fixedvarvalueM[boutM1*inputs->numindivM+n]>-998){
						paka=paka-1;
						probIter[bout]=probIter[boutM1];
					} else {
						probIter[bout]=probIter[boutM1];
					}
					
					//mexPrintf("paka is %d\n",paka);
					//mexPrintf("SSVarM is %d\n",inputs->SSVarM);
					//mexPrintf("probIterM1[%d] is %f\n",boutM1, probIter[boutM1]);
					//mexPrintf("probIter[%d] is %f\n",bout, probIter[bout]);
					
					if (bout<inputs->SSVarM && paka==1){
						nink[bout] = 0;
						bout++;
					} else if (paka==0){

						bout--;
					}
					else if (bout==inputs->SSVarM && paka==1){
						for(unsigned or1=0;or1<inputs->inter_size;++or1) /* looping over variables of interest */
						{
							unsigned varint = inputs->varinterM[or1];
							unsigned uidf = inputs->uniqueVarIdFM[or1];
							unsigned uidi = inputs->uniqueVarIdIM[varint];
							unsigned numoutc = inputs->numOutVarM[varint];
							
							for(unsigned or2=0;or2<numoutc;++or2) /* looping over variables of interest */
							{
								mexPrintf("IntermOutc[%d] is %f\n",uidi+or2,IntermOutc[uidi+or2]);
								outputMEI[n*inputs->sizeoutputFM+uidf+or2] += IntermOutc[uidi+or2]*probIter[bout];
							}
							
							
						}
						
						for(unsigned or6=0;or6<inputs->maxNumFa;++or6) /* looping over variables of interest */
						{
							outputMMU[n*inputs->maxNumFa+or6] += inputs->drawFilesM[r_drawn+or6]*probIter[bout];
						}
						outputMW[n*inputs->numDrawsM+r] += probIter[bout];
						probIterF[n] += probIter[bout];
						mexPrintf("probIterF[%d] is at %f\n",n,probIterF[n]);
						
					}
					
				}

			}
			
		}


		for(unsigned or3=0;or3<inputs->sizeoutputFM;++or3) /* looping over variables of interest */
		{
			outputMEI[n*inputs->sizeoutputFM+or3] = outputMEI[n*inputs->sizeoutputFM+or3]/probIterF[n];	
		}
				
		for(unsigned or4=0;or4<inputs->numDrawsM;++or4) /* looping over variables of interest */
		{
			outputMW[n*inputs->numDrawsM+or4] = outputMW[n*inputs->numDrawsM+or4]/probIterF[n];	
		}
		
		for(unsigned or5=0;or5<inputs->maxNumFa;++or5) /* looping over variables of interest */
		{
			outputMMU[n*inputs->maxNumFa+or5] = outputMMU[n*inputs->maxNumFa+or5]/probIterF[n];	
		}
				
		
		//#pragma omp critical (reduction_code) 
 		//{	

		for(unsigned ir = 0; ir < outputMEA.size(); ++ir)
		{
			outputMEA[ir] += outputMEI[n*inputs->sizeoutputFM+ir];
		}
		
            
 		//}
	}
	
	
	for(unsigned iirk = 0; iirk < outputMEA.size(); ++iirk)
	{
		outputs->matrix_effectsAll[iirk] += outputMEA[iirk]/inputs->numindivM;; //not by n
	}
	
	for(unsigned iir = 0; iir < outputMEI.size(); ++iir)
	{
		outputs->matrix_effectsInd[iir] += outputMEI[iir]; //not by n
	}
	
	for(unsigned iiir = 0; iiir < outputMW.size(); ++iiir)
	{
		outputs->matrix_weights[iiir] += outputMW[iiir]; //not by n
	}
	
	for(unsigned iiiir = 0; iiiir < outputMMU.size(); ++iiiir)
	{
		outputs->matrix_meanunob[iiiir] += outputMMU[iiiir]; //not by n
	}
	
	for(unsigned iiiiir = 0; iiiiir < inputs->numindivM; ++iiiiir)
	{
		outputs->matrix_probInd[iiiiir] += probIterF[iiiiir]; //not by n
	}	
	
}

