#include "mex.h"
#include "prok3_calc.h"
#include "prok3Input.h"
#include "prok3Output.h"
#include <string.h>

//g++ -c -fPIC -O3 -mfpmath=sse -I/opt/matlabR2012b/extern/include prok3x_calc_one_A2g.cpp
//setenv('OMP_NUM_THREADS', '1');
// mex prok3x.cpp prok3x_calc_one_A2g.o CFLAGS="\$CFLAGS" LDFLAGS="\$LDFLAGS"

extern "C" void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
                  
{		
	prok3Input inputs(prhs);
	
	prok3Output outputs(inputs, plhs, outputs);
	
	calculateProk3(&inputs, &outputs);
}
