#ifndef _PROC_3_INPUT_H_INCLUDED_
#define _PROC_3_INPUT_H_INCLUDED_

#include <vector>
#include "mex.h"

struct prok3Input
{
	prok3Input(const mxArray * const *prhs)
	{
		/* Getting pointers to inputs */
		
		/* 1. Data */
		xxmat = mxGetPr(prhs[0]); /* matrix of regressors */
        xxmat_size = mxGetM(prhs[0]);
		
		/* 2. Data description */
		double* dmat_1 = mxGetPr(prhs[1]); /* auxiliary data structure input for model description */
		unsigned dmat_1_size;
		dmat_1_size = mxGetM(prhs[1]);
		std::copy(dmat_1, dmat_1 + dmat_1_size, std::back_inserter(dmat)); /* convert to unsigned integegers */
		N = dmat[0]; /* number of individiuals in the data */
		NA = dmat[1]; /*pointer to the first observation considered */
		NB = dmat[2]; /*pointer to the last observation considered */
        VN = dmat[3]; /* total number of variables in the data set for all individuals */
		MNG = dmat[4]; /*maximum number of groups of equations with non-zero covariance per individual */
		NG = &dmat[5]; /* Number of groups of equations with non-zero covariances per individual */
		numEqG = NG + N; /* Number of equations in each of the above group */
		numFacG = numEqG + N*MNG; /*Number of factors in each of the above groups */
		numRepG = numFacG + N*MNG; /* Number of replications of the covariance group */
		varPerIndividual = numRepG + N*MNG; /*Number of total variables per individual */
		rowVarIndex = varPerIndividual + N; /* pointer to a vector with indexes for the rows where the data for a particular person starts in indVarData and varId */
		indVarData = rowVarIndex + N; /* pointer to a vector with indexes for the starting point in data matrices where the data for a particual person starts in that equation */
		varId=indVarData+VN; /*pointer to a vector with the identity of the variable for which there is data*/
		KG = varId + VN; /* pointer to a vector with the maximum number of levels of missing variables */
		MEG = KG + N; /*pointer to a vector with the maximum number of variables in a covariance group */
		MFG = MEG + N; /*pointer to a vector with the maximum number of factors in a covariance group */
		MRG = MFG + N; /*pointer to a vector with the maximum number of replications of a covariance group */
		
		/* 3. Model */
        double* mmat_1 = mxGetPr(prhs[2]); /* auxiliary data structure input for model description */
		unsigned mmat_1_size;
		mmat_1_size = mxGetM(prhs[2]);
		std::copy(mmat_1, mmat_1 + mmat_1_size, std::back_inserter(mmat)); /* convert to unsigned integegers */
        
		SVar = mmat[0]; /* number of all variables in the model (same variable in two periods - counted as two variables */
        SVarOut = mmat[1]; /* number of values  derived from the outcome variables */
        maxInclOutc = mmat[2]; /* max number of outcomes in which a dependent variable can be a regressor*/
		maxNumFa =  mmat[3]; /* max number of factors */
		
		uniqueVarId = &mmat[4]; /*pointer to the vector with the unique identifier for the variables - considering categorical variables */
        numOutVarM1 = uniqueVarId + SVar; /* number cells needed for the values of the outcome variable minus 1 */
		numRegr = numOutVarM1 + SVar; /*number of regressors */
		
		numFa = numRegr + SVar; /* number of unobservable factors */
		factorId = numFa + SVar; /*indentity of factors */
		
		missVar = factorId+SVar*maxNumFa; /* location of the info about being missing - within the data for the variable */
		modTypeVarId = missVar + SVar; /* location of the info about modified type - within the data for the variable */
		covId = modTypeVarId + SVar; /* location of the info about covariance group ID - within the data for the variable */
		auxCov = covId + SVar; /* location of the data about rows (available variables) and columns (missing variables) for covariance groups - within the data for the variable */
		indRegr = auxCov + SVar; /*index where the regressors start*/
		numInclOutc = indRegr + SVar; /* location of the data about the number of outcome variables in which the variable is a regressor - within the data for the variable */
		indInclOutc = numInclOutc + SVar; /*location of the information for the placement of the dependent variables in which the variable is a regressor in the data set */ 
		indInclOutcReg = indInclOutc + SVar; /*location of the dependent variables when the variable is a regressor - within the data for the variable */
		indInclOutcTyp = indInclOutcReg + SVar; /*location of the information about the type of dependent variable as a regressor (interaction or not) - within the data for the variable */
		numMissRegDr = indInclOutcTyp + SVar; /* location of data for the number of iteration-specific missing variavles - within the data for the variable */
		locMissRegDr = numMissRegDr + SVar; /* location of data for the relative position of the missing iteration specific variables within the data for the variable */
		
		/* 4. Parameters */
		delta = mxGetPr(prhs[3]); /* vector of paramaters */
        d_beta = delta[0]; /* dimensions of the vector of parameters for the observables - only over those in maximization*/ 
        d_alpha = delta[1]; /* dimensions of the vector of parameters for the unobservables - only over those in maximization*/
        d_sigma = delta[2]; /* dimensions of the vector of parameters for the variances of the idiosyncratic shocks - all*/
		d_omega = delta[3]; /*dimensions of the vector of parameters for the weights of the discrete factors */
		d_ksi = delta[4]; /*dimensions of the vector of parameters for the points of the discrete factors */
		d_mean = delta[5]; /*dimensions of the vector of parameters for the means of the normal and mixture distribution*/
		d_var = delta[6]; /*dimensions of the vector of parameters for the variances of the normal and mixture distribution */
        beta = &delta[7]; /* pointer to the vector of parameters for the observables */
        alpha = beta+d_beta; /* pointer to the vector of parameters for the unobservables */
        sigma = alpha+d_alpha; /* pointer to the vector of parameters for the variances of the idiosyncratic shocks */
		omega = sigma + d_sigma; /* pointer to the vector of parameters for the weights of the discrete factors */
		ksi = omega + d_omega; /* pointer to the vector of parameters for the points of the discrete factors */
		meanz = ksi + d_ksi; /* pointer to the vector of parameters for the means of the normal and mixture distributed factors */
		varz = meanz + d_mean; /* pointer to the vector of parameters for the variances of the normal and mixture distributed factors*/
		
		/* 5. Parameter Location */
		double* kmat_1 = mxGetPr(prhs[4]); /* auxiliary paramater description input */
		unsigned kmat_1_size;
		kmat_1_size = mxGetM(prhs[4]);
		std::copy(kmat_1, kmat_1 + kmat_1_size, std::back_inserter(kmat)); /* convert to unsigned integegers */		
		SVar1=kmat[0]; /* number of all variables in the model (same variable in two periods - counted as two variables */
        indFirCoefOb=&kmat[1]; /*index of location to first parameter for the observables */
		indFirCoefUnob = indFirCoefOb+SVar1; /*index of location to first parameter for the factors */
		indFirCoefIds = indFirCoefUnob+SVar1; /*index of location to first paramter for the idiosyncratic shocks */
		indFirCoefWgts = indFirCoefIds+SVar1; /*index of location to first paramter for the weights of the discrete factors */
		indFirCoefPts = indFirCoefWgts+maxNumFa; /*index of location to first paramter for the points of the discrete factors */
		indFirCoefMns = indFirCoefPts+maxNumFa; /*index of location to first paramter for the points of the means of mixture or normal distribution */
		indFirCoefVars = indFirCoefMns+maxNumFa; /*index of location to first paramter for the points of the the variances of mixture or normal distribution */
		
		/* 6. Info on Discrete Factors */
		double* ffmat = mxGetPr(prhs[5]); /* auxiliary data structure input for discrete factors */
		unsigned ffmat_size;
		ffmat_size = mxGetM(prhs[5]);
		std::copy(ffmat, ffmat + ffmat_size, std::back_inserter(fmat_1)); /* convert to unsigned integegers */
		
		maxFPoints = fmat_1[0]; /*max number of points for a discrete factors */ 
		maxEPoints = fmat_1[1]; /*max number of points for a discrete factors */
		numTPoints = fmat_1[2]; /*total number of points for a discrete factors */ 
		indFirWgts = &fmat_1[3]; /*auxilary for weights */
		indFirPts = indFirWgts + maxNumFa; /*auxilary for points */
		if (maxNumFa>0){
			fmat = indFirPts + maxNumFa; /*number of points for each discrete factor */
			ftyp = fmat + maxNumFa; /*type of each discrete factor */
			feva = ftyp + maxNumFa; /*number of evaluations */
		} else {
			fmat = indFirWgts+2;
			ftyp = indFirWgts+3;
			feva = indFirWgts+4;
		}
		ggmat = mxGetPr(prhs[6]);
		hhmat = mxGetPr(prhs[7]);
		/* 7. Constants */
		probMax = 0.;
		probMin = -36.;
		probMinMin = -360000000.;
		probMaxMax = 700.;
		auxInf = 700.;
	
	}
	
	double* xxmat;
    unsigned xxmat_size;
	
	std::vector<unsigned>dmat;
	unsigned N;
	unsigned NA;
	unsigned NB;
    unsigned VN;
	unsigned MNG;
	unsigned* NG;
	unsigned* numEqG;
	unsigned* numFacG;
	unsigned* numRepG;
	unsigned* varPerIndividual;
	unsigned* rowVarIndex;
	unsigned* indVarData;
	unsigned* varId;
	unsigned* KG;
	unsigned* MEG;
	unsigned* MFG;
	unsigned* MRG;
	
	std::vector<unsigned>mmat;
	unsigned SVar;
	unsigned SVarOut;
	unsigned maxInclOutc; 
	unsigned maxNumFa;
	
	unsigned* uniqueVarId;
	unsigned* numOutVarM1;
	unsigned* numRegr;
	unsigned* numFa;
	unsigned* factorId;
	
	unsigned* missVar;
	unsigned* modTypeVarId;
	unsigned* covId;
	unsigned* auxCov;
	unsigned* indRegr;
	unsigned* numInclOutc;
	unsigned* indInclOutc;
	unsigned* indInclOutcReg;
	unsigned* indInclOutcTyp;
	unsigned* numMissRegDr;
	unsigned* locMissRegDr;
	
	double* delta;
	unsigned d_beta;
	unsigned d_alpha;
	unsigned d_sigma;
	unsigned d_omega;
	unsigned d_ksi;
	unsigned d_mean;
	unsigned d_var;
	double* beta;
	double* alpha;
	double* sigma;
	double* omega;
	double* ksi;
	double* meanz;
	double* varz;
	
	std::vector<unsigned>kmat;	
	unsigned SVar1;
    unsigned* indFirCoefOb;
	unsigned* indFirCoefUnob;
	unsigned* indFirCoefIds;
	unsigned* indFirCoefWgts;
	unsigned* indFirCoefPts;
	unsigned* indFirCoefMns;
	unsigned* indFirCoefVars;
	
	std::vector<unsigned>fmat_1;
	unsigned maxFPoints; 
	unsigned maxEPoints; 
	unsigned numTPoints;
	unsigned* indFirWgts;
	unsigned* indFirPts;
	unsigned* fmat;
	unsigned* ftyp;
	unsigned* feva;
	
	
	double* ggmat;
	double* hhmat;
	
	
	double probMax;
    double probMin;
    double probMinMin;
    double probMaxMax;
    double auxInf;

};
	

/* Notes:
 Modified types - recorded in the data with locations described in the model description:
5 - discrete, non-missing continuous which does not contain any covariance missing regressors
4 - continuous, auxiliary, comprised only of observed
3 - continuous, auxiliary, comprised of observed and factors
2 - continuous, (if missing - not eventually in a discrete outcome) (if non-missing - containing covariance missing regressors)
1 - continuous, missing, ending in a discrete outcome
The data (xxmat):
1. Take one person
2. Take one equation
3. Inside - outcome variable; [type dependent variable] (missing); modified type; auxiliary variable for covariance missing; id of the covariance group it is in,
 [number missing regressors, relative location of the missing regressors (max potential number missing regressors cells), index in the data for the missing regressors;]
  regressors, location of outcomes if variable auxiliary or missing; number of missing regressors functions of the factors; id of the equations in which those regressors are dependent variables; 
  location of those regressors among the other ones; auxilary regressors for interaction regressors; 
 4. Do for all equation for a given person
 5. Do for all people 
 6. For draws - one draw with factors for one person; in each file all people; finish with person 1, then person 2 in the file ...*/
#endif //_PROC_3_INPUT_H_INCLUDED_
