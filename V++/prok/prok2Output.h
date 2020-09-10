#ifndef _PROK_2_OUTPUT_H_INCLUDED_
#define _PROK_2_OUTPUT_H_INCLUDED_

#include <vector>
#include <algorithm>

struct prok2Output
{
	prok2Output(const prok2Input& inputs, mxArray *plhs[], prok2Output& outputs)
    {

		plhs[0] = mxCreateDoubleMatrix(1,1,mxREAL); /* vector of approximated log probabilites for each individual*/
		logl = mxGetPr(plhs[0]);
		logl[0]=0.;

		plhs[1] = mxCreateDoubleMatrix(inputs.d_beta,1,mxREAL); /* vector of derivatives for the coefficients of the observables for each individual*/
		matrix_obs = mxGetPr(plhs[1]);
		fillWithZeroes(matrix_obs, inputs.d_beta);
        
        plhs[2] = mxCreateDoubleMatrix(inputs.d_alpha,1,mxREAL); /* vector of derivatives for the coefficients of the observables for each individual*/
		matrix_unobs = mxGetPr(plhs[2]);
		fillWithZeroes(matrix_unobs, inputs.d_alpha);
        
        plhs[3] = mxCreateDoubleMatrix(inputs.d_sigma,1,mxREAL); /* vector of derivatives for the variances of idiosyncratic shocks*/
		matrix_ids = mxGetPr(plhs[3]);
		fillWithZeroes(matrix_ids, inputs.d_sigma); 
       
	}

	double* logl;
	double* matrix_obs;
	double* matrix_unobs;
    double* matrix_ids; 
    
    
private:
	void fillWithZeroes(double* array, unsigned elementCount)
	{
		std::fill(array, array + elementCount, 0.0);
	}
};

#endif //_PROK_2_OUTPUT_H_INCLUDED_
