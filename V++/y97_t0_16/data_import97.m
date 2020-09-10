clc; clear all;
delete data_import97.diary;
diary  data_import97.diary;
tic
global argum d_beta d_alpha d_sigma nRestrA nRestrB rA rB GroupN counter

% This file both imports and saves confidential data. Thus, it should only
% be executed on the secretdir/V++. Actions taken entirely within the secretdir
% can be done with relatively file path directories

! head --bytes=3K ../../y97_vlad_scaled_t0_16.csv
A =   importdata('../../y97_vlad_scaled_t0_16.csv');

[N,KK]=size(A.data)
T = 240; % 20 years from 1601--3512
K0 = 41; % constant vars (the most recent 3 are the Cvars, numBA* and tuition*)
K1 = (KK-K0)/T

% Note that 97 has 3 fewer cons var than 79 (5 birth cohorts in 97 vs 8 in 79)
% Currently, there are missing values for changing variables in each 
%  period an individual is missing. Vladi states that as long as the
%  dmy flag informs that the individual is missing, there should be
%  no problem.

%=========================
% Drop females (column 4)
%=========================
data = A.data;
data(data(:, 4)==1,:)=[];


[N,KK]=size(data)

%============================================================================
% Read in the data. 
% local cons   cohortFlag id constant female oversampleRace weight `Pvars97' `AFQTvars' `Fvars' `Cvars'
% local chng   uniqueid period yearmo activity activity_simple lnWage lnWageAlt lnWageNoSelf lnWageAltNoSelf lnWageJobMain hours `Svars' `Svars2' `Zvars' `Evars' `Zvarint2' `Avars' `Mvars' gradHS grad2yr grad4yr gradGraduate
% The first K0 columns are variables that do not change over time (cons). 
% The rest are the vars that do change over time (chng), grouped by period.
% Create master NxKxT tensor that stores all K variables for each N people
%   in each T period
%============================================================================
cons_vars = data(:,1:K0);
chng_vars = reshape( data(:,K0+1:end),N,K1,T);
all_vars  = [cons_vars(:,:,ones(1,T) ) chng_vars];

%=============================================================
% Create 3-dimensional Nx1xT arrays storing each variable
%=============================================================
cohortFlag            = all_vars(:,1,:);   
id                    = all_vars(:,2,:);
constant              = all_vars(:,3,:);
female                = all_vars(:,4,:);
oversampleRace        = all_vars(:,5,:);
weight                = all_vars(:,6,:);
black                 = all_vars(:,7,:);
hispanic              = all_vars(:,8,:);
% fewer birth cohorts in 97
% fewer birth cohorts in 97
% fewer birth cohorts in 97
born1980              = all_vars(:,9,:);
born1981              = all_vars(:,10,:);
born1982              = all_vars(:,11,:);
born1983              = all_vars(:,12,:);
foreignBorn           = all_vars(:,13,:); 
afqt                  = all_vars(:,14,:);
asvabAR               = all_vars(:,15,:);
asvabCS               = all_vars(:,16,:);
asvabMK               = all_vars(:,17,:);
asvabNO               = all_vars(:,18,:);
asvabPC               = all_vars(:,19,:);
asvabWK               = all_vars(:,20,:);
m_afqt                = all_vars(:,21,:);
m_asvabAR             = all_vars(:,22,:);
m_asvabCS             = all_vars(:,23,:);
m_asvabMK             = all_vars(:,24,:);
m_asvabNO             = all_vars(:,25,:);
m_asvabPC             = all_vars(:,26,:);
m_asvabWK             = all_vars(:,27,:);
hgcMoth               = all_vars(:,28,:);
hgcMothSq             = all_vars(:,29,:);
m_hgcMoth             = all_vars(:,30,:);
hgcFath               = all_vars(:,31,:);
hgcFathSq             = all_vars(:,32,:);
m_hgcFath             = all_vars(:,33,:);
famInc                = all_vars(:,34,:);
famIncSq              = all_vars(:,35,:);
m_famInc              = all_vars(:,36,:);
femaleHeadHH14        = all_vars(:,37,:);
liveWithMom14         = all_vars(:,38,:);
numBAzero             = all_vars(:,39,:); 
numBAperCapita        = all_vars(:,40,:); 
tuitionFlagship       = all_vars(:,41,:); %K0
uniqueid              = all_vars(:,42,:);  
period                = all_vars(:,43,:);
yearmo                = all_vars(:,44,:);
activity              = all_vars(:,45,:);
activity_simple       = all_vars(:,46,:);
lnWage                = all_vars(:,47,:); lnWage(lnWage==-999) = NaN;
lnWageAlt             = all_vars(:,48,:); lnWageAlt(lnWageAlt==-999) = NaN;
lnWageNoSelf          = all_vars(:,49,:); lnWageNoSelf(lnWageNoSelf==-999) = NaN;
lnWageAltNoSelf       = all_vars(:,50,:); lnWageAltNoSelf(lnWageAltNoSelf==-999) = NaN;
lnWageJobMain         = all_vars(:,51,:); lnWageJobMain(lnWageJobMain==-999) = NaN;  
hours                 = all_vars(:,52,:);
schoolOnlyt           = all_vars(:,53,:);
schoolOnlyBlack       = all_vars(:,54,:);
schoolOnlyHisp        = all_vars(:,55,:);
schoolOnlySq          = all_vars(:,56,:);
schoolOnlySqBlack     = all_vars(:,57,:);
schoolOnlySqHisp      = all_vars(:,58,:);
schoolOnlyCu          = all_vars(:,59,:);
anySchoolt            = all_vars(:,60,:);
anySchoolBlack        = all_vars(:,61,:);
anySchoolHisp         = all_vars(:,62,:);
anySchoolSq           = all_vars(:,63,:);
anySchoolSqBlack      = all_vars(:,64,:);
anySchoolSqHisp       = all_vars(:,65,:);
anySchoolCu           = all_vars(:,66,:);
workK12t              = all_vars(:,67,:);
workK12Black          = all_vars(:,68,:);
workK12Hisp           = all_vars(:,69,:);
workK12Sq             = all_vars(:,70,:);
workK12SqBlack        = all_vars(:,71,:);
workK12SqHisp         = all_vars(:,72,:);
workK12Cu             = all_vars(:,73,:);
workColleget          = all_vars(:,74,:);
workCollegeBlack      = all_vars(:,75,:);
workCollegeHisp       = all_vars(:,76,:);
workCollegeSq         = all_vars(:,77,:);
workCollegeSqBlack    = all_vars(:,78,:);
workCollegeSqHisp     = all_vars(:,79,:);
workCollegeCu         = all_vars(:,80,:);
workPTonlyt           = all_vars(:,81,:);
workPTBlack           = all_vars(:,82,:);
workPTHisp            = all_vars(:,83,:);
workPTSq              = all_vars(:,84,:);
workPTSqBlack         = all_vars(:,85,:);
workPTSqHisp          = all_vars(:,86,:);
workPTCu              = all_vars(:,87,:);
workFTonlyt           = all_vars(:,88,:);
workFTBlack           = all_vars(:,89,:);
workFTHisp            = all_vars(:,90,:);
workFTSq              = all_vars(:,91,:);
workFTSqBlack         = all_vars(:,92,:);
workFTSqHisp          = all_vars(:,93,:);
workFTCu              = all_vars(:,94,:);
militaryt             = all_vars(:,95,:);
militaryBlack         = all_vars(:,96,:);
militaryHisp          = all_vars(:,97,:);
militarySq            = all_vars(:,98,:);
militarySqBlack       = all_vars(:,99,:);
militarySqHisp        = all_vars(:,100,:);
militaryCu            = all_vars(:,101,:);
othert                = all_vars(:,102,:);
otherBlack            = all_vars(:,103,:);
otherHisp             = all_vars(:,104,:);
otherSq               = all_vars(:,105,:);
otherSqBlack          = all_vars(:,106,:);
otherSqHisp           = all_vars(:,107,:);
otherCu               = all_vars(:,108,:);
workK12anySchool      = all_vars(:,109,:);
workCollegeanySchool  = all_vars(:,110,:); 
workCollegeworkK12    = all_vars(:,111,:);
workPTanySchool       = all_vars(:,112,:);
workPTworkK12         = all_vars(:,113,:);
workPTworkCollege     = all_vars(:,114,:);
workFTanySchool       = all_vars(:,115,:);
workFTworkK12         = all_vars(:,116,:);
workFTworkCollege     = all_vars(:,117,:);
workFTworkPT          = all_vars(:,118,:);   
potExpt               = all_vars(:,119,:);
potExpSq              = all_vars(:,120,:);
potExpCu              = all_vars(:,121,:);
potExpClassict        = all_vars(:,122,:);
potExpClassicSq       = all_vars(:,123,:);
potExpClassicCu       = all_vars(:,124,:);
empPct                = all_vars(:,125,:);
incPerCapita          = all_vars(:,126,:);
gradHS                = all_vars(:,127,:);
grad2yr               = all_vars(:,128,:);
grad4yr               = all_vars(:,129,:);
gradGraduate          = all_vars(:,130,:); %K0+K1

%=================================================
% Create various intermediate arrays to store data
%=================================================
choice        = zeros(N,26,T);
for i=1:26
	choice(:,i,:) = (activity(:,1,:)==i);
end
missedInt           = isnan(activity(:,1,:));
missedWage          = isnan(  lnWage(:,1,:));
missedWageAlt       = isnan(  lnWageAlt      (:,1,:));
missedWageNoSelf    = isnan(  lnWageNoSelf   (:,1,:));
missedWageAltNoSelf = isnan(  lnWageAltNoSelf(:,1,:));
missedWageJobMain   = isnan(  lnWageJobMain  (:,1,:));
working    = ( (activity(:,1,:)>= 2 & activity(:,1,:)<= 4) | (activity(:,1,:)>=12 & activity(:,1,:)<=14) | (activity(:,1,:)>=22 & activity(:,1,:)<=24) );
preHSrisk  =   (activity(:,1,:)>= 1 & activity(:,1,:)<= 7) ;
HSgradrisk =   (activity(:,1,:)>=11 & activity(:,1,:)<=17) ;
BAgradrisk =   (activity(:,1,:)>=21 & activity(:,1,:)<=26) ;
inSchWork  =   (activity(:,1,:)== 2 | activity(:,1,:)==12  | activity(:,1,:)==22);
PTwork     =   (activity(:,1,:)== 3 | activity(:,1,:)==13  | activity(:,1,:)==23);
Wvars      = [preHSrisk HSgradrisk inSchWork PTwork];
age        = 16+(period-1)./12;

%===========================
% Summary stats
%===========================
if exist('summarize')==0
	websave('temp.zip','http://www.mathworks.com/matlabcentral/fileexchange/41150-summarize?download=true');
	!unzip temp.zip -x license.txt
	!mv summarize.m ~/Documents/MATLAB
	!rm temp.zip;
end
activityColumn = 45; %activity
wageColumn = 49; %lnWageNoSelf

%--------------------------------------------------------
% all - compare with create_vlad_scaled_full_cohorts.log
%--------------------------------------------------------
all_long  = reshape(permute(all_vars, [3 1 2]),N*T,(K0+K1)); % reshape from wide to long
all_long(isnan(all_long(:,activityColumn)),:)=NaN;           % if missing activity, all vars should be NaN
summarize(all_long);

%--------------------------------------------------------
% choices (TMR) - compare with y79_logits.log
% stata code would be: sum lnWageNoSelf `Pvars97' `Mvars' `Svars' `Zvars'  `Evars'  `Fvars' `Cvars' if inlist(activity,1,2,3,4,5,6,7,11,12,13,14,15,16,17,21,22,23,24,25,26), sep(0)
%--------------------------------------------------------
all_long2  = reshape(permute(all_vars, [3 1 2]),N*T,(K0+K1));
all_long2(all_long2(:,wageColumn)==-999,wageColumn) = NaN;    % replace -999 wages with NaN
summarize(all_long2(~isnan(all_long2(:,activityColumn)),[wageColumn 7:8  9:13 [128:129 56:59 70:73 77:80 84:87 91:94 98:101 105:108]-3 28:41]));

%--------------------------------------------------------
% wages (TMR) -  compare with y79_wages_anyschool.log
% stata code would be: sum lnWageNoSelf `Pvars97' `Mvars' `Svars2' `Zvars2' `Evars2'                if inlist(activity,2,3,4,12,13,14,22,23,24) & ~mi(lnWageNoSelf)
%--------------------------------------------------------
all_long3  = reshape(permute(all_vars, [3 1 2]),N*T,(K0+K1));
all_long3(all_long3(:,wageColumn)==-999,wageColumn) = NaN;    % replace -999 wages with NaN
all_long3(isnan(all_long3(:,wageColumn)),:)=NaN;              % if missing wage, all vars should be NaN
summarize(all_long3(:,[wageColumn 7:8  9:13 [128:129 63 66 69 70 73 112 76 77 80 113 83 84 87 117 90 91 94 118 97 98 101 104 105 108 111]-3 ]));

save data_import97.mat;

disp(['Time taken to import data: ',num2str(toc/60),' minutes']);
diary off;
