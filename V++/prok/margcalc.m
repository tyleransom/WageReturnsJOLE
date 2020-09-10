function [finaloutcome] = margcalc(gammaM0)

global argmarg samepeople sameweights IdrawWeightsM IgammaM
global nRestrAM nRestrBM rAM rBM 
global numindiv4 numDrawsM maxPoints maxNumFa factorType factorPoints indFirCoefWgts indFirCoefPts d_ksi d_omega d_mean d_var indFirCoefMns indFirCoefVars naha IdrawFilesM numDrawsM1 AdrawFilesM unobMean

%Restrictions
if rAM>0
	for sA=1:rAM
		gammaM0(nRestrAM(sA,1),1)=nRestrAM(sA,2);
	end
end
if rBM>0
	for sB=1:rBM
		gammaM0(nRestrBM(sB,1),1)=gammaM0(nRestrBM(sB,2),1);
	end
end

argmarg{1,IgammaM} = gammaM0;

gamma_f=gammaM0;
KdrawFilesM=AdrawFilesM;
nind=numindiv4*numDrawsM;
facValues = zeros(nind,maxPoints, maxNumFa);
facProb = zeros(maxPoints,maxNumFa);
for ds=1:maxNumFa
	if factorType(ds,1)==1
		if unobMean==0
			facValues(:,1,ds)=KdrawFilesM(:,ds);
		end
		facProb(1,ds)=1;
		if unobMean==1
			drawFilesA1(:,ds)=zeros(numindiv4,1);
		end
	end
	
	if factorType(ds,1)==2
		pa = factorPoints(ds,1)-1;
		exp_lin_proj_pr = zeros(pa,1);
		denom = 1;
		for qs=1:pa
			exp_lin_proj_pr(qs,1)=exp(gamma_f(naha+indFirCoefWgts(ds,1)+qs,1));
			denom = denom + exp_lin_proj_pr(qs,1);
		end
		
		facValues(:,1,ds) = -0.5*ones(nind,1);
		for qs1 = 1:pa
			facProb(qs1,ds) = (exp_lin_proj_pr(qs1,1)/denom);
			if qs1>1
				denoro = 1;
				kal1 = gamma_f(naha+d_omega+indFirCoefPts(ds,1)+qs1-1,1);
				%kal1=100
				kal = exp(kal1);
				facValues(:,qs1,ds) = (kal/(denoro+kal)-0.5)*ones(nind,1);
				% facValues(:,qs1,ds)
			end
		end
			
		facProb(factorPoints(ds,1),ds) = (1/denom);
		facValues(:,factorPoints(ds,1),ds) = 0.5*ones(nind,1);
		if unobMean==1
			drawFilesA1(numindiv4,ds)=0;
			for gaa=1:factorPoints(ds,1)
				drawFilesA1(:,ds)=drawFilesA1(:,ds)+(facValues(1,gaa,ds)*facProb(gaa,ds)*ones(numindiv4,1));
			end
		end
		% facProb(1,ds)
		% facProb(2,ds)
		% facProb(3,ds)
	end
	
	if factorType(ds,1)==3
		% gamma_f(naha+d_omega+d_ksi+indFirCoefMns(ds,1)+1,1)
		% gamma_f(naha+d_omega+d_ksi+d_mean+indFirCoefVars(ds,1)+1,1)
		if unobMean==0
			facValues(:,1,ds)=gamma_f(naha+d_omega+d_ksi+indFirCoefMns(ds,1)+1,1)+KdrawFilesM(:,ds)*gamma_f(naha+d_omega+d_ksi+d_mean+indFirCoefVars(ds,1)+1,1);
		end
		% facValues(:,1,ds)
		facProb(1,ds)=1;
		if unobMean==1
			drawFilesA1(:,ds)=gamma_f(naha+d_omega+d_ksi+indFirCoefMns(ds,1)+1,1)*ones(numindiv4,1);
		end
	end
	
	if factorType(ds,1)==4
		pa = factorPoints(ds,1)-1;
		exp_lin_proj_pr = zeros(pa,1);
		denom = 1;
		for qs=1:pa
			exp_lin_proj_pr(qs,1)=exp(gamma_f(naha+indFirCoefWgts(ds,1)+qs,1));
			denom = denom + exp_lin_proj_pr(qs,1);
		end
		
		for qs1 = 1:pa
			facProb(qs1,ds) = (exp_lin_proj_pr(qs1,1)/denom);
		end
			
		facProb(factorPoints(ds,1),ds) = (1/denom);
		
		paa=pa+1;
		if unobMean==0
			for qss=1:paa
				facValues(:,qss,ds)=gamma_f(naha+d_omega+d_ksi+indFirCoefMns(ds,1)+qss,1)+KdrawFilesM(:,ds)*gamma_f(naha+d_omega+d_ksi+d_mean+indFirCoefVars(ds,1)+qss,1);
			end
		end
		if unobMean==1
			drawFilesA1(numindiv4,ds)=0;
			for qss1=1:paa
				drawFilesA1(:,ds)=drawFilesA1(:,ds)+(facProb(qss1,ds)*gamma_f(naha+d_omega+d_ksi+indFirCoefMns(ds,1)+qss1,1))*ones(numindiv4,1);
			end	
		end
	end
	
end

if unobMean==0 & maxNumFa>0
	drawFilesA1 = [];
	drawFilesB = zeros(nind,maxNumFa);
	drawWeightsA1 = [];
	zink = zeros(maxNumFa,1);
	bink = zeros(maxNumFa,1);
	probi = (1/numDrawsM)*ones(maxNumFa+1,1);
	zout=2;
	% kt=0;
	maxNumFa1 = maxNumFa+1;
			
	while (zout>1)
		zoutM1 = zout - 1;
		zoin = factorPoints(zoutM1,1);
		zin = zink(zoutM1,1)+1;
		zink(zoutM1,1) = zin;
						
		if (zink(zoutM1,1)>zoin)
			zout = zout - 1;
								
		elseif (zoutM1<maxNumFa1)
				
			drawFilesB(:,zoutM1)= facValues(:,zin,zoutM1);
			probi(zout,1)=probi(zoutM1)*facProb(zin,zoutM1);
					
			if (zout<maxNumFa1)
				zink(zout,1) = 0;
				zout = zout +1;
						
			else
				drawFilesA1=[drawFilesA1;reshape(drawFilesB',numDrawsM*maxNumFa,numindiv4)];
				drawWeightsA1=[drawWeightsA1;reshape((probi(zout)*ones(nind,1)),numDrawsM,numindiv4)];
			end
		end
	end					

	drawFilesA2=reshape(drawFilesA1,numindiv4*numDrawsM1*maxNumFa,1);
	drawWeightsA2=reshape(drawWeightsA1,numindiv4*numDrawsM1,1);
elseif unobMean==1 & maxNumFa>0
	drawWeightsA2=ones(numindiv4*numDrawsM1,1);
	drawFilesA2=reshape(drawFilesA1',numindiv4*numDrawsM1*maxNumFa,1);
end
if maxNumFa==0
	drawFilesA2=1;
	drawWeightsA2=ones(numindiv4*numDrawsM1,1);
end

argmarg{1,IdrawWeightsM} = drawWeightsA2;
argmarg{2,IdrawWeightsM} = drawWeightsA2;
argmarg{1,IdrawFilesM} = drawFilesA2;
argmarg{2,IdrawFilesM} = drawFilesA2;

[AmatrEAZ AmatrEIZ AmatrWZ AmatrMUZ AmatrPIZ]=marg(argmarg{1,:});
	
if samepeople==1 & sameweights==1
	argmarg{2,IdrawWeightsM} = AmatrWZ;
% else
	% argmarg{2,IdrawWeightsM} = argmarg{1,IdrawWeightsM};
end

argmarg{2,IgammaM} = gammaM0;

[BmatrEAZ BmatrEIZ BmatrWZ BmatrMUZ BmatrPIZ]=marg(argmarg{2,:});
	
finaloutcome1 = BmatrEAZ - AmatrEAZ;
finaloutcome = finaloutcome1;