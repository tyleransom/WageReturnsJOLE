void constructResidual(const struct prok2Input* inputs,
										const struct variableMainAttr& vMA, 
										std::vector<double>& out_aux_obs_lin,
										std::vector<double>& in_out_xxmat_aux_m)
{										
	unsigned ifco = inputs->indFirCoefOb[vMA.ivar]; /*index first param. - observables */
	unsigned iobs = variableObsRegrAttr(inputs, vMA.vdata, vMA.ivar); /* starting index of the regressors */
	double approx_perm = in_out_xxmat_aux_m[vMA.vdata]; /* approximating the permanent component - only observables */       
	for (unsigned nr=0; nr < vMA.nregr; ++nr)
	{
		approx_perm -= in_out_xxmat_aux_m[iobs+nr]*inputs->beta[ifco+nr];  
	}
			
	out_aux_obs_lin[vMA.uid]=approx_perm; 
};


void constructPermMissCont(const struct prok2Input* inputs,
										const struct variableMainAttr& vMA, 
										std::vector<double>& in_out_xxmat_aux_m)
{
	double approx_perm = 0.; /* only observables */
			
	unsigned ifco = inputs->indFirCoefOb[vMA.ivar]; /*index first param. - observables */
	unsigned iobs = variableObsRegrAttr(inputs, vMA.vdata, vMA.ivar); /* starting index of the regressors */
					
	for (unsigned nr=0; nr < vMA.nregr; ++nr)
	{
		approx_perm += in_out_xxmat_aux_m[iobs+nr]*inputs->beta[ifco+nr]; 
	}
					
	unsigned noin = variableNInclAttr (inputs, vMA.vdata, vMA.ivar);
					
	for (unsigned nin=0; nin<noin; ++nin)
	{
		unsigned indexregr = variableInclVAttr (inputs, vMA.vdata, vMA.ivar, nin);
		in_out_xxmat_aux_m[indexregr] = approx_perm*inputs->xxmat[indexregr]; /*filling in the value */
	}
};

void constructPermMissDisc(const struct prok2Input* inputs,
										const struct variableMainAttr& vMA, 
										std::vector<double>& out_aux_obs_lin,
										std::vector<double>& in_out_xxmat_aux_m)
{										
	unsigned ifco = inputs->indFirCoefOb[vMA.ivar]; /*index first param. - observables */
	unsigned iobs = variableObsRegrAttr(inputs, vMA.vdata, vMA.ivar); /* starting index of the regressors */
				
	for(unsigned jv=0;jv<vMA.num_alt_m1;++jv) /* looping over alternatives */
    {
		unsigned ifjco = ifco+jv*vMA.nregr; /*index first param. - observables */                        
		double approx_perm = 0.; /* approximating the permanent component - only observables */
                            
		for (unsigned nrk=0; nrk < vMA.nregr; ++nrk)
		{
			approx_perm += in_out_xxmat_aux_m[iobs+nrk]*inputs->beta[ifjco+nrk];  
		}
					
		out_aux_obs_lin[vMA.uid+jv]=approx_perm;
	}
};
