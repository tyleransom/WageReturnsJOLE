void conmpAux(const struct prok3Input* inputs,
										const struct variableMainAttr& vMA, 
										std::vector<double>& out_aux_ids_iter,
										std::vector<double>& in_rmat,
										unsigned in_rdrawn,
										std::vector<double>& in_aux_obs_iter,
										std::vector<double>& out_aux_unobs_iter,
										std::vector<double>& out_aux_pts_iter,
										std::vector<double>& out_aux_mean_iter,
										std::vector<double>& out_aux_var_iter,
										std::vector<double>& out_aux_obs_iter_all,
										std::vector<double>& in_aux_cont_iter,
										unsigned ikg,
										std::vector<unsigned>& in_bink,
										std::vector<unsigned>& in_gink,
										std::vector<unsigned>& in_eink)
										
{
					unsigned nmrd = variableNIterVAttr (inputs, vMA.vdata,vMA.ivar);
					unsigned iobs = variableObsRegrAttr(inputs, vMA.vdata, vMA.ivar); /* starting index of the regressors */
					unsigned ifco = inputs->indFirCoefOb[vMA.ivar]; /*index first param. - observables */
					unsigned ifcu = inputs->indFirCoefUnob[vMA.ivar]; /*index first param. - unobservables - most recent */
					unsigned ifv = inputs->indFirCoefIds[vMA.ivar];  /*index first param. - variances */
					
					if(vMA.type<6 && (vMA.miss))
					{
						for(unsigned ftr=0;ftr<vMA.nfac;++ftr) /* looping over factors */
						{
							unsigned fac_idr=inputs->factorId[ftr*inputs->SVar+vMA.ivar]; /*factor id */
							out_aux_unobs_iter[ifcu+ftr] += in_aux_obs_iter[vMA.uid]*in_rmat[in_rdrawn+fac_idr];
							if (inputs->ftyp[fac_idr]==2){
								out_aux_pts_iter[inputs->indFirPts[fac_idr]+in_bink[fac_idr]] += in_aux_obs_iter[vMA.uid]*inputs->alpha[ifcu+ftr];
							}
							if (inputs->ftyp[fac_idr]>2){
								out_aux_mean_iter[inputs->indFirCoefMns[fac_idr]+in_gink[fac_idr]] += in_aux_obs_iter[vMA.uid]*inputs->alpha[ifcu+ftr];
								out_aux_var_iter[inputs->indFirCoefVars[fac_idr]+in_gink[fac_idr]] += in_aux_obs_iter[vMA.uid]*inputs->alpha[ifcu+ftr]*inputs->ggmat[inputs->indFirWgts[fac_idr]+in_eink[fac_idr]];
							}
						} 
                            
						for(unsigned kft1=0;kft1<nmrd;++kft1) /* looping over missing regressors with variable parts */
						{
							variableLIterVAttr varIter(inputs, vMA.vdata,vMA.ivar,kft1,iobs, ifco);
							out_aux_obs_iter_all[varIter.index_it_coef] += in_aux_obs_iter[vMA.uid]*in_aux_cont_iter[varIter.index_it_regr];
						}
					
					} 
					
					else if ((!vMA.miss) && (vMA.nfac>0 || nmrd>0 || vMA.type==1)) 
					{ 
						std::vector<double> multipkB(ikg,1.0); /* product of parameters for missing regressors */
						std::vector<unsigned> ivarB(ikg); /* indentity of missing regressors */
						std::vector<unsigned> vdataB(ikg); /* location of missing regressors */
						std::vector<unsigned> ninkB(ikg,0); /* number missing regressors per level - counter*/
					
						unsigned boutB = 1; /*counter for multipk */
						ivarB[0] = vMA.ivar; /* initializing identity of missing variable in the chain */
						vdataB[0] = vMA.vdata; /* initializing data storage info */
					
						while (boutB>0)
						{
							unsigned boutBM1 = boutB - 1;
							unsigned noinB = variableNInclAttr (inputs, vdataB[boutBM1], ivarB[boutBM1]); /* number of outcomes in which the variable is included at this level */
							unsigned ninB = ninkB[boutBM1]; /* counter of variables at this level of missingness */
							ninkB[boutBM1] = ninB+1;
						
							if (ninkB[boutBM1]>noinB) /* going back to previous level */
							{
								boutB--;
							
							} else{
							
								variableInclVAttrPlus inclVar(inputs, vdataB[boutBM1],ivarB[boutBM1],ninB);
								
								if (inclVar.type<6)
								{

									multipkB[boutB] = multipkB[boutBM1]*inputs->beta[inclVar.index_coef]*inputs->xxmat[inclVar.index_regr];
								
									if (inclVar.miss)
									{
										for(unsigned nf4=0;nf4<vMA.nfac;++nf4) /*looping over observables */
										{
											unsigned fac_idf=inputs->factorId[nf4*inputs->SVar+vMA.ivar]; /*factor id */
											out_aux_unobs_iter[ifcu+nf4] += in_aux_obs_iter[inclVar.uid]*in_rmat[in_rdrawn+fac_idf]*multipkB[boutB]; 
											if (inputs->ftyp[fac_idf]==2){
												out_aux_pts_iter[inputs->indFirPts[fac_idf]+in_bink[fac_idf]] += in_aux_obs_iter[inclVar.uid]*inputs->alpha[ifcu+nf4]*multipkB[boutB];
											}
											if (inputs->ftyp[fac_idf]>2){
												out_aux_mean_iter[inputs->indFirCoefMns[fac_idf]+in_gink[fac_idf]] += in_aux_obs_iter[inclVar.uid]*inputs->alpha[ifcu+nf4]*multipkB[boutB];
												out_aux_var_iter[inputs->indFirCoefVars[fac_idf]+in_gink[fac_idf]] += in_aux_obs_iter[inclVar.uid]*inputs->alpha[ifcu+nf4]*multipkB[boutB]*inputs->ggmat[inputs->indFirWgts[fac_idf]+in_eink[fac_idf]];
											}
										}
											
										
										if (nmrd>0)
										{
											for(unsigned kft41=0;kft41<nmrd;++kft41) /* looping over missing regressors with variable parts */
											{		
												variableLIterVAttr varIter(inputs, vMA.vdata,vMA.ivar,kft41,iobs, ifco);
												out_aux_obs_iter_all[varIter.index_it_coef] += in_aux_obs_iter[inclVar.uid]*in_aux_cont_iter[varIter.index_it_regr]*multipkB[boutB]; /* derivative for observable - missing and containing a missing variable */
											}
											
										}	
							
									}
								
									else if (boutB<ikg)
									{
										ivarB[boutB] = inclVar.ivar;
										vdataB[boutB] = inclVar.vdata;
										ninkB[boutB] = 0;
										boutB++; /* searching for non-missing variable */
									
									} 
							
								} else {	
								
									for(unsigned jbb=0;jbb<inclVar.num_alt_m1;++jbb) /* looping over alternatives */
									{
										
										unsigned uidjbb = inclVar.uid+jbb; /*unique index */
										double multip1j = multipkB[boutBM1]*inputs->beta[inclVar.index_coef+jbb*inclVar.nregr]*inputs->xxmat[inclVar.index_regr];
										
										
										for(unsigned nf4a=0;nf4a<vMA.nfac;++nf4a) /*looping over observables */
										{
											unsigned fac_idf1=inputs->factorId[nf4a*inputs->SVar+vMA.ivar]; /*factor id */
											out_aux_unobs_iter[ifcu+nf4a] += in_aux_obs_iter[uidjbb]*in_rmat[in_rdrawn+fac_idf1]*multip1j; 
											if (inputs->ftyp[fac_idf1]==2){
												out_aux_pts_iter[inputs->indFirPts[fac_idf1]+in_bink[fac_idf1]] += in_aux_obs_iter[uidjbb]*inputs->alpha[ifcu+nf4a]*multip1j;
											}
											if (inputs->ftyp[fac_idf1]>2){
												out_aux_mean_iter[inputs->indFirCoefMns[fac_idf1]+in_gink[fac_idf1]] += in_aux_obs_iter[uidjbb]*inputs->alpha[ifcu+nf4a]*multip1j;
												out_aux_var_iter[inputs->indFirCoefVars[fac_idf1]+in_gink[fac_idf1]] += in_aux_obs_iter[uidjbb]*inputs->alpha[ifcu+nf4a]*multip1j*inputs->ggmat[inputs->indFirWgts[fac_idf1]+in_eink[fac_idf1]];
											}
										}
										
										
										if (nmrd>0)
										{
											for(unsigned kft42=0;kft42<nmrd;++kft42) /* looping over missing regressors with variable parts */
											{		
												
					
												variableLIterVAttr varIter(inputs, vMA.vdata,vMA.ivar,kft42,iobs, ifco);
												out_aux_obs_iter_all[varIter.index_it_coef] += in_aux_obs_iter[uidjbb]*in_aux_cont_iter[varIter.index_it_regr]*multip1j; /* derivative for observable - missing and containing a missing variable */
											}
											
										}
										
									}
									
								}
					
							}
				
						}
										
					}
	
};
