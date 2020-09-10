void derivObsAux(const struct prok2Input* inputs,
										const struct variableMainAttr& vMA, 
										const double in_one_over_ind_lik,
										std::vector<double>& in_aux_obs_cum,
										std::vector<double>& out_aux_obs_cum_all,
										std::vector<double>& in_xxmat_aux,
										unsigned ikg)
{										

	unsigned ifco = inputs->indFirCoefOb[vMA.ivar]; /*index first param. - observables */
	unsigned iobs = variableObsRegrAttr(inputs, vMA.vdata, vMA.ivar); /* starting index of the regressors */
	
    if (vMA.type==6) {        
                //unsigned num_alt_m1_3 = inputs->numOutVarM1[i_var_3]; /*number of alternatives minus 1 */           
                
		for(unsigned jll=0;jll<vMA.num_alt_m1;++jll) /* looping over alternatives */
        {
            unsigned jnreg_3 = jll*vMA.nregr; /*number of coefficients already used for previous alternatives */
      		unsigned ifcol = ifco+jnreg_3;
			unsigned uijll = vMA.uid+jll;
					
			for(unsigned rg3=0;rg3<vMA.nregr;++rg3) /*looping over observables */
			{
				out_aux_obs_cum_all[ifcol+rg3] += in_aux_obs_cum[uijll]*in_xxmat_aux[iobs+rg3]*in_one_over_ind_lik; /*xxmat_aux */
			}                          
                                
		}  
				
    } else { 
				
		if (vMA.miss) /*non-missing outcome */
		{
					
			for(unsigned rg3a=0;rg3a<vMA.nregr;++rg3a) /*looping over observables */
			{
				out_aux_obs_cum_all[ifco+rg3a] += in_aux_obs_cum[vMA.uid]*in_xxmat_aux[iobs+rg3a]*in_one_over_ind_lik;
			}
                    
		} else {
					
			std::vector<double> multipkC(ikg,1.0); /* product of parameters for missing regressors */
			std::vector<unsigned> ivarC(ikg); /* indentity of missing regressors */
			std::vector<unsigned> vdataC(ikg); /* location of missing regressors */
			std::vector<unsigned> ninkC(ikg,0); /* number missing regressors per level - counter*/
					
			unsigned boutC = 1; /*counter for multipk */
			ivarC[0] = vMA.ivar; /* initializing identity of missing variable in the chain */
			vdataC[0] = vMA.vdata; /* initializing data storage info */
					
			while (boutC>0)
			{
				unsigned boutCM1 = boutC - 1;
				unsigned noinC = variableNInclAttr (inputs, vdataC[boutCM1], ivarC[boutCM1]); /* number of outcomes in which the variable is included at this level */
				unsigned ninC = ninkC[boutCM1]; /* counter of variables at this level of missingness */
				ninkC[boutCM1] = ninC+1;
						
				if (ninkC[boutCM1]>noinC) /* going back to previous level */
				{
					boutC--;
						
				} else{
							
					variableInclVAttrPlus inclVar(inputs, vdataC[boutCM1],ivarC[boutCM1],ninC);
						
					if (inclVar.type<6)
					{
						multipkC[boutC] = multipkC[boutCM1]*inputs->beta[inclVar.index_coef]*inputs->xxmat[inclVar.index_regr];
									
						if (inclVar.miss)
						{
							
							for(unsigned rg3b=0;rg3b<vMA.nregr;++rg3b) /*looping over observables */
							{
								out_aux_obs_cum_all[ifco+rg3b] += in_aux_obs_cum[inclVar.uid]*in_xxmat_aux[iobs+rg3b]*in_one_over_ind_lik*multipkC[boutC]; 
							}
								
						}
								
						else if (boutC<ikg)
						{
							ivarC[boutC] = inclVar.ivar;
							vdataC[boutC] = inclVar.vdata;
							ninkC[boutC] = 0;
							boutC++; /* searching for non-missing variable */
									
						} 
							
					} else {
								
						for(unsigned jb=0;jb<inclVar.num_alt_m1;++jb) /* looping over alternatives */
						{
							unsigned uidjb = inclVar.uid+jb; /*unique index */
							double multipj = multipkC[boutCM1]*inputs->beta[inclVar.index_coef+jb*inclVar.nregr]*inputs->xxmat[inclVar.index_regr];
								
							for(unsigned rg3c=0;rg3c<vMA.nregr;++rg3c) /*looping over observables */
							{
								out_aux_obs_cum_all[ifco+rg3c] += in_aux_obs_cum[uidjb]*in_xxmat_aux[iobs+rg3c]*in_one_over_ind_lik*multipj;
							}
							
						}
						
					}
						
				}
					
			}
										
		}
				
    }

};
