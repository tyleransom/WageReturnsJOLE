function [numindiv1 thresholdvar legStMar legAuxMar varinterM uniqueVarIdE uniqueVarIdM indRegrM numRegrM regr defau fixedvarvalue SSVar sizeoutputI sizeoutputF numOutVarM maxNumOutVarM fixend varchronmarg] = margprep(Current,varchronmodmarg)

global varlistchronmod varlistchron numRegr typeVarId numOutVar SVar KVar iddep varnumber N idsum iddep
for ha=1:SVar
	eval(['global mreg' num2str(ha) ' reg' num2str(ha) ' dmydata' num2str(ha)  ' dv' num2str(ha) ''])
end
for ha=1:KVar
	eval(['global default' num2str(ha) ''])
end
for ha=1:varnumber
	eval(['global varval' num2str(ha) ' msvar' num2str(ha) ''])
end

numindiv1=max(1,Current.numindiv);

legAuxMar=[];
% firstvar=find(varlistchronmod==Current.earlyvar1,1);
% lastvar=find(varlistchronmod==Current.varinter(1,end),1);

% for i=1:length(Current.fixedvar)
	% fas=find(varlistchronmod==Current.fixedvar(1,i),1);
	% firstvar=min(fas,firstvar);
	% lastvar=max(fas,lastvar);
% end

% for j=1:length(Current.varinter)
	% fas=find(varlistchronmod==Current.varinter(1,j),1);
	% firstvar=min(fas,firstvar);
	% lastvar=max(fas,lastvar);
% end

% varchronmarg=varlistchron(firstvar:lastvar,1);
% varchronmodmarg=varlistchronmod(firstvar:lastvar,1);
fixend=-999;
SSVar=length(varchronmodmarg);
varchronmarg=zeros(SSVar,1);
for gh=1:SSVar
	nas = find(iddep==varchronmodmarg(gh,1));
	if length(nas)>0
		varchronmarg(gh,1)=nas;
	else
		mad = find(idsum==varchronmodmarg(gh,1));
		varchronmarg(gh,1)=-mad;
	end
	% if varchronmarg(gh,1)>0
		% varchronmodmarg(gh,1)=iddep(varchronmarg(gh,1),1);
	% else
		% varchronmodmarg(gh,1)=idsum(-varchronmarg(gh,1),1);
	% end
end

fixedvarvalue=-999*ones(numindiv1*SSVar,1);
thresholdvar=find(varchronmodmarg==Current.earlyvar)-1;

for h=1:SVar
	mas=find(varchronmarg==h);
	if length(mas)==0
		legStMar(h,1)=-999;
	else
		legStMar(h,1)=mas-1;
	end
end

for k=-KVar:-1
	mas=find(varchronmarg==k);
	if length(mas)==0
		legAuxMar(-k,1)=-999;
	else
		legAuxMar(-k,1)=mas-1;
	end
end

for jj=1:length(Current.varinter)
	fasj=find(varchronmodmarg==Current.varinter(1,jj),1);
	varinterM(jj,1)=fasj-1; %index of the variables which are outcomes
	if jj==1
		uniqueVarIdE(jj,1)=0; % if outcome of interest - where does it go in the output (first alternative)
	else
		uniqueVarIdE(jj,1)=uniqueVarIdE(jj-1,1)+bs1;
	end

	kas = find(iddep==Current.varinter(1,jj));
	if length(kas)>0
		bs1 =numOutVar(kas,1);
	else
		bs1 = 1;
	end
	
end

sizeoutputF=uniqueVarIdE(length(Current.varinter),1)+bs1; %size final input

locoutcid=-999*ones(length(varchronmarg),1); %location of outcomes for the relevant variables of interest 
bs=0;
sd=0;
gd=0;
for gg=1:SSVar

	uniqueVarIdM(gg,1)=bs; %for all variables no matter if of interest
	if varchronmarg(gg,1)>0
		indRegrM(gg,1)=sd;
		numRegrM(gg,1)=numRegr(varchronmarg(gg,1),1);
		numOutVarM(gg,1)=numOutVar(varchronmarg(gg,1),1);
	else
		indRegrM(gg,1)=gd;
		numRegrM(gg,1)=0;
		numOutVarM(gg,1)=1;
	end
		
	
	if varchronmarg(gg,1)>0
		bs =numOutVar(varchronmarg(gg,1),1)+bs;
		sd = numRegr(varchronmarg(gg,1),1)+sd;
	else
		bs = bs+1;
		gd = gd+1;
	end
	
end

maxNumOutVarM=max(numOutVarM);
sizeoutputI=bs; %size intermediary input
% for gg=1:SVar
	% gas = find(varinterM==gg-1);
	% if length(gas)>0
		% locoutcid(gg,1)=uniqueVarIdM(gas,1);
	% end
% end

regr=[];
defau=[];


for tr=1:SSVar
	if varchronmarg(tr,1)>0
		is = varchronmarg(tr);
		eval(['rs1 = reg' num2str(is) ';'])
		if Current.numindiv==0
			eval(['ms = mreg' num2str(is) ';'])
			eval(['lds = kron(ones(1,numRegrM(tr,1)),(dmydata' num2str(is) '>0));'])
			regr=[regr sum(ms.*lds.*rs1,1)./sum(ms.*lds,1)];
			mas=find(Current.fixedvar==varchronmodmarg(tr,1));
			if length(mas)>0
				if mas>fixend
					fixend=tr;
				end
				fixedvarvalue(tr,1)=Current.fixedvarval(1,mas);
			end
		else
			for ii=1:numindiv1
				regr=[regr rs1(Current.indid(1,ii),:)];
			end
			las=find(Current.fixedvar==varchronmodmarg(tr,1));
			if length(las)>0
				if las>fixend
					fixend=tr;
				end
				if Current.fixedvarval(1,las)==0
					eval(['ds1 = dv' num2str(is) ';'])
					eval(['ms1 = msvar' num2str(is) ';'])
				else
					eval(['ds1 = varval' num2str(Current.fixedvarval(1,las)) ';'])
					ms1=ones(N,1);
				end
				ja=size(ds1);
				if ja(1,2)==1
					for ii=1:numindiv1
						if ms1(Current.indid(1,ii),1)>0
							fixedvarvalue((tr-1)*numindiv1+ii,1)=ds1(Current.indid(1,ii),1);
						else
							fixedvarvalue((tr-1)*numindiv1+ii,1)=-999;
						end
					end
				else
					for ii=1:numindiv1
						if ms1>0
							for jj=1:numOutVar(is,1)
								if ds1(Current.indid(1,ii),jj)==1
									fixedvarvalue((tr-1)*numindiv1+ii,1)=jj;
								end
							end
						else
							fixedvarvalue((tr-1)*numindiv1+ii,1)=-999;
						end
					end	
				end
			end
		end
	else
		if Current.numindiv==0
			is2 = -varchronmarg(tr);
			eval(['defau=[defau  mean(default' num2str(is2) ')];'])
			mas1=find(Current.fixedvar==varchronmodmarg(tr,1));
			if length(mas1)>0
				if mas1>fixend
					fixend=tr;
				end
				fixedvarvalue(tr,1)=Current.fixedvarval(1,mas1);
			end
		else
			is2 = -varchronmarg(tr);
			for ii=1:numindiv1
				eval(['defau=[defau  default' num2str(is2) '(Current.indid(1,ii),1)];'])
			end
			las1=find(Current.fixedvar==varchronmodmarg(tr,1));
			if length(las1)>0
				if las1>fixend
					fixend=tr;
				end
				is1 = varchronmarg(tr);
				if Current.fixedvarval(1,las1)==0
					eval(['ds1 = dv' num2str(is1) ';'])
					eval(['ms1 = msvar' num2str(is1) ';'])
				else
					eval(['ds1 = varval' num2str(Current.fixedvarval(1,las1)) ';'])
					ms1=ones(N,1);
				end
				for ii=1:numindiv1
					if ms1(Current.indid(1,ii),1)>0
						fixedvarvalue((tr-1)*numindiv1+ii,1)=ds1(Current.indid(1,ii),1);
					else
						fixedvarvalue((tr-1)*numindiv1+ii,1)=-999;
					end
				end
			end
		end
	end
end
		
	

			
				
		



