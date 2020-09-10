#ifndef _PROC_2_INPUT_H_INCLUDED_
#define _PROC_2_INPUT_H_INCLUDED_

#include <vector>
#include "mex.h"

struct prok2Input
{
	prok2Input(const mxArray * const *prhs)
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
        beta = &delta[3]; /* pointer to the vector of parameters for the observables */
        alpha = beta+d_beta; /* pointer to the vector of parameters for the unobservables */
        sigma = alpha+d_alpha; /* pointer to the vector of parameters for the variances of the idiosyncratic shocks */
		
		/* 5. Parameter Location */
		double* kmat_1 = mxGetPr(prhs[4]); /* auxiliary paramater description input */
		unsigned kmat_1_size;
		kmat_1_size = mxGetM(prhs[4]);
		std::copy(kmat_1, kmat_1 + kmat_1_size, std::back_inserter(kmat)); /* convert to unsigned integegers */		
		SVar1=kmat[0]; /* number of all variables in the model (same variable in two periods - counted as two variables */
        indFirCoefOb=&kmat[1]; /*index of location to first parameter for the observables */
		indFirCoefUnob = indFirCoefOb+SVar1; /*index of location to first parameter for the factors */
		indFirCoefIds = indFirCoefUnob+SVar1; /*index of location to first paramter for the idiosyncratic shocks */
		
		/* 6. Random Draws  - factors */
        double* rrmat_1 = mxGetPr(prhs[5]); /* vector with information on the files with draws */
        drawFileCount = rrmat_1[0]; /* number of files with draws */
		for(unsigned i = 0; i < drawFileCount; ++i)
		{
			drawFiles.push_back(mxGetPr(prhs[7+i])); /* concatenating the draws from the separate files */
		}
		unsigned rrmat_1_size;		
		rrmat_1_size = mxGetM(prhs[5]);
        std::copy(rrmat_1, rrmat_1 + rrmat_1_size, std::back_inserter(rrmat)); /* convert to unsigned integers */
		numDraws = rrmat[1]; /* number of draws */
        numVarDrawn = rrmat[2]; /*number of variables generated in one draw */
        drawsCount = rrmat[3]; /*number of draws in one file */
        indDrawPerson = &rrmat[4]; /* indexes where the generated factors start for each person in each draw */
		
		
		/* 7. Random Draws  - missing variables in categorical outcomes */
        double* mrmat_1 = mxGetPr(prhs[6]); /* vector with information on the files with draws for missing data */
		drawFileCountMiss = mrmat_1[0]; /* number of files with draws - missing variables*/ 
		for(unsigned ii = 0; ii < drawFileCountMiss; ++ii)
		{
			drawFilesMiss.push_back(mxGetPr(prhs[7+drawFileCount+ii])); /* concatenating the draws from the separate files */
		}
		unsigned mrmat_1_size;
		mrmat_1_size = mxGetM(prhs[6]);		
        std::copy(mrmat_1, mrmat_1 + mrmat_1_size, std::back_inserter(mrmat)); /* convert to unsigned integers */ 
		numDrawsMiss = mrmat[1]; /* number of draws - missing variables*/
        //numVarDrawnMiss = mrmat[2]; /*number of variables generated in one draw for missing variables*/
        drawsCountMiss = mrmat[2]; /*number of draws in one file - missing variables */
        indDrawPersonMiss = &mrmat[3]; /* indexes where the generated factors start for each person in each draw - missing variables*/
        
		/* 8. Constants */
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
	double* beta;
	double* alpha;
	double* sigma;
	
	std::vector<unsigned>kmat;	
	unsigned SVar1;
    unsigned* indFirCoefOb;
	unsigned* indFirCoefUnob;
	unsigned* indFirCoefIds;
	
	unsigned drawFileCount;
	std::vector<double*> drawFiles; 
	std::vector<unsigned>rrmat;
	unsigned numDraws;
	unsigned numVarDrawn; 
	unsigned drawsCount;
	unsigned* indDrawPerson; 
	
	unsigned drawFileCountMiss;
	std::vector<double*> drawFilesMiss;
	std::vector<unsigned>mrmat;
	unsigned numDrawsMiss;
	//unsigned numVarDrawnMiss;
	unsigned drawsCountMiss; 
	unsigned* indDrawPersonMiss; 
	
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
#endif //_PROC_2_INPUT_H_INCLUDED_
