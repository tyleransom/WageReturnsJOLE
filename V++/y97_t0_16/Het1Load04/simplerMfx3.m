%%% White MFX
Before.varinter = my.marginals;  %variables of interest;
Before.indid    = [];            %ids of the individuals 

fixedregridC    = my.vars';      %id of regressor fixed before and after change (unless in changeregrid, the fixed only before change) - need to be specified if default average not desired
fixedregrvalC   = my.means';     %values to which regressors are fixed if numindiv==0 or variable id if numindiv>0 - need to be specified if default average not desired

numDrawsM = 1;                   % number of random draws in all files /factors/
typeRandM = 3;                   %type of draws if typeEst=0 (1 - if random, 2 - halton sequence, 3- scrambled halton)
unobMean  = 1;                   %if estimating at the mean of the unobservables

simple_marginaleff5_new
% Adjust mfx vectors to remove unused vars/mfx==0; see mfx.eff
mfx.flag=logical(zeros(mfx.R,1));
mfx.flag([12 14 16 18 20 22 24])=1;
mfx.regrid(mfx.flag)   = [];
mfx.eff   (mfx.flag)   = [];
mfx.se    (mfx.flag)   = [];
mfx.gees  (mfx.flag,:) = [];
mfx.alt   (mfx.flag)   = [];
mfx.R                  = size(mfx.eff,1);
mfx.R2                 = mfx.R*(mfx.C==1)+mfx.R*(mfx.C>1)*(mfx.C-1);
