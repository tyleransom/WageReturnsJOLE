#ifndef _PROK_2_AUX_H_INCLUDED_
#define _PROK_2_AUX_H_INCLUDED_
#include "prok2Input.h"
#include <vector>
#include "mex.h"

// File with auxiliary functions
struct variableMainAttr /* getting the attributes of the variables */
{
	variableMainAttr (const struct prok2Input* inputs, unsigned v_index)
	{
	
		vdata = inputs->indVarData[v_index]; /* point where data for that individual starts for the particular variable */
		ivar = inputs->varId[v_index]; /* variable identity */
		uid = inputs->uniqueVarId[ivar];
		num_alt_m1 =  inputs->numOutVarM1[ivar];
		type = inputs->xxmat[vdata+inputs->modTypeVarId[ivar]];
		miss = (inputs->xxmat[vdata+inputs->missVar[ivar]] > 0.5);
		nfac = inputs->numFa[ivar];
		nregr = inputs->numRegr[ivar];
	}
	
	unsigned vdata;
	unsigned ivar;
	unsigned uid;
	unsigned num_alt_m1;
	unsigned type;
	bool miss;
	unsigned nfac;
	unsigned nregr;
};

struct variableCovAttr /* getting the attributes of the variable related to the covariance group */
{
	variableCovAttr (const struct prok2Input* inputs, unsigned v_data,unsigned i_var)
	{
		auxCov = inputs->xxmat[v_data+inputs->auxCov[i_var]]; /*row number for the covariance matrix*/
		covId = inputs->xxmat[v_data+inputs->covId[i_var]]-1;
	}
	
	size_t auxCov;
	size_t covId;
};



struct variableLIterVAttr /* getting the attributes of the variable related to the included (as regressors ) missing iteration-specific variables */
{
	variableLIterVAttr (const struct prok2Input* inputs, unsigned v_data,unsigned i_var,unsigned ii,unsigned i_obs, unsigned i_coeff)
	{
		unsigned lmrd = v_data+inputs->locMissRegDr[i_var]+ii; /* index location first relative location of missing regressor with variable part */
		unsigned locRegr = inputs->xxmat[lmrd];
		index_it_regr = i_obs + locRegr;
		index_it_coef = i_coeff + locRegr;
	}
	
	unsigned index_it_regr;
	unsigned index_it_coef;
	
};
	

struct variableInclVAttrPlus /* getting attributes of the variable in which this outcome is a regressor */
{
	variableInclVAttrPlus (const struct prok2Input* inputs, unsigned v_data,unsigned i_var,unsigned nin)
	{
		unsigned outpos = inputs->indInclOutcReg[i_var]+nin; /*index showing the location of the data for position as a regressor */
		unsigned bk_pos = v_data + outpos; /* point where data for the outcome in the data starts */
		unsigned outpo = inputs->xxmat[bk_pos]; /* position as a regressor */
		unsigned outci = inputs->indInclOutc[i_var]+nin; /*index showing the location of the data for the outcome in the data itself */
		unsigned bk_loc = v_data + outci; /* point where data for the outcome in the data starts */
		unsigned bk_index = inputs->xxmat[bk_loc]; /* variable index of the outcome */	
		vdata = inputs->indVarData[bk_index]; /* point where data for that individual starts for the particular variable as an outcome */
		ivar = inputs->varId[bk_index]; /* variable identity of the outcome*/
		unsigned ireg = inputs->indRegr[ivar]; /*index to the first column from the data on regressors for the outcome */       
		unsigned iobs = vdata + ireg; /*index where observables start for that person for thar variable as an outcome*/
		unsigned ifco = inputs->indFirCoefOb[ivar]; 
		index_regr = iobs + outpo;
		index_coef = ifco + outpo;
		uid = inputs->uniqueVarId[ivar];
		num_alt_m1 =  inputs->numOutVarM1[ivar];
		type = inputs->xxmat[vdata+inputs->modTypeVarId[ivar]];
		miss = (inputs->xxmat[vdata+inputs->missVar[ivar]] > 0.5);
		nfac = inputs->numFa[ivar];
		nregr = inputs->numRegr[ivar];
		
	}
	
	unsigned vdata;
	unsigned ivar;
	unsigned index_regr;
	unsigned index_coef;
	unsigned uid;
	unsigned num_alt_m1;
	unsigned type;
	bool miss;
	unsigned nfac;
	unsigned nregr;

};

unsigned variableObsRegrAttr (const struct prok2Input* inputs, unsigned v_data,unsigned i_var) /* getting the index of the first regressors */
{     
    unsigned iobs = v_data+inputs->indRegr[i_var];
	return iobs;
};


unsigned variableNIterVAttr (const struct prok2Input* inputs, unsigned v_data,unsigned i_var) /* getting the number of iteration-specific missing variables */
{

	unsigned nmrd = inputs->xxmat[v_data + inputs->numMissRegDr[i_var]];
	return nmrd;
};


unsigned variableNInclAttr (const struct prok2Input* inputs, unsigned v_data,unsigned i_var) /* getting the number of variables in which the outcome variable is a regressor */
{
	unsigned noin = inputs->xxmat[v_data+inputs->numInclOutc[i_var]];
	return noin;
};


unsigned variableInclVAttr (const struct prok2Input* inputs, unsigned v_data,unsigned i_var,unsigned nin) /* getting the index of the location in which the outcome variable is a regressor */
{
		unsigned outpos = inputs->indInclOutcReg[i_var]+nin; /*index showing the location of the data for position as a regressor */
		unsigned bk_pos = v_data + outpos; /* point where data for the outcome in the data starts */
		unsigned outpo = inputs->xxmat[bk_pos]; /* position as a regressor */
		unsigned outci = inputs->indInclOutc[i_var]+nin; /*index showing the location of the data for the outcome in the data itself */
		unsigned bk_loc = v_data + outci; /* point where data for the outcome in the data starts */
		unsigned bk_index = inputs->xxmat[bk_loc]; /* variable index of the outcome */	
		unsigned vdata = inputs->indVarData[bk_index]; /* point where data for that individual starts for the particular variable as an outcome */
		unsigned ivar = inputs->varId[bk_index]; /* variable identity of the outcome*/
		unsigned ireg = inputs->indRegr[ivar]; /*index to the first column from the data on regressors for the outcome */       
		unsigned iobs = vdata + ireg; /*index where observables start for that person for thar variable as an outcome*/

		unsigned index_regr = iobs + outpo;
		
		return index_regr;
};

#endif //_PROC_2_AUX_H_INCLUDED_
