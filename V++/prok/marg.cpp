#include "mex.h"
#include "marg_calc.h"
#include "margInput.h"
#include "margOutput.h"
#include <string.h>

//g++ -c -fPIC -O3 -mfpmath=sse -march=core2 -fopenmp -I/opt/matlabR2012b/extern/include marg_main.cpp
//setenv('OMP_NUM_THREADS', '1');
// mex marg.cpp marg_main.o CFLAGS="\$CFLAGS -fopenmp" LDFLAGS="\$LDFLAGS -fopenmp"

extern "C" void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
                  
{		
	margInput inputs(prhs);
	
	margOutput outputs(inputs, plhs, outputs);
	
	calculateMarg(&inputs, &outputs);
}
