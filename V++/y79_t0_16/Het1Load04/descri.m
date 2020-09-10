clear all;

numrows      = 1;               %number of entries for that variable
present      = numrows+1;       %if it enters part of the model  
idmodel      = present + 1;     %id of the outcome in which the variable is a regressor 
dependent    = idmodel +1;      %dependent variable (1), or simple regressor (or part of a sum) (0), or regressor (or part of a sum) resulting from discrete choice (2), or creating a condition for state dependent outcomes (3), or sum of endogenous or state variables (could be ones excluding each other) (4)

alter        = dependent+1;     % relevant alternative if dependent equal to 2 or 3
obscoeff     = alter+1;;        %if coefficients for all observables are the same as the ones for some other outcome (only for LHS variables - 0 (no constraint), any other number - the id number of the other LHS variable 
unobscoeff   = obscoeff+1;      %if coefficients for all unobservables are the same as the ones for some other outcome variable (only for LHS variables - 0 (no constraint), any other number - the id number of the other LHS variable  
varcoeff     = unobscoeff+1;    %if coefficient for the variance of the idiosyncratic shock is the same as the one for some other outcome variable (only for LHS variables - 0 (no constraint), any other number - the id number of the other LHS variable; -1 - no variance 
discrete     = varcoeff+1;      %if variable discrete (only in row 1)
interaction  = discrete+1;      % id of the variable for interaction (if regressor)
multiplier   = interaction+1;   %multiplier when interaction 
minival      = multiplier+1;    %minumum value for a condition to be satisfied (dependent==3)
maxival      = minival+1;       %maximum value for a condition to be satisfied (dependent==3)

auxvariable  = maxival+1;       %id when auxiliary variable
margtype     = auxvariable +1;  %type of outcome according to maeginal effects definition (0 -final outcome, 1-continous continuing as a regressor, 2- discrete continuing as a regressor, 3-discrete leading to switching modes, -1 - continuous leading to auxilary (sum), -2 - discrete leading to auxiliary (sum)
location     = margtype + 1;    %location if regressor;
interaction  = location + 1;    % id of the variable for interaction
idequation   = interaction + 1; % id of the equation in which the variable goes
visitinter   = idequation+1;    %if interaction visited - relevant location of the row where the variable with which it interacts stays
locnointer   =  visitinter+1;   %location of the variable among the regressors of that outcome when not interacted
locincloutc  = locnointer+1;    % if interacted variable endogenous - the order of the interaction among the other outcomes for which it is a regressor - estimation
locxincloutc = locincloutc+1;   % if interacted variable endogenous - the order of the interaction among the other outcomes for which it is a regressor - marginal effects

average      = locxincloutc+1;  %average of the variable (for marginal effects)
chng         = average+1;       %change for the marginal effects (only in row 1), if 0 - average/100
numfac       = chng+1;          %number of factors if LHS

typeRest     = 1;               %index: type restriction - 1 - setting parameters equal to other parameters, 0 - equal to a fixed value
typePa       = typeRest+1;      %index: type parameter (when dependent=1; 1 - observable - whole alternative; 2 - single factor loading 3 - factor loadings whole alternative
numAltRestA  = typePa+1;        %index: number of the alternative in which the restricted parameter is (1 if the outcome is continous)
parRestA     = numAltRestA+1;   %index: relative location of the entry for the other part of the restiction - among the other outcomes in for which the other variable is a regressor - rownumber for dependent=0; index factor id for a restricted factor loading (dependent=1)
valRest      = parRestA+1;      %index: value to which the parameter is restircted (if type is 0)
numRegRestB  = valRest+1;       %index: variable number of the regressor for which the other restricted parameter is (if type is 1) - for dependent =0; index: outcome variable where the other part of the restriction is for dependent =1;
numAltRestB  = numRegRestB+1;   %index number of the alternative in which the other restricted parameter is (1 if the outcome is continous) (if type is 1)
parRestB     = numAltRestB+1;   %index: relative location of the entry for the other part of the restiction - among the other outcomes in for which the other variable is a regressor - rownumber for dependent=0; index factor id for a restricted factor loading (dependent=1)
sizeRest     = parRestB;        %number of cells for one restiction

idreg        = 1;               %location of the id of the regressor changing
codechng     = idreg+1;         %code for change of regressor (0 - no change but specified value, 1 (standard) - average plus default change 2 - average plus specified change 3 - user specified first and second value)
value1       = codechng+1;       
value2       = value1+1;         
dreg         = zeros(1,value2); %matrix with info for changing regressor

maxNumFa     = 5;               %max number of factors

save descri