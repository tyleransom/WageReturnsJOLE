
zamma0=zamma;
zammavar0=[zeros(1,length(zammavar));zammavar;zeros(1,length(zammavar))];
zammavar0=[zeros(length(zammavar0),1) zammavar0 zeros(length(zammavar0),1)];
[kss lss]=size(zammavar0);

if rAB>0
	for kk=1:rAB
		zammavar0=[zammavar0(1:nRestrMat(kk,1),:);zeros(1,lss);zammavar0(nRestrMat(kk,1)+1:end,:)];
	end
	[kss1 lss1]=size(zammavar0);
	for kk=1:rAB
		zammavar0=[zammavar0(:,1:nRestrMat(kk,1)) zeros(kss1,1) zammavar0(:,nRestrMat(kk,1)+1:end)];
	end
	
	for kk=1:rAB
		if nRestrMat(kk,3)==1
			zammavar0(nRestrMat(kk,1)+1,:)=zammavar0(nRestrMat(kk,2)+1,:);
			zammavar0(:,nRestrMat(kk,1)+1)=zammavar0(:,nRestrMat(kk,2)+1);
			%zamma0(nRestrMat(kk,1),1) =  zamma(nRestrMat(kk,2),1);
		else
			%zamma0(nRestrMat(kk,1),1) =  nRestrMat(kk,2);
		end
	end
end

zammavar0=zammavar0(2:end-1,2:end-1);


indFirCoefObMA=zeros(SSVarA,1);
indFirCoefUnobMA=zeros(SSVarA,1);
indFirCoefIdsMA=zeros(SSVarA,1);

listobs=[];
indobs=[];
allobs=0;

listunobs=[];
indunobs=[];
allunobs=0;

listids=[];
indids=[];
allids=0;

for k=1:SSVarA
	if varchronmargA(k,1)>0
		if stvar(1,obscoeff,varchronmodmarg(k,1))==0
			intervarobs = varchronmargA(k,1);
		else
			intervarobs = stvar(1,idequation,stvar(1,obscoeff,varchronmodmarg(k,1)));
		end
		fr=find(intervarobs==listobs);
		if length(fr)<1
			allobs=allobs+1;
			listobs(allobs,1) = intervarobs;
			numobs(allobs,1)=numRegr(intervarobs,1)*max(1,(numOutVar(intervarobs,1)-1));
			if length(indobs)<1
				indobs(1,1)=1;
			else
				indobs(allobs,1)=indobs(allobs-1,1)+numobs(allobs-1,1);
			end
			indFirCoefObMA(k,1)=indobs(allobs,1)-1;
		else
			indFirCoefObMA(k,1)=indobs(fr,1)-1;
		end
		
		if stvar(1,unobscoeff,varchronmodmarg(k,1))==0
			intervarunobs = varchronmargA(k,1);
		else
			intervarunobs = stvar(1,idequation,stvar(1,unobscoeff,varchronmodmarg(k,1)));
		end
		fr1=find(intervarunobs==listunobs);
		if length(fr1)<1
			allunobs=allunobs+1;
			listunobs(allunobs,1) = intervarunobs;
			numunobs(allunobs,1)=numFa(intervarunobs,1)*max(1,(numOutVar(intervarunobs,1)-1));
			if length(indunobs)<1
				indunobs(1,1)=1;
			else
				indunobs(allunobs,1)=indunobs(allunobs-1,1)+numunobs(allunobs-1,1);
			end
			indFirCoefUnobMA(k,1)=indunobs(allunobs,1)-1;
		else
			indFirCoefUnobMA(k,1)=indunobs(fr1,1)-1;
		end
		
		intervarids = 0;
		if stvar(1,varcoeff,varchronmodmarg(k,1))==0 & numOutVar(varchronmargA(k,1),1)==1
			intervarids = varchronmargA(k,1);
		elseif stvar(1,varcoeff,varchronmodmarg(k,1))>0
			intervarids = stvar(1,idequation,stvar(1,varcoeff,varchronmodmarg(k,1)));
		end
		if intervarids>0
			fr2=find(intervarids==listids);
			if length(fr2)<1
				allids=allids+1;
				listids(allids,1) = intervarids;
				numids(allids,1)=1;
				if length(indids)<1
					indids(1,1)=1;
				else
					indids(allids,1)=indids(allids-1,1)+numids(allids-1,1);
				end
				indFirCoefIdsMA(k,1)=indids(allids,1)-1;
			else
				indFirCoefIdsMA(k,1)=indids(fr2,1)-1;
			end
		end
	end
end

zammavar1o=[];
zammavar1u=[];
zammavar1i=[];
zamma1o=[];
zamma1u=[];
zamma1i=[];

for ij=1:length(listobs)
	gjo=indFirCoefOb(listobs(ij,1),1);
	zammavar1o = [zammavar1o; zammavar0(gjo+1:gjo+numobs(ij,1),:)];
	zamma1o = [zamma1o; zamma0(gjo+1:gjo+numobs(ij,1),:)];
	
end
for ij=1:length(listunobs)
	gju=indFirCoefUnob(listunobs(ij,1),1)+d_beta;
	zammavar1u = [zammavar1u; zammavar0(gju+1:gju+numunobs(ij,1),:)];
	zamma1u = [zamma1u; zamma0(gju+1:gju+numunobs(ij,1),:)];
end
	for ij=1:length(listids)
	gji=indFirCoefIds(listids(ij,1),1)+d_beta+d_alpha;
	zammavar1i = [zammavar1i; zammavar0(gji+1:gji+numids(ij,1),:)];
	zamma1i = [zamma1i; zamma0(gji+1:gji+numids(ij,1),:)];
end
kaha = d_ksi+d_omega+d_mean+d_var;
if kaha>0
	zammikv = zammavar0(d_beta+d_alpha+d_sigma+1:d_beta+d_alpha+d_sigma+kaha,:);
	zammikc = zamma0(d_beta+d_alpha+d_sigma+1:d_beta+d_alpha+d_sigma+kaha,:);
	zammavar1=[zammavar1o; zammavar1u; zammavar1i; zammikv];
else
	zammavar1=[zammavar1o; zammavar1u; zammavar1i];
end
d_alphaM=length(zamma1u);
d_betaM = length(zamma1o);
d_sigmaM = length(zamma1i);


zammavar2o=[];
zammavar2u=[];
zammavar2i=[];

for ij=1:length(listobs)
	gjo=indFirCoefOb(listobs(ij,1),1);
	zammavar2o = [zammavar2o zammavar1(:,gjo+1:gjo+numobs(ij,1))];
end
for ij=1:length(listunobs)
	gju=indFirCoefUnob(listunobs(ij,1),1)+d_beta;
	zammavar2u = [zammavar2u zammavar1(:,gju+1:gju+numunobs(ij,1))];
end
for ij=1:length(listids)
	gji=indFirCoefIds(listids(ij,1),1)+d_beta+d_alpha;
	zammavar2i = [zammavar2i zammavar1(:,gji+1:gji+numids(ij,1))];
end

if kaha>0
	zammikv1 = zammavar1(:,d_betaM+d_alphaM+d_sigmaM+1:d_betaM+d_alphaM+d_sigmaM+kaha);
	gammavarM=[zammavar2o zammavar2u zammavar2i zammikv1];
	gammaM=[zamma1o; zamma1u; zamma1i;zammikc];
else
	gammavarM=[zammavar2o zammavar2u zammavar2i];
	gammaM=[zamma1o; zamma1u; zamma1i];
end

naha=d_betaM+d_alphaM+d_sigmaM;

%Restrictions
rAM=0; %counter restrictions type A (fixed values) 
rBM=0; %counter restrictions type B (equal parameters) 
nRestr = length(typeRestr); %number of restrictions


nRestrAM=[]; %restrictions type A
nRestrBM=[]; %restrictions type B

nRestrMatM=[nRestrAM;nRestrBM];
if nRestr>0
for nr = 1:nRestr
	if typeRestr(nr,1)==0
		kr=find(varchronmargA==numOutcRestrA(nr,1));
		if length(kr)>0
			if typePar(nr,1)==1
				if parRestrA(nr,1)>0
					rAM=rAM+1;
					nRestrAM(rAM,1)=indFirCoefObMA(kr,1)+(numAltRestrA(nr,1)-1)*numRegrMA(kr,1)+parRestrA(nr,1);
					nRestrAM(rAM,2)=valRestr(nr,1);
					nRestrAM(rAM,3)=0;
				else
					for uy=1:numRegrMA(kr,1)
						rAM = rAM+1;
						nRestrAM(rAM,1)=indFirCoefObMA(kr,1)+(numAltRestrA(nr,1)-1)*numRegrMA(kr,1)+uy;
						nRestrAM(rAM,2)=valRestr(nr,1);
						nRestrAM(rAM,3)=0;
					end
				end
			end
			if typePar(nr,1)==2
				if parRestrA(nr,1)>0
					rAM=rAM+1;
					nRestrAM(rAM,1)=d_betaM+indFirCoefUnobMA(kr,1)+(numAltRestrA(nr,1)-1)*numFa(numOutcRestrA(nr,1),1)+parRestrA(nr,1);
					nRestrAM(rAM,2)=valRestr(nr,1);
					nRestrAM(rAM,3)=0;
				else
					for uye=1:numFa(numOutcRestrA(nr,1),1)
						rAM = rAM+1;
						nRestrAM(rAM,1)=d_betaM+indFirCoefUnobMA(kr,1)+(numAltRestrA(nr,1)-1)*numFa(numOutcRestrA(nr,1),1)+uye;
						nRestrAM(rAM,2)=valRestr(nr,1);
						nRestrAM(rAM,3)=0;
					end
				end
			end	
			if typePar(nr,1)==3
				rAM=rAM+1;
				nRestrAM(rAM,1)=d_betaM+d_alphaM+indFirCoefIdsMA(kr,1);
				nRestrAM(rAM,2)=valRestr(nr,1);
				nRestrAM(rAM,3)=0;
			end
		end
	end
	if typeRestr(nr,1)==1
		kr=find(varchronmargA==numOutcRestrA(nr,1));
		yr=find(varchronmargA==numOutcRestrB(nr,1));
		if length(kr)>0 & length(yr)>0
			if typePar(nr,1)==1
				if parRestrA(nr,1)>0
					rBM=rBM+1;
					nRestrBM(rBM,2)=indFirCoefObMA(kr,1)+(numAltRestrA(nr,1)-1)*numRegrMA(kr,1)+parRestrA(nr,1);
					nRestrBM(rBM,1)=indFirCoefObMA(yr,1)+(numAltRestrB(nr,1)-1)*numRegrMA(yr,1)+parRestrB(nr,1);
					nRestrBM(rBM,3)=1;
				else
					for uyk=1:numRegrMA(kr,1)
						rBM = rBM+1;
						nRestrBM(rBM,2)=indFirCoefObMA(kr,1)+(numAltRestrA(nr,1)-1)*numRegrMA(kr,1)+uyk;
						nRestrBM(rBM,1)=indFirCoefObMA(yr,1)+(numAltRestrB(nr,1)-1)*numRegrMA(yr,1)+uyk;
						nRestrBM(rBM,3)=1;
					end
				end
			end
			if typePar(nr,1)==2
				if parRestrA(nr,1)>0
					rBM=rBM+1;
					nRestrBM(rBM,2)=d_betaM+indFirCoefUnobMA(kr,1)+(numAltRestrA(nr,1)-1)*numFa(numOutcRestrA(nr,1),1)+parRestrA(nr,1);
					nRestrBM(rBM,1)=d_betaM+indFirCoefUnobMA(yr,1)+(numAltRestrB(nr,1)-1)*numFa(numOutcRestrB(nr,1),1)+parRestrB(nr,1);
					nRestrBM(rBM,3)=1;
				else
					for uyej=1:numFa(numOutcRestrA(nr,1),1)
						rBM = rBM+1;
						nRestrBM(rBM,2)=d_betaM+indFirCoefUnobMA(kr,1)+(numAltRestrA(nr,1)-1)*numFa(numOutcRestrA(nr,1),1)+uyej;
						nRestrBM(rBM,1)=d_betaM+indFirCoefUnobMA(yr,1)+(numAltRestrB(nr,1)-1)*numFa(numOutcRestrB(nr,1),1)+uyej;
						nRestrBM(rBM,3)=1;
					end
				end
			end	
			if typePar(nr,1)==3
				rBM=rBM+1;
				nRestrBM(rBM,2)=d_betaM+d_alphaM+indFirCoefIdsMA(kr,1);
				nRestrBM(rBM,1)=d_betaM+d_alphaM+indFirCoefIdsMA(yr,1);
				nRestrBM(rBM,3)=1;
			end
		end
	end
end		

nRestrMatM=[nRestrAM;nRestrBM];
if length(nRestrMatM)>0
	nRestrMatM = sortrows(nRestrMatM,1);
end

rABM=rAM+rBM;

end			


			
			
			
			
		