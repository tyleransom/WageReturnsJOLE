%%% Sets up the inputs for simple_marginaleff5_new and cleans the outputs

%%% full MFX
Before.varinter = my.marginals;    %variables of interest;
Before.indid    = [];              %ids of the individuals 

fixedregridC    = my.vars';        %id of regressor fixed before and after change (unless in changeregrid, the fixed only before change) - need to be specified if default average not desired
fixedregrvalC   = my.fullMeans';   %values to which regressors are fixed if numindiv==0 or variable id if numindiv>0 - need to be specified if default average not desired

numDrawsM = 1;                     % number of random draws in all files /factors/
typeRandM = 3;                     %type of draws if typeEst=0 (1 - if random, 2 - halton sequence, 3- scrambled halton)
unobMean  = 1;                     %if estimating at the mean of the unobservables

simple_marginaleff5_new
% Adjust mfx vectors to remove unused vars
if ~isempty(my.notvars)
	mfx.flag               = false(mfx.R,1);
	mfx.flag(my.notvars)   = true;
	mfx.regrid(mfx.flag)   = [];
	mfx.eff   (mfx.flag)   = [];
	mfx.se    (mfx.flag)   = [];
	mfx.gees  (mfx.flag,:) = [];
	mfx.alt   (mfx.flag)   = [];
	mfx.R                  = size(mfx.eff,1);
end
mfx.R2                 = mfx.R*(mfx.C==1)+mfx.R*(mfx.C>1)*(mfx.C-1);

fullMfx=mfx;

%%% hsDrop MFX
Before.varinter = my.marginals;    %variables of interest;
Before.indid    = [];              %ids of the individuals 

fixedregridC    = my.vars';        %id of regressor fixed before and after change (unless in changeregrid, the fixed only before change) - need to be specified if default average not desired
fixedregrvalC   = my.hsDropMeans'; %values to which regressors are fixed if numindiv==0 or variable id if numindiv>0 - need to be specified if default average not desired

numDrawsM = 1;                     % number of random draws in all files /factors/
typeRandM = 3;                     %type of draws if typeEst=0 (1 - if random, 2 - halton sequence, 3- scrambled halton)
unobMean  = 1;                     %if estimating at the mean of the unobservables

simple_marginaleff5_new
% Adjust mfx vectors to remove unused vars
if ~isempty(my.notvars)
	mfx.flag               = false(mfx.R,1);
	mfx.flag(my.notvars)   = true;
	mfx.regrid(mfx.flag)   = [];
	mfx.eff   (mfx.flag)   = [];
	mfx.se    (mfx.flag)   = [];
	mfx.gees  (mfx.flag,:) = [];
	mfx.alt   (mfx.flag)   = [];
	mfx.R                  = size(mfx.eff,1);
end
mfx.R2                 = mfx.R*(mfx.C==1)+mfx.R*(mfx.C>1)*(mfx.C-1);

hsDropMfx=mfx;

%%% hsGrad MFX
Before.varinter = my.marginals;    %variables of interest;
Before.indid    = [];              %ids of the individuals 

fixedregridC    = my.vars';        %id of regressor fixed before and after change (unless in changeregrid, the fixed only before change) - need to be specified if default average not desired
fixedregrvalC   = my.hsGradMeans'; %values to which regressors are fixed if numindiv==0 or variable id if numindiv>0 - need to be specified if default average not desired

numDrawsM = 1;                     % number of random draws in all files /factors/
typeRandM = 3;                     %type of draws if typeEst=0 (1 - if random, 2 - halton sequence, 3- scrambled halton)
unobMean  = 1;                     %if estimating at the mean of the unobservables

simple_marginaleff5_new
% Adjust mfx vectors to remove unused vars
if ~isempty(my.notvars)
	mfx.flag               = false(mfx.R,1);
	mfx.flag(my.notvars)   = true;
	mfx.regrid(mfx.flag)   = [];
	mfx.eff   (mfx.flag)   = [];
	mfx.se    (mfx.flag)   = [];
	mfx.gees  (mfx.flag,:) = [];
	mfx.alt   (mfx.flag)   = [];
	mfx.R                  = size(mfx.eff,1);
end
mfx.R2                 = mfx.R*(mfx.C==1)+mfx.R*(mfx.C>1)*(mfx.C-1);

hsGradMfx=mfx;

%%% baDrop MFX
Before.varinter = my.marginals;    %variables of interest;
Before.indid    = [];              %ids of the individuals 

fixedregridC    = my.vars';        %id of regressor fixed before and after change (unless in changeregrid, the fixed only before change) - need to be specified if default average not desired
fixedregrvalC   = my.baDropMeans'; %values to which regressors are fixed if numindiv==0 or variable id if numindiv>0 - need to be specified if default average not desired

numDrawsM = 1;                     % number of random draws in all files /factors/
typeRandM = 3;                     %type of draws if typeEst=0 (1 - if random, 2 - halton sequence, 3- scrambled halton)
unobMean  = 1;                     %if estimating at the mean of the unobservables

simple_marginaleff5_new
% Adjust mfx vectors to remove unused vars
if ~isempty(my.notvars)
	mfx.flag               = false(mfx.R,1);
	mfx.flag(my.notvars)   = true;
	mfx.regrid(mfx.flag)   = [];
	mfx.eff   (mfx.flag)   = [];
	mfx.se    (mfx.flag)   = [];
	mfx.gees  (mfx.flag,:) = [];
	mfx.alt   (mfx.flag)   = [];
	mfx.R                  = size(mfx.eff,1);
end
mfx.R2                 = mfx.R*(mfx.C==1)+mfx.R*(mfx.C>1)*(mfx.C-1);

baDropMfx=mfx;

%%% baGrad MFX
Before.varinter = my.marginals;    %variables of interest;
Before.indid    = [];              %ids of the individuals 

fixedregridC    = my.vars';        %id of regressor fixed before and after change (unless in changeregrid, the fixed only before change) - need to be specified if default average not desired
fixedregrvalC   = my.baGradMeans'; %values to which regressors are fixed if numindiv==0 or variable id if numindiv>0 - need to be specified if default average not desired

numDrawsM = 1;                     % number of random draws in all files /factors/
typeRandM = 3;                     %type of draws if typeEst=0 (1 - if random, 2 - halton sequence, 3- scrambled halton)
unobMean  = 1;                     %if estimating at the mean of the unobservables

simple_marginaleff5_new
% Adjust mfx vectors to remove unused vars
if ~isempty(my.notvars)
	mfx.flag               = false(mfx.R,1);
	mfx.flag(my.notvars)   = true;
	mfx.regrid(mfx.flag)   = [];
	mfx.eff   (mfx.flag)   = [];
	mfx.se    (mfx.flag)   = [];
	mfx.gees  (mfx.flag,:) = [];
	mfx.alt   (mfx.flag)   = [];
	mfx.R                  = size(mfx.eff,1);
end
mfx.R2                 = mfx.R*(mfx.C==1)+mfx.R*(mfx.C>1)*(mfx.C-1);

baGradMfx=mfx;

%%% baGrad4 MFX
Before.varinter = my.marginals;    %variables of interest;
Before.indid    = [];              %ids of the individuals 

fixedregridC    = my.vars';        %id of regressor fixed before and after change (unless in changeregrid, the fixed only before change) - need to be specified if default average not desired
fixedregrvalC   = my.baGrad4Means'; %values to which regressors are fixed if numindiv==0 or variable id if numindiv>0 - need to be specified if default average not desired

numDrawsM = 1;                     % number of random draws in all files /factors/
typeRandM = 3;                     %type of draws if typeEst=0 (1 - if random, 2 - halton sequence, 3- scrambled halton)
unobMean  = 1;                     %if estimating at the mean of the unobservables

simple_marginaleff5_new
% Adjust mfx vectors to remove unused vars
if ~isempty(my.notvars)
	mfx.flag               = false(mfx.R,1);
	mfx.flag(my.notvars)   = true;
	mfx.regrid(mfx.flag)   = [];
	mfx.eff   (mfx.flag)   = [];
	mfx.se    (mfx.flag)   = [];
	mfx.gees  (mfx.flag,:) = [];
	mfx.alt   (mfx.flag)   = [];
	mfx.R                  = size(mfx.eff,1);
end
mfx.R2                 = mfx.R*(mfx.C==1)+mfx.R*(mfx.C>1)*(mfx.C-1);

baGrad4Mfx=mfx;

%%% baGrad5 MFX
Before.varinter = my.marginals;    %variables of interest;
Before.indid    = [];              %ids of the individuals 

fixedregridC    = my.vars';        %id of regressor fixed before and after change (unless in changeregrid, the fixed only before change) - need to be specified if default average not desired
fixedregrvalC   = my.baGrad5Means'; %values to which regressors are fixed if numindiv==0 or variable id if numindiv>0 - need to be specified if default average not desired

numDrawsM = 1;                     % number of random draws in all files /factors/
typeRandM = 3;                     %type of draws if typeEst=0 (1 - if random, 2 - halton sequence, 3- scrambled halton)
unobMean  = 1;                     %if estimating at the mean of the unobservables

simple_marginaleff5_new
% Adjust mfx vectors to remove unused vars
if ~isempty(my.notvars)
	mfx.flag               = false(mfx.R,1);
	mfx.flag(my.notvars)   = true;
	mfx.regrid(mfx.flag)   = [];
	mfx.eff   (mfx.flag)   = [];
	mfx.se    (mfx.flag)   = [];
	mfx.gees  (mfx.flag,:) = [];
	mfx.alt   (mfx.flag)   = [];
	mfx.R                  = size(mfx.eff,1);
end
mfx.R2                 = mfx.R*(mfx.C==1)+mfx.R*(mfx.C>1)*(mfx.C-1);

baGrad5Mfx=mfx;
