#ifndef _MARG_OUTPUT_H_INCLUDED_
#define _MARG_OUTPUT_H_INCLUDED_

#include <vector>
#include <algorithm>

struct margOutput
{
	margOutput(const margInput& inputs, mxArray *plhs[], margOutput& outputs)
    {
		unsigned mea = inputs.sizeoutputFM;
		unsigned mei = inputs.sizeoutputFM*inputs.numindivM;
		unsigned mw = inputs.numDrawsM*inputs.numindivM;
		unsigned mmu = inputs.numindivM*inputs.maxNumFa;
		
		// unsigned mea = 1;
		// unsigned mei = 2;
		// unsigned mw = 3;
		// unsigned mmu = 4;
		
		plhs[0] = mxCreateDoubleMatrix(mea,1,mxREAL); /* vector of overall effects*/
		matrix_effectsAll = mxGetPr(plhs[0]);
		fillWithZeroes(matrix_effectsAll, mea);
		
		plhs[1] = mxCreateDoubleMatrix(mei,1,mxREAL); /* vector of overall effects for each individual*/
		matrix_effectsInd = mxGetPr(plhs[1]);
		fillWithZeroes(matrix_effectsInd, mei);

		plhs[2] = mxCreateDoubleMatrix(mw,1,mxREAL); /* vector of new weights for each individual*/
		matrix_weights = mxGetPr(plhs[2]);
		fillWithZeroes(matrix_weights, mw);
		
		plhs[3] = mxCreateDoubleMatrix(mmu,1,mxREAL); /* vector of expected values of unobservables for each individual*/
		matrix_meanunob = mxGetPr(plhs[3]);
		fillWithZeroes(matrix_meanunob, mmu);

		plhs[4] = mxCreateDoubleMatrix(inputs.numindivM,1,mxREAL); /* vector of probabilities for conditioning factors*/
		matrix_probInd = mxGetPr(plhs[4]);
		fillWithZeroes(matrix_probInd, inputs.numindivM);
       
	}
	
	double* matrix_effectsAll;
	double* matrix_effectsInd;
	double* matrix_weights;
	double* matrix_meanunob;	
	double* matrix_probInd;

    
    
private:
	void fillWithZeroes(double* array, unsigned elementCount)
	{
		std::fill(array, array + elementCount, 0.0);
	}
};

#endif //_MARG_OUTPUT_H_INCLUDED_
