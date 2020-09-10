void multDerivObsIter(const struct prok2Input* inputs,
										const struct variableMainAttr& vMA,
										const double in_one_over_ind_lik,										
										std::vector<unsigned>& in_out_aux_obs_cum_all_ind,
										std::vector<double>& out_aux_obs_cum_all)
{

	unsigned ifco = inputs->indFirCoefOb[vMA.ivar]; /*index first param. - observables */
	unsigned iobs = variableObsRegrAttr(inputs, vMA.vdata, vMA.ivar); /* starting index of the regressors */
	unsigned nmrd = variableNIterVAttr (inputs, vMA.vdata,vMA.ivar);

                     
    if (vMA.type==6) 
	{                   
						
		for(unsigned kjl=0;kjl<vMA.num_alt_m1;++kjl) /* looping over alternatives */
        {
			unsigned ifcol = ifco+kjl*vMA.nregr;
			for(unsigned kft2a=0;kft2a<nmrd;++kft2a) /* looping over missing regressors with variable parts */
			{
				variableLIterVAttr varIter(inputs, vMA.vdata,vMA.ivar,kft2a,iobs, ifcol);
				if (in_out_aux_obs_cum_all_ind[varIter.index_it_coef]<1)
				{
					out_aux_obs_cum_all[varIter.index_it_coef] *= in_one_over_ind_lik;
					in_out_aux_obs_cum_all_ind[varIter.index_it_coef]=1;
				}
						
			}
						
		}
						
    } else {    
						
		for(unsigned kft3a=0;kft3a<nmrd;++kft3a) /* looping over missing regressors with variable parts */
		{
			variableLIterVAttr varIter(inputs, vMA.vdata,vMA.ivar,kft3a,iobs, ifco);
			if (in_out_aux_obs_cum_all_ind[varIter.index_it_coef]<1)
			{
				out_aux_obs_cum_all[varIter.index_it_coef] *= in_one_over_ind_lik;
				in_out_aux_obs_cum_all_ind[varIter.index_it_coef]=1;
			}
					
		}
						
    }
};
