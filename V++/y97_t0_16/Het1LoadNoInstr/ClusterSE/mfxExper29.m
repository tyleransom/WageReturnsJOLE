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
load ../results
load cluster_se covMatr1S
covMatr = covMatr1S;
load modeldescr name holder namevar typeEst varval*
% load modeldescr 
load ../../data_import97 black hispanic gradHS grad4yr activity yearmo
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
save mfxExperObjects29 hoy

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Age 29 (agemo==2812 | period==156)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DV's to loop over
my.marginals = [156*holder+name.Wage1];
[M one] = size(my.marginals);

% Variables in DV
my.vars = [156*holder+name.black             ;
           156*holder+name.hispanic          ;
           156*holder+name.born1980          ;
           156*holder+name.born1981          ; 
           156*holder+name.born1982          ; 
           156*holder+name.born1983          ; 
           156*holder+name.foreignBorn       ;
           156*holder+name.empPct            ;
           156*holder+name.incPerCapita      ;
           156*holder+name.anySchool         ;
           % 156*holder+name.potExp            ;
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

%%% Indices for higher-order interactions - variables that have mfx that we 
%%% do not want to report and that should enter in other mfx.

% This is an index of how they appear in the list of mfx 
my.notvars = [11 13 15 17 19 21 23];

% This is an index of how they appear in the list of estimated coefficients
% oneMA  = []; value(bothMA) = value(oneMA)*value(twoMA)*multMA;
% twoMA  = []; indices come from order of vars in wage equation
% bothMA = []; subtract one from the index to account for C++ starting at 0
% multMA = [];

oneMA  = [  9  12  16  20  24  28  31]; %y79
twoMA  = [ 10  13  17  21  25  29  32]; %y79
bothMA = [ 11  15  19  23  27  30  33]; %y79
multMA = [0.1 0.1 0.1 0.1 0.1 0.1 0.1]; %both

% Flagging variables
worker    = (activity(:,1,156)>=2 & activity(:,1,156)<=4) | (activity(:,1,156)>=12 & activity(:,1,156)<=14) | (activity(:,1,156)>=22 & activity(:,1,156)<=24);
monthsCol = (sum(activity(:,1,:)==11 |  activity(:,1,:)==12 , 3));
everCol   = (monthsCol>0);
finish4   = (monthsCol>=40 & monthsCol<=50);
year      = floor(squeeze(yearmo)./100);
acter     = squeeze(activity);
calyearsInCol = zeros(size(activity,1),1);
for i=1:size(activity,1)
	calyearsInCol(i) = max(grad4yr(i,1,:)==1).*numel(unique(year(i,acter(i,:)==11 | acter(i,:)==12)));
end
finish4a  = calyearsInCol==5;
finish5   = (monthsCol>=51 & monthsCol<=60);
finish5a  = calyearsInCol==6;

% Population means (may change)
for i=1:my.M
	my.fullMeans(i,1)    = mean(eval(['varval' num2str(my.vars(i)) '(                                                         worker==1 & ~isnan(varval' num2str(my.vars(i)) '))']));
	my.hsDropMeans(i,1)  = mean(eval(['varval' num2str(my.vars(i)) '(gradHS(:,1,156)==0 & grad4yr(:,1,156)==0 &               worker==1 & ~isnan(varval' num2str(my.vars(i)) '))']));
	my.hsGradMeans(i,1)  = mean(eval(['varval' num2str(my.vars(i)) '(gradHS(:,1,156)==1 & grad4yr(:,1,156)==0 & everCol==0 &  worker==1 & ~isnan(varval' num2str(my.vars(i)) '))']));
	my.baDropMeans(i,1)  = mean(eval(['varval' num2str(my.vars(i)) '(gradHS(:,1,156)==1 & grad4yr(:,1,156)==0 & everCol==1 &  worker==1 & ~isnan(varval' num2str(my.vars(i)) '))']));
	my.baGradMeans(i,1)  = mean(eval(['varval' num2str(my.vars(i)) '(gradHS(:,1,156)==1 & grad4yr(:,1,156)==1 &               worker==1 & ~isnan(varval' num2str(my.vars(i)) '))']));
	my.baGrad4Means(i,1) = mean(eval(['varval' num2str(my.vars(i)) '(gradHS(:,1,156)==1 & grad4yr(:,1,156)==1 & finish4a==1 & worker==1 & ~isnan(varval' num2str(my.vars(i)) '))']));
	my.baGrad5Means(i,1) = mean(eval(['varval' num2str(my.vars(i)) '(gradHS(:,1,156)==1 & grad4yr(:,1,156)==1 & finish5a==1 & worker==1 & ~isnan(varval' num2str(my.vars(i)) '))']));
end

clear varval* 

%============================================================================
% Overall MFX
%============================================================================
simplerMfx4 % this now returns 7 mfx

overall.full       = fullMfx;
overall.hsDrop     = hsDropMfx;
overall.hsGrad     = hsGradMfx;
overall.baDrop     = baDropMfx;
overall.baGrad     = baGradMfx;
overall.baGrad4    = baGrad4Mfx;
overall.baGrad5    = baGrad5Mfx;
overall.gammavarM = gammavarM;

save mfxExperObjects29 overall -append

% First time simplerMfx4 is run, spit out output
dlmwrite('mfxExper29.csv',['Overall MFX'], '-append');
dlmwrite('mfxExper29.csv',['full'], '-append');
dlmwrite('mfxExper29.csv',[[ctranspose(overall.full.eff); ctranspose(overall.full.se)];], '-append');
dlmwrite('mfxExper29.csv',['hsDrop'], '-append');
dlmwrite('mfxExper29.csv',[[ctranspose(overall.hsDrop.eff); ctranspose(overall.hsDrop.se)];], '-append');
dlmwrite('mfxExper29.csv',['hsGrad'], '-append');
dlmwrite('mfxExper29.csv',[[ctranspose(overall.hsGrad.eff); ctranspose(overall.hsGrad.se)];], '-append');
dlmwrite('mfxExper29.csv',['baDrop'], '-append');
dlmwrite('mfxExper29.csv',[[ctranspose(overall.baDrop.eff); ctranspose(overall.baDrop.se)];], '-append');
dlmwrite('mfxExper29.csv',['baGrad'], '-append');
dlmwrite('mfxExper29.csv',[[ctranspose(overall.baGrad.eff); ctranspose(overall.baGrad.se)];], '-append');
dlmwrite('mfxExper29.csv',['baGrad4'], '-append');
dlmwrite('mfxExper29.csv',[[ctranspose(overall.baGrad4.eff); ctranspose(overall.baGrad4.se)];], '-append');
dlmwrite('mfxExper29.csv',['baGrad5'], '-append');
dlmwrite('mfxExper29.csv',[[ctranspose(overall.baGrad5.eff); ctranspose(overall.baGrad5.se)];], '-append');

