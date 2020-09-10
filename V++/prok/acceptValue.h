void noLogZero(const struct prok2Input* inputs,
										double& in_out_adj_add,
										double& out_adj_mul,
										double& out_lik_iter,
										const double in_aux_no_zero,
										double& in_out_max_prob_ind)
										
{
	double aux_no_zero = in_aux_no_zero+ in_out_adj_add; /* auxiliary log likelihood */				
    in_out_max_prob_ind = std::max(in_out_max_prob_ind,in_aux_no_zero);
	double corr_add = 0.0; /* correction for the addend */
			
	if (aux_no_zero>=inputs->probMin){ //making sure there is no log(0) afterwards
					
		if (aux_no_zero<inputs->probMax) {
			out_lik_iter = exp(aux_no_zero); /*likelihood for the iteration */
			out_adj_mul = 1.; /* adjustment multiplier ensureing no log of 0 */  
						
		} else {
			corr_add = inputs->probMax - aux_no_zero;
			out_lik_iter = exp(aux_no_zero + corr_add);
			in_out_adj_add += corr_add;
			out_adj_mul = exp(corr_add);
		}
                    
	} else {
                    
		corr_add = inputs->probMin - aux_no_zero;                
		if (in_out_max_prob_ind + in_out_adj_add + corr_add >= inputs->probMax ) {
                        
            out_lik_iter = exp(aux_no_zero);
			out_adj_mul = 1.;
						
        } else {
           	out_lik_iter = exp(aux_no_zero + corr_add);
			in_out_adj_add += corr_add;
						
            if(corr_add>inputs->probMaxMax){
                 out_adj_mul=1;
							
            }else{
                out_adj_mul = exp(corr_add); 
            }
                        
		}
                    
	}
};
void correctDerivObs(const struct prok2Input* inputs,
										const struct variableMainAttr& vMA,
										const double in_adj_mul,
										const double in_lik_iter,
										std::vector<double>& out_aux_obs_cum,										
										const std::vector<double>& in_aux_obs_iter,
										std::vector<unsigned>& in_out_aux_obs_iter_all_ind,
										std::vector<double>& out_aux_obs_cum_all,
										const std::vector<double>& in_aux_obs_iter_all)
										
{ 

	unsigned ifco = inputs->indFirCoefOb[vMA.ivar]; /*index first param. - observables */
	unsigned iobs = variableObsRegrAttr(inputs, vMA.vdata, vMA.ivar); /* starting index of the regressors */
	unsigned nmrd = variableNIterVAttr (inputs, vMA.vdata,vMA.ivar);
                     
    if (vMA.type==6) {         
                        
		for(unsigned jl=0;jl<vMA.num_alt_m1;++jl) /* looping over alternatives */
        {
            unsigned u2j = vMA.uid+jl;
            out_aux_obs_cum[u2j] *= in_adj_mul;
            out_aux_obs_cum[u2j] += in_lik_iter*in_aux_obs_iter[u2j];   
			unsigned ifcol = ifco+jl*vMA.nregr;
			
			for(unsigned kft2=0;kft2<nmrd;++kft2) /* looping over missing regressors with variable parts */
			{
				variableLIterVAttr varIter(inputs, vMA.vdata,vMA.ivar,kft2,iobs, ifcol);					
				
				if (in_out_aux_obs_iter_all_ind[varIter.index_it_coef]<1)
				{
					out_aux_obs_cum_all[varIter.index_it_coef] *= in_adj_mul;
					out_aux_obs_cum_all[varIter.index_it_coef] += in_lik_iter*in_aux_obs_iter_all[varIter.index_it_coef];
					in_out_aux_obs_iter_all_ind[varIter.index_it_coef] = 1;
				}
				
			}
                                
		} 
																		
    } else {    
		
		out_aux_obs_cum[vMA.uid] *= in_adj_mul;
        out_aux_obs_cum[vMA.uid] += in_lik_iter*in_aux_obs_iter[vMA.uid];
						
		for(unsigned kft3=0;kft3<nmrd;++kft3) /* looping over missing regressors with variable parts */
		{
			variableLIterVAttr varIter(inputs, vMA.vdata,vMA.ivar,kft3,iobs, ifco);						
			if (in_out_aux_obs_iter_all_ind[varIter.index_it_coef]<1)
			{
				out_aux_obs_cum_all[varIter.index_it_coef] *= in_adj_mul;
				out_aux_obs_cum_all[varIter.index_it_coef] += in_lik_iter*in_aux_obs_iter_all[varIter.index_it_coef];
				in_out_aux_obs_iter_all_ind[varIter.index_it_coef] = 1;
			}
							
		}
						
    } 
	
};
