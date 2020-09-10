void conmpDisc(const struct prok3Input* inputs,
										const struct variableMainAttr& vMA, 
										std::vector<double>& out_aux_obs_lin_it,
										std::vector<double>& in_out_xxmat_aux_m,
										std::vector<double>& in_rmat,
										unsigned in_rdrawn,
										double& in_out_sum_log_num_disc,
										double& in_out_sum_log_den_disc,
										std::vector<double>& out_aux_obs_iter,
										std::vector<double>& out_aux_unobs_iter,
										std::vector<double>& out_aux_pts_iter,
										std::vector<double>& out_aux_mean_iter,
										std::vector<double>& out_aux_var_iter,
										std::vector<double>& out_aux_obs_iter_all,
										std::vector<double>& in_aux_cont_iter,
										std::vector<unsigned>& in_bink,
										std::vector<unsigned>& in_gink,
										std::vector<unsigned>& in_eink)
										
{
    double num = 0.; /* numerator */
    double den = 1.; /* denominator */
    double maxexp = inputs->probMin; /* highest value to solve the infinity issue */
    std::vector<double> lin_proj(vMA.num_alt_m1); /* linear projection of observables and unobservables for all alternatives minus 1 */
    std::vector<double> exp_lin_proj(vMA.num_alt_m1); /* exponential of linear projection of observables and unobservables for all alternatives minus 1 */
	unsigned ifcu = inputs->indFirCoefUnob[vMA.ivar]; /*index first param. - unobservables */
	unsigned ifco = inputs->indFirCoefOb[vMA.ivar]; /*index first param. - observables */
	
    for(unsigned j=0;j<vMA.num_alt_m1;++j) /* looping over alternatives */
    {
        lin_proj[j] = out_aux_obs_lin_it[vMA.uid+j];
		unsigned ifcuj = ifcu+j*vMA.nfac; /* number of coeffecients already used for previous alternatives for unobservables */
                            
		for(unsigned ft=0;ft<vMA.nfac;++ft) /* looping over factors */
		{
			unsigned fac_id=inputs->factorId[ft*inputs->SVar+vMA.ivar]; /*factor id */
			lin_proj[j] += inputs->alpha[ifcuj+ft]*in_rmat[in_rdrawn+fac_id]; 
		}
                            
        maxexp = std::max(maxexp,lin_proj[j]);
        exp_lin_proj[j] = exp(lin_proj[j]);           
        den += exp_lin_proj[j];
        num += lin_proj[j]*in_out_xxmat_aux_m[vMA.vdata+j];                               
    }                                 

    if (maxexp>=inputs->auxInf) {  /* making sure there is no plus infinity */
        double auxInf_adj = inputs->auxInf - maxexp; /*adjustment addend */
        den = exp(auxInf_adj);
        num = in_out_xxmat_aux_m[vMA.vdata+vMA.num_alt_m1]*auxInf_adj;
                            
        for(unsigned jk=0;jk<vMA.num_alt_m1;++jk) /* looping over alternatives with the adjustments */
        {
            lin_proj[jk] += auxInf_adj;
            exp_lin_proj[jk] = exp(lin_proj[jk]);          
            den += exp_lin_proj[jk];
            num += lin_proj[jk]*in_out_xxmat_aux_m[vMA.vdata+jk];          
        }
                                
    }
                            
    in_out_sum_log_num_disc += num; 
    in_out_sum_log_den_disc += log(den); 
		                    	
    for(unsigned l = 0;l<vMA.num_alt_m1;++l) /* forming derivatives without the multiplication with the overall probility */
    {   
        double aux_discr = in_out_xxmat_aux_m[vMA.vdata+l]-(exp_lin_proj[l]/den);                                                                                                                   
        out_aux_obs_iter[vMA.uid+l] += aux_discr; /*observables */						
		unsigned ifcul=ifcu+l*vMA.nfac;
							
		for(unsigned ftt=0;ftt<vMA.nfac;++ftt) /* looping over factors */
		{
			unsigned fac_idt=inputs->factorId[ftt*inputs->SVar+vMA.ivar]; /*factor id */
			out_aux_unobs_iter[ifcul+ftt] += aux_discr*in_rmat[in_rdrawn+fac_idt];
			////mexPrintf("in_rmat[%d+%d]] is %f\n",in_rdrawn,fac_idt,in_rmat[in_rdrawn+fac_idt]);
			//mexPrintf("inputs->ftyp[%d] is %d\n",fac_idt,inputs->ftyp[fac_idt]);
			if (inputs->ftyp[fac_idt]==2){
				out_aux_pts_iter[inputs->indFirPts[fac_idt]+in_bink[fac_idt]] += aux_discr*inputs->alpha[ifcul+ftt];
				//mexPrintf("out_aux_pts_iter[inputs->indFirPts[fac_idt]+in_bink[fac_idt]] %d %f\n",inputs->indFirPts[fac_idt]+in_bink[fac_idt],out_aux_pts_iter[inputs->indFirPts[fac_idt]+in_bink[fac_idt]]);
			}
			if (inputs->ftyp[fac_idt]>2){
				////mexPrintf("inputs->indFirCoefMns[%d] is %d\n",fac_idt,inputs->indFirCoefMns[fac_idt]);
				////mexPrintf("inputs->indFirCoefVars[%d] is %d\n",fac_idt,inputs->indFirCoefVars[fac_idt]);
				////mexPrintf("in_gink[%d] is %d\n",fac_idt,in_gink[fac_idt]);
				////mexPrintf("in_eink[%d] is %d\n",fac_idt,in_eink[fac_idt]);
				////mexPrintf("inputs->ggmat[%d] is %f\n",inputs->indFirWgts[fac_idt]+in_eink[fac_idt],inputs->ggmat[inputs->indFirWgts[fac_idt]+in_eink[fac_idt]]);
				out_aux_mean_iter[inputs->indFirCoefMns[fac_idt]+in_gink[fac_idt]] += aux_discr*inputs->alpha[ifcul+ftt];
				out_aux_var_iter[inputs->indFirCoefVars[fac_idt]+in_gink[fac_idt]] += aux_discr*inputs->alpha[ifcul+ftt]*inputs->ggmat[inputs->indFirWgts[fac_idt]+in_eink[fac_idt]];
			}
		}
		
		unsigned nmrd = variableNIterVAttr (inputs, vMA.vdata,vMA.ivar);
		
		unsigned ifcol = ifco+l*vMA.nregr;
		for(unsigned kft=0;kft<nmrd;++kft) /* looping over missing regressors with variable parts */
		{
			unsigned iobs = variableObsRegrAttr(inputs, vMA.vdata, vMA.ivar); /* starting index of the regressors */
			variableLIterVAttr varIter(inputs, vMA.vdata,vMA.ivar,kft,iobs, ifcol);
			out_aux_obs_iter_all[varIter.index_it_coef] += aux_discr*in_aux_cont_iter[varIter.index_it_regr];
		}

	}
	
};
double constructResidualIter(const struct prok3Input* inputs,
										const struct variableMainAttr& vMA, 
										const std::vector<double>& in_aux_obs_lin_it,
										std::vector<double>& in_rmat,
										unsigned in_rdrawn)
										
{
	double out_aux_cont=in_aux_obs_lin_it[vMA.uid];
	unsigned ifcu = inputs->indFirCoefUnob[vMA.ivar]; /*index first param. - unobservables */
	for(unsigned ftp=0;ftp<vMA.nfac;++ftp) /* looping over factors */
	{
		unsigned fac_idp =inputs->factorId[ftp*inputs->SVar+vMA.ivar]; /*factor id */
		out_aux_cont -= inputs->alpha[ifcu+ftp]*in_rmat[in_rdrawn+fac_idp]; 
	}
	return out_aux_cont;
};

void constructIterMissCont(const struct prok3Input* inputs,
										const struct variableMainAttr& vMA, 
										std::vector<double>& out_aux_obs_lin_it,
										std::vector<double>& in_rmat,
										unsigned in_rdrawn,
										std::vector<double>& in_out_aux_cont_it_mult,
										std::vector<double>& out_aux_cont_iter)
										
{
	unsigned ifcu = inputs->indFirCoefUnob[vMA.ivar]; /*index first param. - unobservables */
	unsigned ifv = inputs->indFirCoefIds[vMA.ivar];  /*index first param. - variances */
	double approx_cont0 = in_out_aux_cont_it_mult[vMA.uid]; /* only common factors */                            	
	
	for (unsigned nr1=0; nr1 < vMA.nfac; ++nr1) /* looping over factors */
	{	
		unsigned fac_ipd1=inputs->factorId[nr1*inputs->SVar+vMA.ivar]; /* factor id */
		approx_cont0 += inputs->alpha[ifcu+nr1]*in_rmat[in_rdrawn+fac_ipd1]; 
	}
							
	
	
	unsigned noin = variableNInclAttr (inputs, vMA.vdata, vMA.ivar); /* number of outcomes in which the variable is included at this level */	
					
	for (unsigned nin1=0; nin1<noin; ++nin1) /* looping over outcomes where the variable is used */
	{
		variableInclVAttrPlus inclVar(inputs, vMA.vdata,vMA.ivar,nin1);	
		double approx_cont = approx_cont0;
		approx_cont *= inputs->xxmat[inclVar.index_regr]; /*if interaction */
		out_aux_cont_iter[inclVar.index_regr] += approx_cont; /*filling in the value of the factors for the missing regressor */

		if (inclVar.type<6)
		{
			double approx_cont1 = inputs->beta[inclVar.index_coef]*approx_cont;
			out_aux_obs_lin_it[inclVar.uid] -= approx_cont1; /* adding the factor part from the missing variable - derivative*/
			in_out_aux_cont_it_mult[inclVar.uid] += approx_cont1; /* adding the factor part from the missing variable - likelihood*/
		} else {
								
			for(unsigned ja=0;ja<inclVar.num_alt_m1;++ja) /* looping over alternatives */
			{
				unsigned index_regr_j = inclVar.index_coef+ja*inclVar.nregr; /* number of coeffecients already used for previous alternatives for unobservables */
				double approx_cont1 = inputs->beta[index_regr_j]*approx_cont;
				out_aux_obs_lin_it[inclVar.uid+ja] += approx_cont1; /* adding the factor part from the missing variable -derivative */
				in_out_aux_cont_it_mult[inclVar.uid+ja] += approx_cont1; /* adding the factor part from the missing variable - likelihood*/
			}
					
		}
							
	}
};
