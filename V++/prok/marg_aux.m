gammaM0=gammaM;
gamma_f=gammaM0;
nind=numindiv4*numDrawsM;
facValues = zeros(nind,maxPoints, maxNumFa);
facProb = zeros(maxPoints,maxNumFa);
for ds=1:maxNumFa
	if factorType(ds,1)==1
		facValues(:,1,ds)=AdrawFilesM(:,ds);
		facProb(1,ds)=1;
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
				kal = exp(kal1);
				facValues(:,qs1,ds) = (kal/(denoro+kal)-0.5)*ones(nind,1);
			end
		end
			
		facProb(factorPoints(ds,1),ds) = (1/denom);
		facValues(:,factorPoints(ds,1),ds) = 0.5*ones(nind,1);
	end
	
	if factorType(ds,1)==3
		facValues(:,1,ds)=gamma_f(naha+d_omega+d_ksi+indFirCoefMns(ds,1)+1,1)+AdrawFilesM(:,ds)*gamma_f(naha+d_omega+d_ksi+d_mean+indFirCoefVars(ds,1)+1,1);
		facProb(1,ds)=1;
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
		for qss=1:paa
			facValues(:,qss,ds)=gamma_f(naha+d_omega+d_ksi+indFirCoefMns(ds,1)+qss,1)+AdrawFilesM(:,ds)*gamma_f(naha+d_omega+d_ksi+d_mean+indFirCoefVars(ds,1)+qss,1);
		end
	end
	
end



drawFilesA = [];
drawFilesA1 = [];
drawFilesB = zeros(nind,maxNumFa);
drawWeightsA = [];
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
			% kt = kt+1;
			drawFilesA=[drawFilesA;drawFilesB];
			drawFilesA1=[drawFilesA1;reshape(drawFilesB',numDrawsM*maxNumFa,numindiv4)];
			drawWeightsA=[drawWeightsA;probi(zout)*ones(nind,1)];
			drawWeightsA1=[drawWeightsA1;reshape((probi(zout)*ones(nind,1)),numDrawsM,numindiv4)];
		end
	end
end					

drawFilesA2=reshape(drawFilesA1,numindiv4*numDrawsM1*maxNumFa,1);
drawWeightsA2=reshape(drawWeightsA1,numindiv4*numDrawsM1,1);
% drawFilesC = reshape(drawFilesA',drawsCountA*YmaxNumFa,1);
% drawFilesA1 = kron(ones(NA,1),drawFilesC);
% drawWeightsA1 = kron(ones(NA,1),drawWeightsA);