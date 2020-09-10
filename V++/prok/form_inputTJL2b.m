clear
tic
load model_all;
rand('seed',12345);
randn('seed',12345);
maxMissIter=zeros(SVar,1); %maximum number of missing iteration-specific variables
dmydataA = []; %matrix concatenating dmydata's
mydata = zeros(N,SVar); %auxliary, whether the variable at all in the estimation routine
for ss=1:SVar
	eval(['dmydataA=[dmydataA dmydata' num2str(ss) '];']);
	eval(['dl=size(dv' num2str(ss) ');']);
	numOutVar(ss,1)=dl(1,2);
	if dl>1
		typeVarId(ss,1)=5;
	end
	clear dl;
end

%Getting the objects for for the regressors and th dependent variables
%number of groups in which the estimation process is divided
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

Axxmat{1,GroupN}=[]; %object with variables
Admat{1,GroupN}=[]; %object with description of variables
Axxmat_size=zeros(1,GroupN); % size of each xxmat
AVN = zeros(1,GroupN); %number of variables in each group
ANG = zeros(1,GroupN);
AMNG = zeros(1,GroupN);
AnumEqG{1,GroupN} = []; 
AnumFacG{1,GroupN} = [];
AnumRepG{1,GroupN} = [];
AvarPerIndividual = zeros(commonN,GroupN); %number of variables per individual
ArowVarIndex = zeros(commonN,GroupN); %index where the data for individual n starts in xxmat
AindVarData = zeros(1,GroupN); %index where the data for a variable x starts in xxmat
AvarId = zeros(1,GroupN); %identity of the variable
AKG = zeros(commonN,GroupN);
AMEG = zeros(commonN,GroupN);
AMFG = zeros(commonN,GroupN);
AMRG = zeros(commonN,GroupN);



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
	numEqG1=zeros(ND,MNG); %number of rows in the covariance group per person
	numFacG1=zeros(ND,MNG); %number of columns in the covariance groups per person
	numRepG1=zeros(ND,MNG); %number of replications of the covariance matrix
	for i=NC1:NC2
		if i>NC1
			ArowVarIndex(i-NC1+1,kk)=ArowVarIndex(i-NC1,kk)+AvarPerIndividual(i-NC1,kk);
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
		
	end
	
	AVN(1,kk)=sum(AvarPerIndividual(:,kk)); 
		%Check consistency
	MNG1=max(ANG(:,kk));
	if MNG>MNG1
		numEqG1(:,MNG1+1:MNG)=[];
		numFacG1(:,MNG1+1:MNG)=[];
		numRepG1(:,MNG1+1:MNG)=[];
		AMNG(1,kk)=MNG1;
	end

	if AMNG(1,kk)==1
		AMEG(1:ND,kk)=numEqG1;
		AMFG(1:ND,kk)=numFacG1;
		AMRG(1:ND,kk)=numRepG1;
	end

	if AMNG(1,kk)>1
		AMEG(1:ND,kk)=max(numEqG1')';
		AMFG(1:ND,kk)=max(numFacG1')';
		AMRG(1:ND,kk)=max(numRepG1')';
	end

	AnumEqG{1,kk} = reshape(numEqG1,ND*AMNG(1,kk),1);
	AnumFacG{1,kk} = reshape(numFacG1,ND*AMNG(1,kk),1);
	AnumRepG{1,kk} = reshape(numRepG1,ND*AMNG(1,kk),1);
		
	Axxmat{1,kk}=Axxmat1(1:sj,1);

	sdmat=[ND;0;ND;AVN(1,kk);AMNG(1,kk);ANG(1:ND,kk);AnumEqG{1,kk};AnumFacG{1,kk};AnumRepG{1,kk};AvarPerIndividual(1:ND,kk);ArowVarIndex(1:ND,kk);AindVarData(1:AVN(1,kk),kk);AvarId(1:AVN(1,kk),kk);AKG(1:ND,kk);AMEG(1:ND,kk);AMFG(1:ND,kk);AMRG(1:ND,kk)];

	sdmat1=size(sdmat);
	Admat{1,kk}=sdmat;
	
	
end

save -v7.3 finput1ba


