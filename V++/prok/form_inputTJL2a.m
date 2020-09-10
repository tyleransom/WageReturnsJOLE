clear
tic
load finput1ba
load model_all factor* *umF*
rand('seed',12345);
randn('seed',12345);
% numFa=zeros(SVar,1);
yte=exist('factorId1');
if yte<1
	factorId1=zeros(SVar,maxNumFa);
end
%N=360;
%%%%% CHANGE MADE: UNCOMMENTED LINE 8 (JKA)


% maxNumFa1=max(max(max(factorId1)),max(numFa));
% if maxNumFa>maxNumFa1
	% factorId1(:,maxNumFa1+1:maxNumFa)=[];
	% maxNumFa=maxNumFa1;
% end	
if maxNumFa==0
	factorId1=[];
end
% maxNumFa2=max(0,maxNumFa-1);
% if max(max(factorId1))~=maxNumFa2
	% display 'Problems with the maximum number of factors'
% end

% if max(numInclOutcA)~=maxInclOutc
	% display 'Problems with the maximum number of included outcomes'
% end


%Objects describing the variables
for ss=1:SVar
	numOutVarM1(ss,1)=numOutVar(ss,1)-1;

	if ss>1
		uniqueVarId(ss,1)=uniqueVarId(ss-1,1)+max(1,numOutVarM1(ss-1,1));
	else
		uniqueVarId(ss,1)=0;
	end
	
	eval(['kl=size(reg' num2str(ss) ');']);
	numRegr(ss,1)=kl(1,2);
	clear kl;
	
	% if numInclOutcA(ss,1)>0 & (maxMissIter(ss,1)>0 | typeVarId(ss,1)<4)
		% for is=1:numInclOutcA(ss,1)
				% maxMissIter(indInclOutcId(ss,is)+1,1)=maxMissIter(indInclOutcId(ss,is)+1,1)+1;
		% end
	% end
	
end
numOutVarM11=max(numOutVarM1,1);
SVarOut=sum(numOutVarM11); %number of equations associated with parameters in the model
clear numOutVarM11



% Indexes
for ss=1:SVar
	missVar(ss,1) = numOutVar(ss,1); % location of the info about being missing - within the data for the variable (C++ - all)
	modTypeVarId(ss,1) = missVar(ss,1)+1; % location of the info about modified type - within the data for the variable
	covId(ss,1) = modTypeVarId(ss,1) + 1; % location of the info about covariance group ID - within the data for the variable
	auxCov(ss,1) = covId(ss,1) + 1; % location of the data about rows (available variables) and columns (missing variables) for covariance groups - within the data for the variable 
	indRegr(ss,1) = auxCov(ss,1) + 1; % index where the regressors start
	numInclOutc(ss,1) = indRegr(ss,1) + numRegr(ss,1); % location of the data about the number of outcome variables in which the variable is a regressor - within the data for the variable
	indInclOutc(ss,1) = numInclOutc(ss,1) + 1; %location of the information for the placement of the dependent variables in which the variable is a regressor in the data set 
	indInclOutcReg(ss,1) = indInclOutc(ss,1) + numInclOutcA(ss,1); %location of the dependent variables when the variable is a regressor - within the data for the variable 
	indInclOutcTyp(ss,1) = indInclOutcReg(ss,1) + numInclOutcA(ss,1); %location of the information about the type of the dependent variable as a regressor (interaction or not) - within the data for the variable 
	numMissRegDr(ss,1) = indInclOutcTyp(ss,1) + numInclOutcA(ss,1); % location of data for the number of iteration-specific missing variavles - within the data for the variable 
	locMissRegDr(ss,1) = numMissRegDr(ss,1) + 1; % location of data for the relative position of the missing iteration specific variables within the data for the variable 
	cellsize(ss,1) = locMissRegDr(ss,1) + maxMissIter(ss,1); %size of the data for one variable ss for one person
end
if maxNumFa>0
factorId=reshape(factorId1,SVar*maxNumFa,1);
else
factorId=factorId1;
end
%getting the model description matrix
mmat=[SVar;SVarOut;maxInclOutc; maxNumFa;uniqueVarId;numOutVarM1;numRegr;numFa;factorId;missVar;modTypeVarId;covId;auxCov;indRegr;numInclOutc;indInclOutc;indInclOutcReg;indInclOutcTyp;numMissRegDr;locMissRegDr];



%Object describing the indexes of coefficients

d_beta=0; %size vector coeffiecients for observables
d_alpha=0; %size vector coeffiecients for factors loading
d_sigma=0; %size vector coefficients for idiosyncratic variances
d_omega=0; %size vector for coeffiencts of weights for discrete factors
d_ksi = 0; %size vector for coefiecients of points for discrete factors
d_mean = 0; %size vector for coefiecients of means for mixtures or normal distributed factors
d_var = 0; %size vector for coefiecients of variances for mixtures or normal distributed factors
indFirCoefOb=zeros(SVar,1); %index first coeff. obs.
indFirCoefUnob=zeros(SVar,1); %index first coef. factors
indFirCoefIds=zeros(SVar,1); %index first coef. idiosyncr. variances
indFirCoefWgts=zeros(max(maxNumFa,1),1); %index first coef. weights discrete choices
indFirCoefPts=zeros(max(maxNumFa,1),1); %index first coef. points discrete choices
indFirCoefMns=zeros(max(maxNumFa,1),1); %index first coef. means factors
indFirCoefVars=zeros(max(maxNumFa,1),1); %index first coef. variances factors
indFirWgts=zeros(max(maxNumFa,1),1); %index first coef. weights discrete choices, auxilary
indFirPts=zeros(max(maxNumFa,1),1); %index first coef. points discrete choices, auxilary

for ii=1:SVar %main variables
	if auxVarObs(ii,1)<0.5
		indFirCoefOb(ii,1)=d_beta;
		d_beta=d_beta+max(1,numOutVarM1(ii,1))*numRegr(ii,1);
	end
	if auxVarObs(ii,1)>0
		indFirCoefOb(ii,1)=indFirCoefOb(auxVarObs(ii,1),1);
	end
	if auxVarUnobs(ii,1)<0.5
		indFirCoefUnob(ii,1)=d_alpha;
		d_alpha=d_alpha+max(1,numOutVarM1(ii,1))*numFa(ii,1);
	end
	if auxVarUnobs(ii,1)>0
		indFirCoefUnob(ii,1)=indFirCoefUnob(auxVarUnobs(ii,1),1);
	end
	if typeVarId(ii,1)~=3 & auxVarIds(ii,1)<0.5 & numOutVar(ii,1)==1
		indFirCoefIds(ii,1)=d_sigma;
		d_sigma=d_sigma+1;
	end
	if typeVarId(ii,1)~=3 & auxVarIds(ii,1)>0 & numOutVar(ii,1)==1
		indFirCoefIds(ii,1)=indFirCoefIds(auxVarIds(ii,1),1);
	end

end
num1=0;
d_points=0;
d_weights=0;


if maxNumFa>0
	for mn=1:maxNumFa
		if factorType(mn,1)==2
			indFirCoefWgts(mn,1)=d_omega;
			indFirCoefPts(mn,1)=d_ksi;
			indFirPts(mn,1)=d_points;
			
			d_omega=d_omega+factorPoints(mn,1)-1;
			d_ksi=d_ksi+factorPoints(mn,1)-2;
			d_points = d_points + factorPoints(mn,1);
		end
			
		if factorType(mn,1)==4
			indFirCoefWgts(mn,1)=d_omega;
			indFirCoefMns(mn,1)=d_mean;
			indFirCoefVars(mn,1)=d_var;
			indFirPts(mn,1)=d_points;
			indFirWgts(mn,1)=d_weights;
			
			d_omega=d_omega+factorPoints(mn,1)-1;
			d_mean = d_mean+factorPoints(mn,1);
			d_var = d_var+factorPoints(mn,1);
			d_points = d_points + factorPoints(mn,1);
			d_weights = d_weights + factorEval(mn,1);
		end
		
		if factorType(mn,1)==3
			
			indFirCoefMns(mn,1)=d_mean;
			indFirCoefVars(mn,1)=d_var;
			% indFirPts(mn,1)=d_points;
			indFirWgts(mn,1)=d_weights;
		
			d_mean = d_mean+factorPoints(mn,1);
			d_var = d_var+factorPoints(mn,1);
			% d_points = d_points + factorPoints(mn,1);
			d_weights = d_weights + factorEval(mn,1);

		end
		
		if factorType(mn,1)==1
		
			indFirWgts(mn,1)=d_weights;
			
			d_weights = d_weights + factorEval(mn,1);
			
		end
		
	end
end

%getting parameter description vector
SVar1=SVar;
kmat=[SVar1;indFirCoefOb;indFirCoefUnob;indFirCoefIds;indFirCoefWgts;indFirCoefPts;indFirCoefMns;indFirCoefVars];


%getting parameters vector
beta=ones(d_beta,1);
alpha=ones(d_alpha,1);
sigma=ones(d_sigma,1);
omega=zeros(d_omega,1);
ksi=ones(d_ksi,1);
meanz=ones(d_mean,1);
varz=ones(d_var,1);
delta0=[beta;alpha;sigma;omega;ksi;meanz;varz];
delta0=delta0+(0.5-rand(d_beta+d_alpha+d_sigma+d_omega+d_ksi+d_mean+d_var,1));
%delta0(end,1)=0;
delta=[d_beta;d_alpha;d_sigma;d_omega;d_ksi;d_mean;d_var;delta0];


%Restrictions
rA=0; %counter restrictions type A (fixed values) 
rB=0; %counter restrictions type B (equal parameters) 
nRestr = length(typeRestr); %number of restrictions


nRestrA=[]; %restrictions type A
nRestrB=[]; %restrictions type B

nRestrMat=[nRestrA;nRestrB];
if nRestr>0
for nr = 1:nRestr
	if typeRestr(nr,1)==0
		if typePar(nr,1)==1
			if parRestrA(nr,1)>0
				rA=rA+1;
				nRestrA(rA,1)=indFirCoefOb(numOutcRestrA(nr,1),1)+(numAltRestrA(nr,1)-1)*numRegr(numOutcRestrA(nr,1),1)+parRestrA(nr,1);
				nRestrA(rA,2)=valRestr(nr,1);
				nRestrA(rA,3)=0;
			else
				for uy=1:numRegr(numOutcRestrA(nr,1),1)
					rA = rA+1;
					nRestrA(rA,1)=indFirCoefOb(numOutcRestrA(nr,1),1)+(numAltRestrA(nr,1)-1)*numRegr(numOutcRestrA(nr,1),1)+uy;
					nRestrA(rA,2)=valRestr(nr,1);
					nRestrA(rA,3)=0;
				end
			end
		end
		if typePar(nr,1)==2
			if parRestrA(nr,1)>0
				rA=rA+1;
				nRestrA(rA,1)=d_beta+indFirCoefUnob(numOutcRestrA(nr,1),1)+(numAltRestrA(nr,1)-1)*numFa(numOutcRestrA(nr,1),1)+parRestrA(nr,1);
				nRestrA(rA,2)=valRestr(nr,1);
				nRestrA(rA,3)=0;
			else
				for uye=1:numFa(numOutcRestrA(nr,1),1)
					rA = rA+1;
					nRestrA(rA,1)=d_beta+indFirCoefUnob(numOutcRestrA(nr,1),1)+(numAltRestrA(nr,1)-1)*numFa(numOutcRestrA(nr,1),1)+uye;
					nRestrA(rA,2)=valRestr(nr,1);
					nRestrA(rA,3)=0;
				end
			end
		end	
		if typePar(nr,1)==3
			rA=rA+1;
			nRestrA(rA,1)=d_beta+d_alpha+indFirCoefIds(numOutcRestrA(nr,1),1);
			nRestrA(rA,2)=valRestr(nr,1);
			nRestrA(rA,3)=0;
		end
	end
	if typeRestr(nr,1)==1
		if typePar(nr,1)==1
			if parRestrA(nr,1)>0
				rB=rB+1;
				nRestrB(rB,1)=indFirCoefOb(numOutcRestrA(nr,1),1)+(numAltRestrA(nr,1)-1)*numRegr(numOutcRestrA(nr,1),1)+parRestrA(nr,1);
				nRestrB(rB,2)=indFirCoefOb(numOutcRestrB(nr,1),1)+(numAltRestrB(nr,1)-1)*numRegr(numOutcRestrB(nr,1),1)+parRestrB(nr,1);
				nRestrB(rB,3)=1;
			else
				for uyk=1:numRegr(numOutcRestrA(nr,1),1)
					rB = rB+1;
					nRestrB(rB,1)=indFirCoefOb(numOutcRestrA(nr,1),1)+(numAltRestrA(nr,1)-1)*numRegr(numOutcRestrA(nr,1),1)+uyk;
					nRestrB(rB,2)=indFirCoefOb(numOutcRestrB(nr,1),1)+(numAltRestrB(nr,1)-1)*numRegr(numOutcRestrB(nr,1),1)+uyk;
					nRestrB(rB,3)=1;
				end
			end
		end
		if typePar(nr,1)==2
			if parRestrA(nr,1)>0
				rB=rB+1;
				nRestrB(rB,1)=d_beta+indFirCoefUnob(numOutcRestrA(nr,1),1)+(numAltRestrA(nr,1)-1)*numFa(numOutcRestrA(nr,1),1)+parRestrA(nr,1);
				nRestrB(rB,2)=d_beta+indFirCoefUnob(numOutcRestrB(nr,1),1)+(numAltRestrB(nr,1)-1)*numFa(numOutcRestrB(nr,1),1)+parRestrB(nr,1);
				nRestrB(rB,3)=1;
			else
				for uyej=1:numFa(numOutcRestrA(nr,1),1)
					rB = rB+1;
					nRestrB(rB,1)=d_beta+indFirCoefUnob(numOutcRestrA(nr,1),1)+(numAltRestrA(nr,1)-1)*numFa(numOutcRestrA(nr,1),1)+uyej;
					nRestrB(rB,2)=d_beta+indFirCoefUnob(numOutcRestrB(nr,1),1)+(numAltRestrB(nr,1)-1)*numFa(numOutcRestrB(nr,1),1)+uyej;
					nRestrB(rB,3)=1;
				end
			end
		end	
		if typePar(nr,1)==3
			rB=rB+1;
			nRestrB(rB,1)=d_beta+indFirCoefUnob(numOutcRestrA(nr,1),1)+(numAltRestrA(nr,1)-1)*numFa(numOutcRestrA(nr,1),1)+parRestrA(nr,1);
			nRestrB(rB,2)=d_beta+d_alpha+indFirCoefIds(numOutcRestrB(nr,1),1)+1;
			nRestrB(rB,3)=1;
		end
	end
end		

nRestrMat=[nRestrA;nRestrB];

nRestrMat = sortrows(nRestrMat,1);
end

rAB=rA+rB;

if maxNumFa>0
	maxFPoints = max(factorPoints);
	maxEPoints = max(factorEval);
	numTPoints = d_points;
	ffmat=[maxFPoints; maxEPoints; numTPoints;indFirWgts;indFirPts;factorPoints;factorType;factorEval];
	ggmat=[];
	hhmat=[];
	for pl=1:maxNumFa
		if factorType(pl,1)==1 | factorType(pl,1)==3 | factorType(pl,1)==4
			[jas xas] = GaussHermite(factorEval(pl,1));
			ggmat=[ggmat; sqrt(2)*jas];
			hhmat=[hhmat; xas/sqrt(pi)];
		end
	end
	if length(ggmat)<1
		ggmat=1;
		hhmat=1;
	end
else
	maxFPoints = 0;
	maxEPoints = 0;
	numTPoints = 0;
	ffmat = [zeros(5,1); 1; 0; 0];
	ggmat=1;
	hhmat=1;
end

maxxsize=max(max(Axxmat_size));

toc
sas=toc;
save -v7.3 finput1b numOutVar ffmat typeVarId indFirCoefMns indFirCoefVars d_points d_weights d_mean d_var ggmat hhmat factorPoints factorType factorEval typeEst typeRand N1 N2 indFirCoefWgts indFirCoefPts indFirWgts indFirPts maxFPoints maxEPoints factorPoints numTPoints d_ksi d_omega omega ksi Axxmat mmat SVar SVarOut maxInclOutc maxNumFa uniqueVarId numOutVarM1 numRegr numFa factorId missVar modTypeVarId covId auxCov indRegr numInclOutc indInclOutc indInclOutcReg indInclOutcTyp numMissRegDr locMissRegDr Admat Axxmat_size commonN minorN GroupN indN N AVN AMNG ANG AnumEqG AnumFacG AnumRepG AvarPerIndividual ArowVarIndex AindVarData AvarId AKG AMEG AMFG AMRG kmat SVar1 indFirCoefOb indFirCoefUnob indFirCoefIds delta d_beta d_alpha d_sigma delta0 alpha beta sigma nRestrA nRestrB rA rB nRestrMat rAB factorId1 delta0




							
				
				
		
