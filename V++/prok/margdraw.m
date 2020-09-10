%numVarDrawnM=0; %drawn from continuous
maxPoints = max(factorPoints);
if length(maxPoints)<1
	maxPoints=0;
end
numDrawsM1=numDrawsM; %all draws
for pl=1:maxNumFa
	% if factorType(pl,1)==1 | factorType(pl,1)==3 | factorType(pl,1)==4
		% numVarDrawnM = numVarDrawnM+1;
	% end
	numDrawsM1=numDrawsM1*factorPoints(pl,1);
end

%numVarDrawnM1=maxNumFa; %all drawn
numVarDrawnM=maxNumFa;

if maxNumFa==0 | unobMean==1
	numDrawsM=1;
	numDrawsM1=1;
end


numindiv3=[max(Before.numindiv,1);max(After.numindiv,1)];
numindiv4=max(numindiv3);


AindDrawPersonM=zeros(numindiv4,1);
AdrawWeightsM=[];
if numindiv4>1
	for iu=2:numindiv4
		AindDrawPersonM(iu,1)=AindDrawPersonM(iu-1,1)+numDrawsM1*numVarDrawnM;
	end
end

defaultLeapM=1000;
NZ1 = numindiv4*defaultLeapM;
lkad=0;
while lkad==0
	NZ1=NZ1+1;
	lkad1=isprime(NZ1);
	if lkad1==1
		defaultLeapM=(NZ1-1)/numindiv4;
		lkad=1;
	end
end
defaultSkipM=10000;

if unobMean==1 & maxNumFa>0
	AdrawFilesM = zeros(numindiv4*numVarDrawnM,1);
	AdrawWeightsM = ones(numindiv4,1);
else
	if maxNumFa>0
		if numVarDrawnM>0
			if typeRandM>1
				p1=haltonset(numVarDrawnM,'Skip',defaultSkipM,'Leap',defaultLeapM);
				if typeRandM>2
					p1=scramble(p1,'RR2');
				end
				%ker=reshape(norminv(net(p1,numindiv4*numDrawsM))',numindiv4*numVarDrawnM*numDrawsM,1);
				ker = norminv(net(p1,numindiv4*numDrawsM));
			else
				%ker=randn(numindiv4*numVarDrawnM*numDrawsM,1);
				ker=randn(numindiv4*numDrawsM,numVarDrawnM);
			end
		else
			ker=1;
		end
	
	
		AdrawFilesM=ker;
		AdrawWeightsM=ones(numindiv4*numDrawsM,1)/numDrawsM;

	else %unnecessary?
		AdrawFilesM=1;
		AdrawWeightsM=ones(numindiv4*numDrawsM,1);;

	end
	
end