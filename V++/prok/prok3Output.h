#ifndef _PROK_3_OUTPUT_H_INCLUDED_
#define _PROK_3_OUTPUT_H_INCLUDED_

#include <vector>
#include <algorithm>

struct prok3Output
{
	prok3Output(const prok3Input& inputs, mxArray *plhs[], prok3Output& outputs)
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
		
		plhs[4] = mxCreateDoubleMatrix(inputs.d_omega,1,mxREAL); /* vector of derivatives for the variances of idiosyncratic shocks*/
		matrix_wts = mxGetPr(plhs[4]);
		fillWithZeroes(matrix_wts, inputs.d_omega);
		
		plhs[5] = mxCreateDoubleMatrix(inputs.d_ksi,1,mxREAL); /* vector of derivatives for the variances of idiosyncratic shocks*/
		matrix_pts = mxGetPr(plhs[5]);
		fillWithZeroes(matrix_pts, inputs.d_ksi);
		
		plhs[6] = mxCreateDoubleMatrix(inputs.d_mean,1,mxREAL); /* vector of derivatives for the means of the factors*/
		matrix_mns = mxGetPr(plhs[6]);
		fillWithZeroes(matrix_mns, inputs.d_mean);
		
		plhs[7] = mxCreateDoubleMatrix(inputs.d_var,1,mxREAL); /* vector of derivatives for the variances of the factors*/
		matrix_vars = mxGetPr(plhs[7]);
		fillWithZeroes(matrix_vars, inputs.d_var);
       
	}

	double* logl;
	double* matrix_obs;
	double* matrix_unobs;
    double* matrix_ids; 
	double* matrix_wts; 
	double* matrix_pts; 
	double* matrix_mns; 
	double* matrix_vars; 
    
    
private:
	void fillWithZeroes(double* array, unsigned elementCount)
	{
		std::fill(array, array + elementCount, 0.0);
	}
};

#endif //_PROK_3_OUTPUT_H_INCLUDED_
