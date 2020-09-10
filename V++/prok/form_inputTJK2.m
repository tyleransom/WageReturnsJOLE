clear
tic
load model_all
rand('seed',12345);
randn('seed',12345);

% numFa=zeros(SVar,1);
% factorId1=zeros(SVar,maxNumFa);
%N=360;

%Consistency checks
indInclOutcReg1=indInclOutcRegA;


maxInclOutc1=max(numInclOutcA);
if maxInclOutc>maxInclOutc1
	indInclOutcId(:,maxInclOutc1+1:maxInclOutc)=[];
	indInclOutcReg1(:,maxInclOutc1+1:maxInclOutc)=[];
	maxInclOutc=maxInclOutc1;
end

% maxNumFa1=max(max(max(factorId1)),max(numFa));
% if maxNumFa>maxNumFa1
	% factorId1(:,maxNumFa1+1:maxNumFa)=[];
	% maxNumFa=maxNumFa1;
% end	
if maxNumFa==0
	factorId1=[];
	numDraws=1;
else
	numDraws=factorEval(1,1);
end
% maxNumFa2=max(0,maxNumFa-1);
% if max(max(factorId1))~=maxNumFa2
	% display 'Problems with the maximum number of factors'
% end

% if max(numInclOutcA)~=maxInclOutc
	% display 'Problems with the maximum number of included outcomes'
% end


%Objects describing the variables
maxMissIter=zeros(SVar,1); %maximum number of missing iteration-specific variables
dmydataA = []; %matrix concatenating dmydata's
for ss=1:SVar
eval(['dmydataA=[dmydataA dmydata' num2str(ss) '];']);
	eval(['dl=size(dv' num2str(ss) ');']);
	numOutVar(ss,1)=dl(1,2);
	if dl>1
		typeVarId(ss,1)=5;
	end
	clear dl;
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

%getting parameter description vector
SVar1=SVar;
kmat=[SVar1;indFirCoefOb;indFirCoefUnob;indFirCoefIds];


%getting parameters vector
beta=ones(d_beta,1);
alpha=ones(d_alpha,1);
sigma=ones(d_sigma,1);
delta0=[beta;alpha;sigma];
delta0=delta0+(0.5-rand(d_beta+d_alpha+d_sigma,1));

delta=[d_beta;d_alpha;d_sigma;delta0];


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


%Factor draws
numVarDrawn=maxNumFa;

if maxNumFa==0
drawFileCount=1;
numDraws=1;
end

drawsCount=numDraws/drawFileCount; %per file


drawFileCountMiss=drawFileCount; %number of files in which the random draws are stored /idiosyncratic shocks for missing variables/
numDrawsMiss=numDraws; % number of random draws in each files  /idiosyncratic shocks for missing variables/
drawsCountMiss=drawsCount;

%Getting the objects for for the regressors and th dependent variables

indN=zeros(N,1); %to which group the individual belongs
commonN=ceil(N/GroupN); %number of individuals in "main" groups
minorN=floor(N/GroupN); %number of individuals in the other groups
minorE=rem(N,GroupN);
N1=zeros(GroupN,1); %number of individuals in each group
N2=zeros(GroupN,1); %number of indivisuals in all previous groups
for g=1:GroupN
	if g<GroupN
		N2(g+1,1)=N2(g,1);
	end
	if g<=minorE 
		N1(g,1)=commonN;
		for i=1:commonN
			if g<GroupN
				N2(g+1,1)=N2(g+1,1)+1;
			end
			indN(N2(g,1)+i,1)=g;
		end
	else
		N1(g,1)=minorN;
		for i=1:minorN
			if g<GroupN
				N2(g+1,1)=N2(g+1,1)+1;
			end
			indN(N2(g,1)+i,1)=g;
		end
	end
end

AdrawFiles{1,drawFileCountMiss}=[]; %object with draws for factors
AdrawFilesMiss{1,drawFileCountMiss}=[]; %object with draws for missing variables
Axxmat{1,GroupN}=[]; %object with variables
Admat{1,GroupN}=[]; %object with description of variables
Arrmat{1,GroupN}=[]; %object with indexes for random draws for factors 
Amrmat{1,GroupN}=[]; %object with indexes for random draws for missing variables 
Axxmat_size=zeros(1,GroupN); % size of each xxmat
AVN = zeros(1,GroupN); %number of variables in each group
ANG = zeros(1,GroupN);
AMNG = zeros(1,GroupN);
AnumEqG = zeros(1,GroupN);
AnumFacG = zeros(1,GroupN);
AnumRepG = zeros(1,GroupN);
AvarPerIndividual = zeros(commonN,GroupN); %number of variables per individual
ArowVarIndex = zeros(commonN,GroupN); %index where the data for individual n starts in xxmat
AindVarData = zeros(1,GroupN); %index where the data for a variable x starts in xxmat
AvarId = zeros(1,GroupN); %identity of the variable
AKG = zeros(commonN,GroupN);
AMEG = zeros(commonN,GroupN);
AMFG = zeros(commonN,GroupN);
AMRG = zeros(commonN,GroupN);
AindDrawPerson=zeros(commonN,GroupN); %index where the random draw for individual n starts
AnumVarDrawnMiss=zeros(commonN,GroupN);
AindDrawPersonMiss=zeros(commonN,GroupN);

% for tr=1:drawFileCount
	% AdrawFiles{1,tr}=[];
% end		
% for tr1=1:drawFileCountMiss
	% AdrawFilesMiss{1,tr1}=[];
% end	

defaultLeap=1000;
NZ = N*defaultLeap;
kad=0;
while kad==0
	NZ=NZ+1;
	kad1=isprime(NZ);
	if kad1==1
		defaultLeap=(NZ-1)/N;
		kad=1;
	end
end
defaultSkip=10000;


for kk=1:GroupN
	if kk<=minorE
		NC1=N2(kk,1)+1;
		NC2=N2(kk,1)+commonN;
		ND=commonN;
	else
		NC1=N2(kk,1)+1;
		NC2=N2(kk,1)+minorN;
		ND=minorN;
	end
	kj=0;	
	sj=0;
	clear Axxmat1
	Axxmat1=zeros(commonN*250*30,1);
	for tr=1:drawFileCount
		AdrawFilesIter{1,tr}=[];
	end		
	for tr1=1:drawFileCountMiss
		AdrawFilesMissIter{1,tr1}=[];
	end	
	for i=NC1:NC2
		if i>NC1
			ArowVarIndex(i-NC1+1,kk)=ArowVarIndex(i-NC1,kk)+AvarPerIndividual(i-NC1,kk);
			AindDrawPerson(i-NC1+1,kk)=AindDrawPerson(i-NC1,kk)+drawsCount*numVarDrawn;
		end
	
		modTypeId1=zeros(SVar,1); % modified type of the variable
		covId1=zeros(SVar,1); %covariance id of the variables
		auxCov1=zeros(SVar,1); % auxiliary variable for covariances (row number for non-missing variables with missing covariance variables, number of rows where present for missing covariance variables
	
		numInclOutcZ1=zeros(SVar,1);
		indInclOutcZ1 = zeros(SVar,maxInclOutc);
		indInclOutcRegZ1 = zeros(SVar,maxInclOutc);
		indInclOutcTypZ1 = zeros(SVar,maxInclOutc);
	
		indInclOutcZ2 = zeros(SVar,maxInclOutc);
		numMissRegDr1=zeros(SVar,1);
		locMissRegDr1=zeros(SVar,max(maxMissIter));

		nCovId1=0; %counter for covariance groups/number
		cCovId = 0; % current covariance group
		dmydataInd=find(dmydataA(i,:)>0);
		SVar1=length(dmydataInd);

		%SVar1=26;
		ps=0;
		for ss1=1:SVar1 %determining modified types
		
		ss=dmydataInd(1,ss1);
		ps=ps+1;
		eval(['mydata' num2str(ss) '(i,1)=1;'])
		if numOutVar(ss,1)>1
			modTypeId1(ss,1)=6;
		else
			modTypeId1(ss,1)=5;
		end
		gd=ss;
		AindVarData(ArowVarIndex(i-NC1+1,kk)+ps,kk)= kj;
		AvarPerIndividual(i-NC1+1,kk)=AvarPerIndividual(i-NC1+1,kk)+1;
		AvarId(ArowVarIndex(i-NC1+1,kk)+ps,kk)=ss-1; %C++ considered
		eval(['zzmat = [transpose(dv' num2str(gd) '(i,:)); dmydata' num2str(gd) '(i,1); modTypeId1(gd,1); covId1(gd,1); auxCov1(gd,1);transpose(reg' num2str(gd) '(i,:));numInclOutcZ1(gd,1);transpose(indInclOutcZ2(gd,1:numInclOutcA(gd,1)));transpose(indInclOutcRegZ1(gd,1:numInclOutcA(gd,1)));transpose(indInclOutcTypZ1(gd,1:numInclOutcA(gd,1)));numMissRegDr1(gd,1);transpose(locMissRegDr1(gd,1:maxMissIter(gd,1)))];']);
		dj=length(zzmat);
		sj=kj+dj;
		Axxmat1(kj+1:sj)=zzmat;
		Axxmat_size(1,kk)=sj;
		kj=sj;
		timi=toc/60;
		save fras4 gd i kj sj zzmat dj timi SVar1 kk

		end
		


		ANG(i-NC1+1,kk)=nCovId1;
		
		if i>NC1
			AindDrawPersonMiss(i-NC1+1,kk)=AindDrawPersonMiss(i-NC1,kk)+drawsCountMiss*AnumVarDrawnMiss(i-NC1,kk);
		end
		
		for tr=1:drawFileCount
			if maxNumFa>0
				if typeRand>1
					p1=haltonset(maxNumFa,'Skip',defaultSkip+(tr-1)*N*drawsCount*defaultLeap+(i-1)*defaultLeap,'Leap',N*defaultLeap);
					if typeRand>2
						p1=scramble(p1,'RR2');
					end
					ker=reshape(norminv(net(p1,drawsCount))',drawsCount*maxNumFa,1);
				else
					ker=randn(drawsCount*maxNumFa,1);
				end
			else
				ker=1;
			end
			AdrawFilesIter{1,tr}=[AdrawFilesIter{1,tr}; ker];
		end
		for tr=1:drawFileCountMiss
			AdrawFilesMissIter{1,tr}=[AdrawFilesMissIter{1,tr}; 1];
		end
		if i==NC2
			for iu=1:drawFileCount
				AdrawFiles{1,iu}(1:length(AdrawFilesIter{1,iu}),kk)=AdrawFilesIter{1,iu};
			end
			for iu1=1:drawFileCountMiss
				if length(AdrawFilesMissIter{1,iu1})>0
					AdrawFilesMiss{1,iu1}(1:length(AdrawFilesMissIter{1,iu1}),kk)=AdrawFilesMissIter{1,iu1};
				else
					AdrawFilesMiss{1,iu1}(1,kk)=1;
				end
			end
		end
		
	end
	
	AVN(1,kk)=sum(AvarPerIndividual(:,kk)); 
	Axxmat{1,kk}=Axxmat1(1:sj,1);

	sdmat=[ND;0;ND;AVN(1,kk);AMNG(1,kk);ANG(1:ND,kk);AvarPerIndividual(1:ND,kk);ArowVarIndex(1:ND,kk);AindVarData(1:AVN(1,kk),kk);AvarId(1:AVN(1,kk),kk);AKG(1:ND,kk);AMEG(1:ND,kk);AMFG(1:ND,kk);AMRG(1:ND,kk)];

	sdmat1=size(sdmat);
	Admat{1,kk}=sdmat;
	% for tr=1:drawFileCount
		% if maxNumFa>0
			% %AdrawFiles{1,tr}(:,kk)=randn(commonN*drawsCount*numVarDrawn,1);
			% AdrawFiles{1,tr}(1:ND*drawsCount*numVarDrawn,kk)=randn(ND*drawsCount*numVarDrawn,1);
			% %AdrawFiles{1,tr}(1:ND*drawsCount*numVarDrawn,kk)=(tr-1.5)*ones(ND*drawsCount*numVarDrawn,1);

		% else
			% AdrawFiles{1,tr}(1,kk)=1;

		% end
	% end
	
	AnumMissTotal=sum(AnumVarDrawnMiss(:,kk));
	% for kr=1:drawFileCountMiss
		% if AnumMissTotal>0
			% AdrawFilesMiss{1,kr}(1:AnumMissTotal*drawsCountMiss,kk)=randn(AnumMissTotal*drawsCountMiss,1);
			
		% else
			% AdrawFilesMiss{1,kr}(1,kk)=1;

		% end
	
	% end
	

	smrmat=[drawFileCountMiss;numDrawsMiss;drawsCountMiss;AindDrawPersonMiss(1:ND,kk)];
	smrmat1(1,kk)=length(smrmat);
	Amrmat{1,kk}=smrmat;
	srrmat=[drawFileCount;numDraws;numVarDrawn;drawsCount;AindDrawPerson(1:ND,kk)];
	srrmat1(1,kk)=length(srrmat);
	Arrmat{1,kk}=srrmat;

end

maxxsize=max(max(Axxmat_size));

toc
sas=toc;
save -v7.3 finput1a typeVarId  numOutVar d_omega d_ksi d_mean d_var indFirCoefWgts indFirCoefPts indFirCoefMns indFirCoefVars indFirWgts indFirPts N1 N2  srrmat1 smrmat1 Axxmat mmat SVar SVarOut maxInclOutc maxNumFa uniqueVarId numOutVarM1 numRegr numFa factorId missVar modTypeVarId covId auxCov indRegr numInclOutc indInclOutc indInclOutcReg indInclOutcTyp numMissRegDr locMissRegDr Admat Axxmat_size commonN minorN GroupN indN N AVN AMNG ANG AnumEqG AnumFacG AnumRepG AvarPerIndividual ArowVarIndex AindVarData AvarId AKG AMEG AMFG AMRG kmat SVar1 indFirCoefOb indFirCoefUnob indFirCoefIds delta d_beta d_alpha d_sigma delta0 alpha beta sigma nRestrA nRestrB rA rB nRestrMat rAB drawFileCount Arrmat numDraws numVarDrawn drawsCount AindDrawPerson drawFileCountMiss Amrmat numDrawsMiss drawsCountMiss AindDrawPersonMiss AdrawFiles* AdrawFilesMiss* AnumVarDrawnMiss factorId1





							
				
				
		
