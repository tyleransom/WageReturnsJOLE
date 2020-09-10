#include "mex.h"
#include "prok2_calc.h"
#include "prok2Input.h"
#include "prok2Output.h"
#include <string.h>

//g++ -c -fPIC -O3 -mfpmath=sse -march=core2 -fopenmp -I/opt/matlabR2012b/extern/include prok2_calc_one_2A.cpp
//setenv('OMP_NUM_THREADS', '1');
// mex prok2.cpp prok2_calc_one_2A.o CFLAGS="\$CFLAGS -fopenmp" LDFLAGS="\$LDFLAGS -fopenmp"

extern "C" void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
                  
{		
	prok2Input inputs(prhs);
	
	prok2Output outputs(inputs, plhs, outputs);
	
	calculateProk2(&inputs, &outputs);
}
