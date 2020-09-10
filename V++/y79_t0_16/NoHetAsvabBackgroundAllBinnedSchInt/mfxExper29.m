clear all; clc;
delete mfxExper29.diary
diary  mfxExper29.diary
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get MFX. Broken out into 2 sections: 
%   1 - Overall - MFX for all individuals of a given age.
%   2 - Oaxaca  - Get MFX using betas from 79 and X's from 97
% Both of these sections get specific mfx for 1 year of any school and 
%  mfx if all time in workCollege had been spent in schoolOnly
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

vladppadd
load results
covMatr = covMatr1;
load modeldescr name holder namevar typeEst varval*
% load modeldescr 
load ../data_import79 black hispanic grad4yr activity
if typeEst==1
	save cov1b gamma_final covMatr
else
	save cov1a gamma_final covMatr
end
global numDrawsM unobMean

rand('seed',12345);
randn('seed',12345);

% Initialize csv and mat
dlmwrite('mfxExper29.csv',['MFX']);
hoy = date;
save mfxObjects29 hoy

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Age 29 (agemo==2812 | period==156)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DV's to loop over
my.marginals = [156*holder+name.Wage1];
[M one] = size(my.marginals);

% Variables in DV
my.vars = [156*holder+name.black             ;
           156*holder+name.hispanic          ;
           % 156*holder+name.born1022          ;
           156*holder+name.born1961          ;
           156*holder+name.born1962          ;
           156*holder+name.born1963          ;
           156*holder+name.foreignBorn       ;
           156*holder+name.afqtZscore        ; % y79 calls 'afqtZscore'; y97 calls 'afqt'
           156*holder+name.m_afqt            ;
           156*holder+name.empPct            ;
           156*holder+name.incPerCapita      ;
           156*holder+name.schoolOnly        ;
           156*holder+name.workK12           ;
           156*holder+name.workCollege       ;
           156*holder+name.workPT            ;
           156*holder+name.workFT            ;
           156*holder+name.military          ;
           156*holder+name.other             ;
           156*holder+name.gradHS            ;
           156*holder+name.grad4yr           ;
           156*holder+name.inSchWork         ;
           156*holder+name.PTwork            ;
           156*holder+name.constant          ];
[my.M my.N] = size(my.vars);

% Indices for higher-order interactions
% oneMA  = []; value(bothMA) = value(oneMA)*value(twoMA)*multMA;
% twoMA  = []; indices come from order of vars in wage equation
% bothMA = []; subtract one from the index to account for C++ starting at 0
% multMA = [];

oneMA  = [ 10  13  17  22  28  35  38]; %y79
twoMA  = [ 11  14  18  23  29  36  39]; %y79
bothMA = [ 12  16  21  27  34  37  40]; %y79
multMA = [0.1 0.1 0.1 0.1 0.1 0.1 0.1]; %both

% oneMA  = [ 11  14  18  23  29  36  39]; %y97
% twoMA  = [ 12  15  19  24  30  37  40]; %y97
% bothMA = [ 13  17  22  28  35  38  41]; %y97
% multMA = [0.1 0.1 0.1 0.1 0.1 0.1 0.1]; %both

% Population means (may change)
worker = (activity(:,1,156)>=2 & activity(:,1,156)<=4) | (activity(:,1,156)>=12 & activity(:,1,156)<=14) | (activity(:,1,156)>=22 & activity(:,1,156)<=24);
for i=1:my.M
	my.means(i,1) = median(eval(['1*varval' num2str(my.vars(i)) '(worker==1 & ~isnan(varval' num2str(my.vars(i)) '))']));
end
clear varval* 

%============================================================================
% Overall MFX
%============================================================================
simplerMfx3 % this now just returns 'mfx' rather than mfxWhite, etc

overall.all       = mfx;
overall.gammavarM = gammavarM;

save mfxExperObjects29 overall -append

% First time simplerMfx3 is run, spit out output
dlmwrite('mfxExper29.csv',['Overall'], '-append');
dlmwrite('mfxExper29.csv',['MFX'], '-append');
dlmwrite('mfxExper29.csv',[[ctranspose(overall.all.eff); ctranspose(overall.all.se)];], '-append');
