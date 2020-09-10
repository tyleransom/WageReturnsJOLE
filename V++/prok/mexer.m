% !g++ -c -fPIC -O3 -mfpmath=sse -march=core2 -fopenmp -I/opt/matlabR2012b/extern/include prok3_calc_one_A2.cpp
!g++ -c -fPIC -O3 -mfpmath=sse -march=core2 -fopenmp -I/opt/matlabR2012b/extern/include prok3x_calc_one_A2.cpp
!g++ -c -fPIC -O3 -mfpmath=sse -march=core2 -fopenmp -I/opt/matlabR2012b/extern/include prok2_calc_one_2A.cpp
!g++ -c -fPIC -O3 -mfpmath=sse -march=core2 -fopenmp -I/opt/matlabR2012b/extern/include marg_main.cpp

% threader=1

% setenv('OMP_NUM_THREADS', num2str(threader));
% mex prok3.cpp  prok3_calc_one_A2.o  CFLAGS="\$CFLAGS -fopenmp" LDFLAGS="\$LDFLAGS -fopenmp";
mex prok3x.cpp prok3x_calc_one_A2.o CFLAGS="\$CFLAGS -fopenmp" LDFLAGS="\$LDFLAGS -fopenmp";
mex prok2.cpp  prok2_calc_one_2A.o  CFLAGS="\$CFLAGS -fopenmp" LDFLAGS="\$LDFLAGS -fopenmp";
mex marg.cpp   marg_main.o          CFLAGS="\$CFLAGS -fopenmp" LDFLAGS="\$LDFLAGS -fopenmp";
