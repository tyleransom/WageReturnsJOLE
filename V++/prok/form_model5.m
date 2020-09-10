load modeldescr
kj=size(stvar);
numVarT=kj(1,3);
numreg=zeros(numVarT,1); %number regressors per equation,
idreg=zeros(1,1,2); %id of regressors per equation
interreg = zeros(1,1); %if regressor an interaction
numregA=zeros(numVarT,1); %number regressors per equation - no interactions
idregA=zeros(1,1); %id of regressors per equation - no interactionss
iddep=zeros(1,1); %id outcomes
idsum = zeros(1,1); %id auxilary
numinter=zeros(numVarT,1); %number of interactions
SVar=0; %number of outcome equations - counter
KVar=0; %number of auxiliary equations - counter

interone=zeros(numVarT,1); %location of the first variable in the interaction
intertwo=zeros(numVarT,1); %location of the second variable in the interaction
interboth=zeros(numVarT,1); %location of the interaction
intermult=zeros(numVarT,1); %multiplicator for interactions;


typeRestr=[]; %matrix type restrictions
		
restrnum=0; %number of restrictions
for yi =1:numVarT %looping over all standard variables
	nout = stvar(1,numrows,yi);
	if nout>0
		eval(['ce = varval' num2str(yi) ';'])
		eval(['dans = size(varval' num2str(yi) ',2);']) 
		bd=stvar(1,chng,yi);
		kd=stvar(1,discrete,yi);
		if kd==0
			me1=(1-isnan(ce));
			ce(isnan(ce))=0;
			if (stvar(1,dependent,yi)==1 | stvar(1,dependent,yi)==4) & stvar(1,present,yi)==1
				eval(['me1 = (msvar' num2str(yi) '>0);'])
			end
			
			stvar(1,average,yi)=sum(ce.*me1,1)./sum(me1,1);
			if stvar(1,varcoeff,yi)<-900 & stvar(1,obscoeff,yi)>-900
				stvar(1,average,yi)=stvar(1,average,stvar(1,obscoeff,yi));
			end
			if bd==0
				stvar(1,chng,yi)=abs(stvar(1,average,yi)/100);
			end
		end
		if kd==1
			if bd==0
				stvar(1,chng,yi)=1;
			end
		end
		for hg=1:nout %looping over all entries for the variable
			de = stvar(:,:,yi); 
			eval(['ce = varval' num2str(yi) ';'])
			ce(isnan(ce))=0;
			if de(hg,present)==1 & (de(hg,dependent)==0 | de(hg,dependent)==2 | de(hg,dependent)==3) %forming values for the missing entries
				if de(hg,dependent)==2
					ce = ce(:,stvar(hg,alter,yi));
				end
				if (de(1,dependent)==1  | de(1,dependent)==4) & de(hg,dependent)~=3 
					eval(['me = (msvar' num2str(yi) '>0);'])
					if de(1,present)==1
						ce = me.*ce+(ones(N,1)-me).*ones(N,1); %values when the regressor (which is also an outcome) is missing
					end
				end
				if de(hg,interaction)==0 & de(hg,multiplier)>0
					ce = ce*de(hg,multiplier);
				end
				
							
				fa = de(hg,idmodel); %id of the outcome in which the variable is a regressor
				na=0;
				if fa>0
					na=stvar(1,present,fa)*stvar(1,dependent,fa);
				end
				if na==1  %if outcome in the model
					if de(hg,interaction)>0 & de(hg,visitinter)==0
						for kf=1:stvar(1,numrows,de(hg,interaction))
							if stvar(kf,idmodel,de(hg,interaction))==stvar(hg,idmodel,yi) & stvar(kf,interaction,de(hg,interaction))==yi
								stvar(kf,visitinter,de(hg,interaction))=hg;
							end
						end
					end
					de(hg,visitinter)=stvar(hg,visitinter,yi);
					
					if de(hg,interaction)>0 & de(hg,visitinter)>0
						lan = stvar(1,dependent,de(hg,interaction));
						kan = de(1,dependent);
						mg1=ones(N,1);
						mg2=ones(N,1);
						if kan>0
							eval(['mg1 = (msvar' num2str(yi) '>0);'])
						end
						if lan>0
							eval(['mg2 = (msvar' num2str(de(hg,interaction)) '>0);'])
						end
						me=mg1.*mg2;
						eval(['ce = de(hg,multiplier)*ce.*(varval' num2str(de(hg,interaction)) '.*mg2+(1-mg2).*ones(N,1));'])
					end
					
					
					if de(hg,dependent)==0 & de(1,present)==1 & de(1,dependent)==1 & dans==1
						numInclOutcA(de(1,idequation),1)=numInclOutcA(de(1,idequation),1)+1; %updating for main variables - estimation
						
					end
					
					if (de(hg,dependent)==0 | de(hg,dependent)==2 | de(hg,dependent)==3) & de(1,present)==1 & de(1,dependent)==1 
						XnumInclOutcA(de(1,idequation),1)=XnumInclOutcA(de(1,idequation),1)+1; %updating for main variables - marginal effects
					end
					
					
					sa = stvar(1,idequation,fa); %outcome variable index
					
					if sa<1 %if outcome not reached so far
						SVar=SVar+1;
						stvar(1,idequation,fa)=SVar;
						iddep(SVar,1)=fa;
						numInclEq(SVar,1)=0; %number of variables getting into this equation
						numInclEqCond(SVar,1)=0; %number of conditions getting into this equation
						indInclEqIdCond(SVar,1)=0; %ids of conditions getting into this equation
						numCondVar(SVar,1) =  stvar(1,numcond,fa);
						sa=SVar;
						eval(['reg' num2str(sa) '=[];']) %regressors
						eval(['mreg' num2str(sa) '=[];']) %dummy variables for missing regressor
					end
					
					stvar(hg,idequation,yi)=sa;
					de(hg,idequation)=sa;
					
					%if (de(hg,dependent)==0 | de(hg,dependent)==2 | de(hg,dependent)==3) & de(1,present)==1 & de(1,dependent)==1 
					
					if de(hg,interaction)>0 %getting the location of the not interacted version of the variable
					hg1=hg-1;
						for kl=1:hg1
							if de(kl,idequation)==de(hg,idequation) & de(kl,interaction)==0
								de(hg,locnointer)=de(kl,location);
								stvar(hg,locnointer,yi)=de(kl,location);
							end
						end
					end
					%adding the regressor with info
					indinter=0;
					locat=0;
					if de(hg,dependent)~=3 & (de(hg,interaction)==0 | de(hg,visitinter)>0)
						eval(['reg' num2str(sa) '=[reg' num2str(sa) ' ce];'])
						eval(['mout = size(reg' num2str(sa) ');'])
						stvar(hg,location,yi)=mout(1,2);
						de(hg,location)=mout(1,2);
						locat = mout(1,2)-1;
						idreg(mout(1,2),sa,1)=yi;
						numreg(sa,1)=numreg(sa,1)+1;
						interreg(mout(1,2),sa)=0;
						if de(hg,interaction)==0
							numregA(sa,1)=numregA(sa,1)+1;
							idregA(numregA(sa,1),sa)=yi;
						else
							indinter = stvar(stvar(hg,visitinter,yi),locnointer,de(hg,interaction));
							interreg(mout(1,2),sa)=1;
							idreg(mout(1,2),sa,2)=de(hg,interaction);
							numinter(sa,1)=numinter(sa,1)+1;
							intertwo(sa,numinter(sa,1))=indinter-1;
							interone(sa,numinter(sa,1))=stvar(hg,locnointer,yi)-1;
							interboth(sa,numinter(sa,1))=de(hg,location)-1;
							intermult(sa,numinter(sa,1))=de(hg,multiplier);
						end
						
						if (de(1,dependent)==1 | de(1,dependent)==4) & de(1,present)==1
							eval(['mreg' num2str(sa) '=[mreg' num2str(sa) ' me];'])
						else
							eval(['mreg' num2str(sa) '=[mreg' num2str(sa) ' ones(N,1)];'])
						end
						
						
					end
					
					stvar(hg,margtype,yi)=de(hg,dependent);
					if de(hg,dependent)==0
						stvar(hg,margtype,yi)=1;
					end
					
					if de(1,dependent)==1 & de(1,present)==1 & de(hg,dependent)==0 & dans==1 %outcome equation characteristics equation update - estimation
						stvar(hg,locincloutc,yi)=numInclOutcA(de(1,idequation),1);
						indInclOutcId(de(1,idequation),numInclOutcA(de(1,idequation),1))=sa-1;
						indInclOutcRegA(de(1,idequation),numInclOutcA(de(1,idequation),1))=locat;
						indInclOutcTyp1(de(1,idequation),numInclOutcA(de(1,idequation),1))=0;
						indInclOutcMult(de(1,idequation),numInclOutcA(de(1,idequation),1))=0;
						indInclOutcInter(de(1,idequation),numInclOutcA(de(1,idequation),1))=0;
						if de(hg,multiplier)>0
							indInclOutcTyp1(de(1,idequation),numInclOutcA(de(1,idequation),1))=1;
							indInclOutcMult(de(1,idequation),numInclOutcA(de(1,idequation),1))=de(hg,multiplier);
						end
						if de(hg,interaction)>0
							indInclOutcTyp1(de(1,idequation),numInclOutcA(de(1,idequation),1))=2;
							indInclOutcInter(de(1,idequation),numInclOutcA(de(1,idequation),1))=indinter-1;
						end
						
					end
					
					%if de(1,dependent)==1 & de(1,present)==1 & (de(hg,dependent)==0 | de(hg,dependent)==2 | de(hg,dependent)==3) %outcome equation characteristics equation update - marginal effects
					if de(1,dependent)==1 & de(1,present)==1 & (de(hg,dependent)==0 | de(hg,dependent)==2 | de(hg,dependent)==3) %outcome equation characteristics equation update - marginal effects
						stvar(hg,locxincloutc,yi)=XnumInclOutcA(de(1,idequation),1);
						XindInclOutcId(de(1,idequation),XnumInclOutcA(de(1,idequation),1))=sa-1;
						XindInclOutcRegA(de(1,idequation),XnumInclOutcA(de(1,idequation),1))=locat;
						XindInclOutcTyp1(de(1,idequation),XnumInclOutcA(de(1,idequation),1))=0;
						XindInclOutcTyp2(de(1,idequation),XnumInclOutcA(de(1,idequation),1))=0; %if creating a condition
						XindInclOutcTyp3(de(1,idequation),XnumInclOutcA(de(1,idequation),1))=0; %if going to auxilary
						XindInclOutcMult(de(1,idequation),XnumInclOutcA(de(1,idequation),1))=0;
						XindInclOutcInter(de(1,idequation),XnumInclOutcA(de(1,idequation),1))=0;
						XindInclOutcAlter(de(1,idequation),XnumInclOutcA(de(1,idequation),1))=de(hg,alter); 
						XindInclOutcMinVal(de(1,idequation),XnumInclOutcA(de(1,idequation),1))=de(hg,minival); 
						XindInclOutcMaxVal(de(1,idequation),XnumInclOutcA(de(1,idequation),1))=de(hg,maxival); 
						if de(hg,multiplier)>0
							XindInclOutcTyp1(de(1,idequation),XnumInclOutcA(de(1,idequation),1))=1;
							XindInclOutcMult(de(1,idequation),XnumInclOutcA(de(1,idequation),1))=de(hg,multiplier);
						end
						if de(hg,interaction)>0
							XindInclOutcTyp1(de(1,idequation),XnumInclOutcA(de(1,idequation),1))=2;
							XindInclOutcInter(de(1,idequation),XnumInclOutcA(de(1,idequation),1))=indinter-1;
						end
						numInclEq(sa,1)=numInclEq(sa,1)+1;
						if hg>1
							if de(hg,interaction)==0 & de(hg,idmodel)~=de(hg-1,idmodel) 
								if de(hg,dependent)==3
									numInclEqCond(sa,1)=numInclEqCond(sa,1)+1;
									indInclEqIdCond(sa,numInclEqCond(sa,1))=de(1,idequation);
								end
							end
						end
						if de(hg,dependent)==3
							XindInclOutcTyp2(de(1,idequation),XnumInclOutcA(de(1,idequation),1))=1;
						end
					end
					
					if de(1,dependent)==4 & hg>0 %outcome equation characteristics equation update
						
						numInclOutcAK(de(1,auxvariable),1)=numInclOutcAK(de(1,auxvariable),1)+1;
						indInclOutcIdK(de(1,auxvariable),numInclOutcAK(de(1,auxvariable),1))=sa-1;
						indInclOutcRegAK(de(1,auxvariable),numInclOutcAK(de(1,auxvariable),1))=locat;
						indInclOutcTyp1K(de(1,auxvariable),numInclOutcAK(de(1,auxvariable),1))=0;
						indInclOutcMultK(de(1,auxvariable),numInclOutcAK(de(1,auxvariable),1))=0;
						indInclOutcInterK(de(1,auxvariable),numInclOutcAK(de(1,auxvariable),1))=0;
						if de(hg,multiplier)>0
							indInclOutcTyp1K(de(1,auxvariable),numInclOutcAK(de(1,auxvariable),1))=1;
							indInclOutcMultK(de(1,auxvariable),numInclOutcAK(de(1,auxvariable),1))=de(hg,multiplier);
						end
						if de(hg,interaction)>0
							indInclOutcTyp1K(de(1,auxvariable),numInclOutcAK(de(1,auxvariable),1))=2;
							indInclOutcInterK(de(1,auxvariable),numInclOutcAK(de(1,auxvariable),1))=indinter-1;
						end
						stvar(hg,locincloutc,yi)=numInclOutcAK(de(1,auxvariable),1);
						
						XnumInclOutcAK(de(1,auxvariable),1)=XnumInclOutcAK(de(1,auxvariable),1)+1;
						XindInclOutcIdK(de(1,auxvariable),XnumInclOutcAK(de(1,auxvariable),1))=sa-1;
						XindInclOutcRegAK(de(1,auxvariable),XnumInclOutcAK(de(1,auxvariable),1))=locat;
						XindInclOutcTyp1K(de(1,auxvariable),XnumInclOutcAK(de(1,auxvariable),1))=0;
						XindInclOutcTyp2K(de(1,auxvariable),XnumInclOutcAK(de(1,auxvariable),1))=0;
						XindInclOutcTyp3K(de(1,auxvariable),XnumInclOutcAK(de(1,auxvariable),1))=0;
						XindInclOutcMultK(de(1,auxvariable),XnumInclOutcAK(de(1,auxvariable),1))=0;
						XindInclOutcInterK(de(1,auxvariable),XnumInclOutcAK(de(1,auxvariable),1))=0;
						XindInclOutcAlterK(de(1,auxvariable),XnumInclOutcAK(de(1,auxvariable),1))=de(hg,alter); 
						XindInclOutcMinValK(de(1,auxvariable),XnumInclOutcAK(de(1,auxvariable),1))=de(hg,minival); 
						XindInclOutcMaxValK(de(1,auxvariable),XnumInclOutcAK(de(1,auxvariable),1))=de(hg,maxival); 
						if de(hg,multiplier)>0
							XindInclOutcTyp1K(de(1,auxvariable),XnumInclOutcAK(de(1,auxvariable),1))=1;
							XindInclOutcMultK(de(1,auxvariable),XnumInclOutcAK(de(1,auxvariable),1))=de(hg,multiplier);
						end
						if de(hg,interaction)>0
							XindInclOutcTyp1K(de(1,auxvariable),XnumInclOutcAK(de(1,auxvariable),1))=2;
							XindInclOutcInterK(de(1,auxvariable),XnumInclOutcAK(de(1,auxvariable),1))=indinter-1;
						end
						numInclEq(sa,1)=numInclEq(sa,1)+1;
						if hg>1
							if de(hg,interaction)==0 & de(hg,idmodel)~=de(hg-1,idmodel) 
								if de(hg,dependent)==3
									numInclEqCond(sa,1)=numInclEqCond(sa,1)+1;
									indInclEqIdCond(sa,numInclEqCond(sa,1))=-de(1,auxvariable);
								end
							end
						end
						stvar(hg,locxincloutc,yi)=XnumInclOutcAK(de(1,auxvariable),1);
						if de(hg,dependent)==3
							XindInclOutcTyp2K(de(1,auxvariable),XnumInclOutcAK(de(1,auxvariable),1))=1;
						end
					end
					
					if de(hg,interaction)>0 & de(hg,visitinter)>0 %adjusting for interaction not considered before
						if stvar(1,auxvariable,de(hg,interaction))==0 & stvar(1,dependent,de(hg,interaction))==1 & stvar(1,present,de(hg,interaction))==1
							eval(['dans1 = size(varval' num2str(de(hg,interaction)) ',2);']) 
							if dans1==1
								indInclOutcInter(stvar(1,idequation,de(hg,interaction)),stvar(de(hg,visitinter),locincloutc,de(hg,interaction)))=de(hg,locnointer)-1; 
								indInclOutcRegA(stvar(1,idequation,de(hg,interaction)),stvar(de(hg,visitinter),locincloutc,de(hg,interaction)))=de(hg,location)-1; 
							end
							XindInclOutcInter(stvar(1,idequation,de(hg,interaction)),stvar(de(hg,visitinter),locxincloutc,de(hg,interaction)))=de(hg,locnointer)-1; 
							XindInclOutcRegA(stvar(1,idequation,de(hg,interaction)),stvar(de(hg,visitinter),locxincloutc,de(hg,interaction)))=de(hg,location)-1; 
							% XindInclOutcAlter(stvar(1,idequation,de(hg,interaction)),stvar(de(hg,visitinter),locxincloutc,de(hg,interaction)))=de(hg,alter); 
							% XindInclOutcMinVal(stvar(1,idequation,de(hg,interaction)),stvar(de(hg,visitinter),locxincloutc,de(hg,interaction)))=de(hg,minival); 
							% XindInclOutcMaxVal(stvar(1,idequation,de(hg,interaction)),stvar(de(hg,visitinter),locxincloutc,de(hg,interaction)))=de(hg,maxival); 
						elseif stvar(1,auxvariable,de(hg,interaction))>0 & stvar(1,dependent),de(hg,interaction)==4 & stvar(1,present,de(hg,interaction))==1
							indInclOutcInterK(stvar(1,auxvariable,de(hg,interaction)),stvar(de(hg,visitinter),locincloutc,de(hg,interaction)))=de(hg,locnointer)-1;
							indInclOutcRegAK(stvar(1,auxvariable,de(hg,interaction)),stvar(de(hg,visitinter),locincloutc,de(hg,interaction)))=de(hg,location)-1; 
							XindInclOutcInterK(stvar(1,auxvariable,de(hg,interaction)),stvar(de(hg,visitinter),locxincloutc,de(hg,interaction)))=de(hg,locnointer)-1; 
							XindInclOutcRegAK(stvar(1,auxvariable,de(hg,interaction)),stvar(de(hg,visitinter),locxincloutc,de(hg,interaction)))=de(hg,location)-1; 
							% XindInclOutcAlterK(stvar(1,auxvariable,de(hg,interaction)),stvar(de(hg,visitinter),locxincloutc,de(hg,interaction)))=de(hg,alter); 
							% XindInclOutcMinValK(stvar(1,auxvariable,de(hg,interaction)),stvar(de(hg,visitinter),locxincloutc,de(hg,interaction)))=de(hg,minival); 
							% XindInclOutcMaxValK(stvar(1,auxvariable,de(hg,interaction)),stvar(de(hg,visitinter),locxincloutc,de(hg,interaction)))=de(hg,maxival); 
						end
						stvar(stvar(hg,visitinter,yi),location,de(hg,interaction))=mout(1,2);
					end
					
					
					
					if de(hg,numberrest)>0
						for ij=1:de(hg,numberrest)
							restrnum=restrnum+1;
							restrid1 = numberrest+(ij-1)*sizeRest;
							if de(hg,restrid1+typeRest)==0
								typeRestr(restrnum,1)=0;
								typePar(restrnum,1)=1;
								numOutcRestrA(restrnum,1)=sa;
								numAltRestrA(restrnum,1)=de(hg,restrid1+numAltRestA);
								parRestrA(restrnum,1)=de(hg,location);
								valRestr(restrnum,1)=de(hg,restrid1+valRest);
								numOutcRestrB(restrnum,1)=0; 
								numAltRestrB(restrnum,1)=0; 
								parRestrB(restrnum,1)=0;
							elseif de(hg,restrid1+typeRest)==1
								typeRestr(restrnum,1)=1;
								typePar(restrnum,1)=1;
								numOutcRestrA(restrnum,1)=sa;
								numAltRestrA(restrnum,1)=de(hg,restrid1+numAltRestA);
								parRestrA(restrnum,1)=de(hg,location);
								valRestr(restrnum,1)=0;
								numOutcRestrB(restrnum,1)=stvar(1,idequation,stvar(de(hg,restrid1+parRestB),idmodel,de(hg,restrid1+numRegRestB))); 
								numAltRestrB(restrnum,1)=de(hg,restrid1+numAltRestB); 
								parRestrB(restrnum,1)=stvar(de(hg,restrid1+parRestB),location,de(hg,restrid1+numRegRestB));
							end
						end
					end
				end
			
				if na==4 & de(1,dependent)==1 & de(1,present)==1 %from endogenous variable to sum variable
					ga = de(hg,idmodel);
					dt = stvar(:,:,ga);
					sout = dt(1,numrows);
					ia=dt(1,auxvariable);
					if ia==0
						KVar = KVar+1;
						idsum(KVar,1)=ga;
						eval(['default' num2str(KVar) '=zeros(N,1);'])
						numInclOutcAK(KVar,1)=0;
						XnumInclOutcAK(KVar,1)=0;
						numInclEqK(KVar,1)=0;
						numInclEqCondK(KVar,1)=0;
						indInclEqIdCondK(KVar,1)=0;
						stvar(1,auxvariable,ga)=KVar;
						numCondVarK(KVar,1) =  stvar(1,numcond,ga);
						dt(1,auxvariable)=KVar;
						ia = dt(1,auxvariable);
					end
					
					stvar(hg,margtype,yi)=-de(hg,dependent);
					if de(hg,dependent)==0
							stvar(hg,margtype,yi)=-1;
					end
					
					ph=numInclOutcAK(ia,1);
					ya = de(1,idequation);
					
					XnumInclOutcA(ya,1)=XnumInclOutcA(ya,1)+1;
					XindInclOutcId(ya,XnumInclOutcA(ya,1))=-ia;
					XindInclOutcRegA(ya,XnumInclOutcA(ya,1))=0;
					XindInclOutcTyp1(ya,XnumInclOutcA(ya,1))=0;
					XindInclOutcTyp2(ya,XnumInclOutcA(ya,1))=0;
					XindInclOutcTyp3(ya,XnumInclOutcA(ya,1))=1;
					XindInclOutcMult(ya,XnumInclOutcA(ya,1))=0;
					XindInclOutcInter(ya,XnumInclOutcA(ya,1))=0;
					XindInclOutcAlter(ya,XnumInclOutcA(ya,1))=de(hg,alter); 
					XindInclOutcMinVal(ya,XnumInclOutcA(ya,1))=de(hg,minival); 
					XindInclOutcMaxVal(ya,XnumInclOutcA(ya,1))=de(hg,maxival); 
					if de(hg,multiplier)>0
						XindInclOutcTyp1(ya,XnumInclOutcA(ya,1))=1;
						XindInclOutcMult(ya,XnumInclOutcA(ya,1))=de(hg,multiplier);
					end
					if de(hg,dependent)==3
						XindInclOutcTyp2(ya,XnumInclOutcA(ya,1))=1;
					end
					
					
					if ph>0 & dans==1
						s1=numInclOutcA(ya,1)+1;
						sph = numInclOutcA(ya,1)+ph;
						numInclOutcA(ya,1)=ph+numInclOutcA(ya,1);
						for qa=s1:sph
							if de(hg,dependent)==0
								indInclOutcId(ya,qa)=indInclOutcIdK(ia,qa-s1+1);
								indInclOutcRegA(ya,qa)=indInclOutcRegAK(ia,qa-s1+1);
								indInclOutcTyp1(ya,qa)=indInclOutcTyp1K(ia,qa-s1+1);
								indInclOutcMult(ya,qa)=indInclOutcMultK(ia,qa-s1+1);
								if de(hg,multiplier)>0 & indInclOutcTyp1K(ia,qa-s1+1)>0
									indInclOutcMult(ya,qa)=de(hg,multiplier)*indInclOutcMultK(ia,qa-s1+1);
								end
								if de(hg,multiplier)>0 & indInclOutcTyp1K(ia,qa-s1+1)<1
									indInclOutcTyp1(ya,qa)=1;
									indInclOutcMult(ya,qa)=de(hg,multiplier);
								end
								indInclOutcInter(ya,qa)=indInclOutcInterK(ia,qa-s1+1);
							end
						end
					end
					numInclEqK(ia,1)=numInclEqK(ia,1)+1;
					if hg>1
						if de(hg,interaction)==0 & de(hg,idmodel)~=de(hg-1,idmodel) 
							if de(hg,dependent)==3
								numInclEqCondK(ia,1)=numInclEqCondK(ia,1)+1;
								indInclEqIdCondK(ia,numInclEqCondK(ia,1))=de(1,idequation);
							end
						end
					end
				
				end
			
				if na==4 & de(1,dependent)==4 & de(1,present)==1 %from sum to sum variable
					
					ga = de(hg,idmodel);
					dt = stvar(:,:,ga);
					sout = dt(1,numrows);
					ia=dt(1,auxvariable);
					if ia==0
						KVar = KVar+1;
						idsum(KVar,1)=ga;
						eval(['default' num2str(KVar) '=zeros(N,1);'])
						numInclOutcAK(KVar,1)=0;
						XnumInclOutcAK(KVar,1)=0;
						numInclEqK(KVar,1)=0;
						numInclEqCondK(KVar,1)=0;
						indInclEqIdCondK(KVar,1)=0;
						stvar(1,auxvariable,ga)=KVar;
						numCondVarK(KVar,1) =  stvar(1,numcond,ga);
						dt(1,auxvariable)=KVar;
						ia = dt(1,auxvariable);
					end
					
					stvar(hg,margtype,yi)=-de(hg,dependent);
					if de(hg,dependent)==0
							stvar(hg,margtype,yi)=-1;
					end

					ph=numInclOutcAK(ia,1);
					ya = stvar(1,auxvariable,yi);
					
					if ph>0
						s1=numInclOutcAK(ya,1)+1;
						sph = numInclOutcAK(ya,1)+ph;
						numInclOutcAK(ya,1)=ph+numInclOutcAK(ya,1);
						for qa=s1:sph
							indInclOutcIdK(ya,qa)=indInclOutcIdK(ia,qa-s1+1);
							indInclOutcRegAK(ya,qa)=indInclOutcRegAK(ia,qa-s1+1);
							indInclOutcTyp1K(ya,qa)=indInclOutcTyp1K(ia,qa-s1+1);
							indInclOutcMultK(ya,qa)=indInclOutcMultK(ia,qa-s1+1);
							if de(hg,multiplier)>0 & indInclOutcTyp1K(ia,qa-s1+1)>0
								indInclOutcMultK(ya,qa)=de(hg,multiplier)*indInclOutcMultK(ia,qa-s1+1);
							end
							if de(hg,multiplier)>0 & indInclOutcTyp1K(ia,qa-s1+1)<1
								indInclOutcTyp1K(ya,qa)=1;
								indInclOutcMultK(ya,qa)=de(hg,multiplier);
							end
							indInclOutcInterK(ya,qa)=indInclOutcInterK(ia,qa-s1+1);
						end
					end
					
					XnumInclOutcAK(ya,1)=XnumInclOutcAK(ya,1)+1;
					XindInclOutcIdK(ya,XnumInclOutcAK(ya,1))=-ia;
					XindInclOutcRegAK(ya,XnumInclOutcAK(ya,1))=0;
					XindInclOutcTyp1K(ya,XnumInclOutcAK(ya,1))=0;
					XindInclOutcTyp2K(ya,XnumInclOutcAK(ya,1))=0;
					XindInclOutcTyp3K(ya,XnumInclOutcAK(ya,1))=1;
					XindInclOutcMultK(ya,XnumInclOutcAK(ya,1))=0;
					XindInclOutcInterK(ya,XnumInclOutcAK(ya,1))=0;
					XindInclOutcAlterK(ya,XnumInclOutcAK(ya,1))=de(hg,alter); 
					XindInclOutcMinValK(ya,XnumInclOutcAK(ya,1))=de(hg,minival); 
					XindInclOutcMaxValK(ya,XnumInclOutcAK(ya,1))=de(hg,maxival); 
					if de(hg,multiplier)>0
						XindInclOutcTyp1K(ya,XnumInclOutcAK(ya,1))=1;
						XindInclOutcMultK(ya,XnumInclOutcAK(ya,1))=de(hg,multiplier);
					end
					if de(hg,dependent)==3
						XindInclOutcTyp2K(ya,XnumInclOutcAK(ya,1))=1;
					end
					numInclEqK(ia,1)=numInclEqK(ia,1)+1;
					if hg>1
						if de(hg,interaction)==0 & de(hg,idmodel)~=de(hg-1,idmodel) 
							if de(hg,dependent)==3
								numInclEqCondK(ia,1)=numInclEqCondK(ia,1)+1;
								indInclEqIdCondK(ia,numInclEqCondK(ia,1))=-de(1,auxvariable);
							end
						end
					end
				end
				
				if na==4 & de(1,dependent)==0
					ga = de(hg,idmodel);
					dt = stvar(:,:,ga);
					sout = dt(1,numrows);
					ia=dt(1,auxvariable);
					if ia==0
						KVar = KVar+1;
						idsum(KVar,1)=ga;
						eval(['default' num2str(KVar) '=zeros(N,1);'])
						numInclOutcAK(KVar,1)=0;
						XnumInclOutcAK(KVar,1)=0;
						numInclEqK(KVar,1)=0;
						numInclEqCondK(KVar,1)=0;
						indInclEqIdCondK(KVar,1)=0;
						numCondVarK(KVar,1) =  stvar(1,numcond,ga);
						stvar(1,auxvariable,ga)=KVar;
						dt(1,auxvariable)=KVar;
						ia = dt(1,auxvariable);
					end
					eval(['default' num2str(ia) '=default' num2str(ia) '+varval' num2str(yi) ';'])
				end
				
			end
			
			if de(hg,dependent)==4 & de(hg,present)==1 & de(hg,auxvariable)==0 %state dependent or sum variable
				KVar = KVar+1;
				idsum(KVar,1)=yi;
				eval(['default' num2str(KVar) '=zeros(N,1);'])
				numInclOutcAK(KVar,1)=0;
				XnumInclOutcAK(KVar,1)=0;
				numInclEqK(KVar,1)=0;
				numInclEqCondK(KVar,1)=0;
				indInclEqIdCondK(KVar,1)=0;
				numCondVarK(KVar,1) =  stvar(hg,numcond,yi);
				de(hg,auxvariable)=KVar;
				stvar(hg,auxvariable,yi)=KVar;
				ya=KVar;
				indInclOutcIdK(ya,1)=0;
				indInclOutcRegAK(ya,1)=0;
				indInclOutcTyp1K(ya,1)=0;
				indInclOutcMultK(ya,1)=0;
				indInclOutcInterK(ya,1)=0;
				XindInclOutcIdK(ya,1)=0;
				XindInclOutcRegAK(ya,1)=0;
				XindInclOutcTyp1K(ya,1)=0;
				XindInclOutcTyp2K(ya,1)=0;
				XindInclOutcTyp3K(ya,1)=0;
				XindInclOutcMultK(ya,1)=0;
				XindInclOutcInterK(ya,1)=0;
				XindInclOutcAlterK(ya,1)=0; 
				XindInclOutcMinValK(ya,1)=0; 
				XindInclOutcMaxValK(ya,1)=0; 
			end
			
			
			if de(hg,present)==1 & de(hg,dependent)==1 %non-missing dependent variable
				if de(hg,obscoeff)>0 %restriction observables
					wa = stvar(1,idequation,de(hg,obscoeff));
					wa1 = stvar(1,present,de(hg,obscoeff));
					if wa<1  & wa1>0
						SVar=SVar+1;
						iddep(SVar,1)=de(hg,obscoeff);
						numInclEq(SVar,1)=0;
						numInclEqCond(SVar,1)=0;
						indInclEqIdCond(SVar,1)=0;
						numCondVar(SVar,1) =  stvar(1,numcond,de(hg,obscoeff));
						stvar(1,idequation,de(hg,obscoeff))=SVar;
						eval(['reg' num2str(SVar) '=[];'])
						eval(['mreg' num2str(SVar) '=[];'])
						wa=SVar;
					end
					if wa1<1
						wa=0;
					end
				else
					wa =0;
				end
				
				if de(hg,unobscoeff)>0 %restriction unobservables
					ua = stvar(1,idequation,de(hg,unobscoeff));
					ua1 = stvar(1,present,de(hg,unobscoeff));
					if ua<1  & ua1>0
						SVar=SVar+1;
						iddep(SVar,1)=de(hg,unobscoeff);
						numInclEq(SVar,1)=0;
						numInclEqCond(SVar,1)=0;
						indInclEqIdCond(SVar,1)=0;
						numCondVar(SVar,1) =  stvar(1,numcond,de(hg,unobscoeff));
						stvar(1,idequation,de(hg,unobscoeff))=SVar;
						eval(['reg' num2str(SVar) '=[];'])
						eval(['mreg' num2str(SVar) '=[];'])
						ua=SVar;
					end
					if ua1<1
						ua=0;
					end
				else
					ua =0;
				end
				
				if de(hg,varcoeff)>0 %restriction variances
					va = stvar(1,idequation,de(hg,varcoeff));
					va1 = stvar(1,present,de(hg,varcoeff));
					if va<1  & va1>0
						SVar=SVar+1;
						iddep(SVar,1)=de(hg,varcoeff);
						numInclEq(SVar,1)=0;
						numInclEqCond(SVar,1)=0;
						indInclEqIdCond(SVar,1)=0;
						stvar(1,idequation,de(hg,varcoeff))=SVar;
						numCondVar(SVar,1) =  stvar(1,numcond,de(hg,varcoeff));
						eval(['reg' num2str(SVar) '=[];'])
						eval(['mreg' num2str(SVar) '=[];'])
						va=SVar;
					end
					if va1<1
						wv=0;
					end
				else
					va =0;
				end
				
				if de(hg,idequation)>0 %if outcome already reached
					ya=de(hg,idequation);
				else
					SVar=SVar+1;
					iddep(SVar,1)=yi;
					numInclEq(SVar,1)=0;
					numInclEqCond(SVar,1)=0;
					indInclEqIdCond(SVar,1)=0;
					numCondVar(SVar,1) =  stvar(1,numcond,yi);
					ya=SVar;
					eval(['reg' num2str(ya) '=[];'])
					eval(['mreg' num2str(SVar) '=[];'])	
				end
				
				%update dependent variable
				auxVarObs(ya,1)=wa;
				auxVarUnobs(ya,1)=ua;
				auxVarIds(ya,1)=va;
				eval(['dv' num2str(ya) '=[ce];'])
				eval(['dmydata' num2str(ya) '=msvar' num2str(yi) ';'])
				stvar(hg,idequation,yi)=ya;
				
				%%Factors
				
				numFa(ya,1)=de(hg,numfac);
				
				for sd=0:numFa(ya,1)-1
					factorId1(ya,sd+1)=de(hg,numfac+1+sd);
				end
				typeVarId(ya,1)=2;
				if de(hg,varcoeff)<-900
					typeVarId(ya,1)=3;
				end
				
				numInclOutcA(ya,1)=0;
				indInclOutcId(ya,1)=0;
				indInclOutcRegA(ya,1)=0;
				indInclOutcTyp1(ya,1)=0;
				indInclOutcMult(ya,1)=0;
				indInclOutcInter(ya,1)=0;
				XnumInclOutcA(ya,1)=0;
				XindInclOutcId(ya,1)=0;
				XindInclOutcRegA(ya,1)=0;
				XindInclOutcTyp1(ya,1)=0;
				XindInclOutcTyp2(ya,1)=0;
				XindInclOutcTyp3(ya,1)=0;
				XindInclOutcMult(ya,1)=0;
				XindInclOutcInter(ya,1)=0;
				XindInclOutcAlter(ya,1)=0; 
				XindInclOutcMinVal(ya,1)=0; 
				XindInclOutcMaxVal(ya,1)=0; 
				
				if de(hg,numberrest)>0 & de(hg,present)>0
					for ij=1:de(hg,numberrest)
						restrnum=restrnum+1;
						restrid2 = numberrest+(ij-1)*sizeRest;
						if de(hg,restrid2+typeRest)==0 %fixed - just for a factor loading
							typeRestr(restrnum,1)=0;
							typePar(restrnum,1)=2;
							numOutcRestrA(restrnum,1)=ya;
							numAltRestrA(restrnum,1)=de(hg,restrid2+numAltRestA);
							for tu=1:de(hg,numfac)
								if de(hg,numfac+tu)==de(hg,restrid2+parRestA)
									parRestrA(restrnum,1)=tu;
								end
							end
							valRestr(restrnum,1)=de(hg,restrid2+valRest);
							numOutcRestrB(restrnum,1)=0; 
							numAltRestrB(restrnum,1)=0; 
							parRestrB(restrnum,1)=0;

						elseif de(hg,restrid2+typePa)==2
							typeRestr(restrnum,1)=1;
							typePar(restrnum,1)=2;
							numOutcRestrA(restrnum,1)=ya;
							numAltRestrA(restrnum,1)=de(hg,restrid2+numAltRestA);
							for tu=1:de(hg,numfac)
								if de(hg,numfac+tu)==de(hg,restrid2+parRestA)
									parRestrA(restrnum,1)=tu;
								end
							end
							valRestr(restrnum,1)=0;
							
							numOutcRestrB(restrnum,1)=stvar(1,idequation,de(hg,restrid2+numRegRestB)); 
							numAltRestrB(restrnum,1)=de(hg,restrid2+numAltRestB); 
							for tu1=1:stvar(1,numfac,de(hg,restrid2+numRegRestB))
								if stvar(1,numfac+tu1,de(hg,restrid2+numRegRestB))==de(hg,restrid2+parRestB)
									parRestrB(restrnum,1)=tu1;
								end
							end
							
						elseif de(hg,restrid2+typePa)==1
							typeRestr(restrnum,1)=1;
							typePar(restrnum,1)=1;
							numOutcRestrA(restrnum,1)=ya;
							numAltRestrA(restrnum,1)=de(hg,restrid2+numAltRestA);
							parRestrA(restrnum,1)=0;
							valRestr(restrnum,1)=0;
							numOutcRestrB(restrnum,1)=stvar(1,idequation,de(hg,restrid2+numRegRestB)); 
							numAltRestrB(restrnum,1)=de(hg,restrid2+numAltRestB); 
							parRestrB(restrnum,1)=0;
							
						elseif de(hg,restrid2+typePa)==3
							typeRestr(restrnum,1)=1;
							typePar(restrnum,1)=2;
							numOutcRestrA(restrnum,1)=ya;
							numAltRestrA(restrnum,1)=de(hg,restrid2+numAltRestA);
							parRestrA(restrnum,1)=0;
							valRestr(restrnum,1)=0;
							numOutcRestrB(restrnum,1)=stvar(1,idequation,de(hg,restrid2+numRegRestB)); 
							numAltRestrB(restrnum,1)=de(hg,restrid2+numAltRestB); 
							parRestrB(restrnum,1)=0;
													
						elseif de(hg,restrid2+typePa)==4
							typeRestr(restrnum,1)=1;
							typePar(restrnum,1)=3;
							numOutcRestrA(restrnum,1)=ya;
							numAltRestrA(restrnum,1)=de(hg,restrid2+numAltRestA);
							for tu=1:de(hg,numfac)
								if de(hg,numfac+tu)==de(hg,restrid2+parRestA)
									parRestrA(restrnum,1)=tu;
								end
							end
							valRestr(restrnum,1)=0;
							numOutcRestrB(restrnum,1)=stvar(1,idequation,de(hg,restrid2+numRegRestB)); 
							numAltRestrB(restrnum,1)=0; 
							parRestrB(restrnum,1)=0;
						end
					end
				end			
			end
		end
	end
end
if maxNumFa>0
	genf=size(factorId1,2);
	benf=size(factorId1,1);
	if maxNumFa>genf | SVar>benf
		factorId1(SVar,maxNumFa)=0;
	end
end
maxInclOutc = max(numInclOutcA);
MNG=round(SVar/2); %max number of covariance groups per individual - to be checked afterwards

numreg=numreg(1:SVar,1); %number regressors per equation,
numregA=numregA(1:SVar,1); %number regressors per equation - no interactions
numinter=numinter(1:SVar,1);
interone=interone(1:SVar,:); %location of the first variable in the interaction
intertwo=intertwo(1:SVar,:); %location of the second variable in the interaction
interboth=interboth(1:SVar,:); %location of the interaction
intermult=intermult(1:SVar,:); %multiplicator for interactions;

varlistall = [1:1:SVar -1:-1:-KVar]'; %list of all endogenous variables in chronologic order
LVar=SVar+KVar;
if KVar==0
	XnumInclOutcAK=[];
	XindInclOutcIdK=[];
	numInclEqK=[];
end
numMax = max(XnumInclOutcA);
numMaxK =  max(XnumInclOutcAK);
if KVar==0
	numMaxK=0;
end
BnumInclOutc=[XnumInclOutcA; XnumInclOutcAK];
BnumInclEq=[numInclEq; numInclEqK];
BnumMax=max(BnumInclOutc);
BindInclOutcId=[XindInclOutcId zeros(SVar,BnumMax-numMax); XindInclOutcIdK zeros(KVar,BnumMax-numMaxK)];
BindInclOutcId1=BindInclOutcId;
for i=1:LVar
	for j=1:BnumInclOutc(i,1)
		if BindInclOutcId(i,j)>-1
			BindInclOutcId(i,j)=BindInclOutcId(i,j)+1;
		end
		if BindInclOutcId(i,j)<0
			BindInclOutcId(i,j)=-BindInclOutcId(i,j)+SVar;
		end
	end
end
idvari=[iddep; idsum];

nn=0;
BnumInclEqCur = zeros(LVar,1);
BPart = ones(LVar,1);

ga=0;
nikk=zeros(SVar,1);
dmydataA =[]; %matrix for missing variable indicators
for ga1=1:SVar %getting the names of the regressors
	eval(['dmydataA = [dmydataA dmydata' num2str(ga1) '];'])
	kan = iddep(ga1,1);
	if stvar(1,obscoeff,kan)==0  %| stvar(1,varcoeff,kan)==-1000 % & typeVarId(ga1,1)<3
		ga=ga+1;
		outcname{ga,1}=namevar{kan,1};
		regnames{ga,1}{1,1}='Variables';
		regnamesM{ga,1}{1,1}='Variables';
		nikk(ga1,1)=ga;
		lak=0;
		for ha=1:numreg(ga1,1)
			if interreg(ha,ga1)==0
				lan=idreg(ha,ga1,1);
				ren=min(size(namevar{lan,1},2),15);
				regnames{ga,1}{ha+1,1}=namevar{lan,1}(1,1:ren);
				lak=lak+1;
				regnamesM{ga,1}{lak+1,1}=namevar{lan,1}(1,1:ren);
			elseif interreg(ha,ga1)==1 & idreg(ha,ga1,1)~=idreg(ha,ga1,2)
				lan=idreg(ha,ga1,1);
				man=idreg(ha,ga1,2);
				ren=min(size(namevar{lan,1},2),7);
				cen=min(size(namevar{man,1},2),7);
				regnames{ga,1}{ha+1,1}=[namevar{lan,1}(1,1:ren) '*' namevar{man,1}(1,1:cen)];
			else
				lan=idreg(ha,ga1,1);
				ren=min(size(namevar{lan,1},2),13);
				regnames{ga,1}{ha+1,1}=[namevar{lan,1}(1,1:ren) '^2'];
			end
		end
		for ra=1:numFa(ga1,1)
			ge=factorId1(ga1,ra)+1;
			regnames{ga,1}{ha+1+ra,1}= ['Factor ' num2str(ge)];
		end
		if numFa(ga1,1)==0
			ra=0;
		end
		eval(['zce = size(varval' num2str(kan) ',2);'])
		if zce==1 & stvar(1,varcoeff,kan)>-1000
			regnames{ga,1}{ha+1+ra+1,1}= ['Variance'];
		end
		numRegrU(ga,1)=numreg(ga1,1);
		numOutVarU(ga,1)=zce;
		numFaU(ga,1)=numFa(ga1,1);
		factorIdU(ga,1)=0;
		if numFa(ga1,1)>0
			factorIdU(ga,:)=factorId1(ga1,1);
		end
		unvarU(ga,1)=ga1;
	end
end

while nn<LVar
	for h=1:LVar
		if BPart(h,1)==1
			if BnumInclEqCur(h,1)==BnumInclEq(h,1)
				nn=nn+1;
				BPart(h,1)=0;
				varlistchron(nn,1)=varlistall(h,1); %getting the chronology - estimation ids
				varlistchronmod(nn,1)=idvari(h,1); %getting the chronology - authentic ids
				for g=1:BnumInclOutc(h,1)
					BnumInclEqCur(BindInclOutcId(h,g),1)=BnumInclEqCur(BindInclOutcId(h,g),1)+1;
				end
			end
		end
	end
end
estfile=0; %1 - short, simulation; 2 - short, integration; 3 - long, simulation;, 4-long, integration
estfileA =0;
for uy=1:SVar
	kjd=length(find(dmydataA(:,uy)==0));
	kjd = kjd*numInclOutcA(uy,1);
	if kjd>0
		estfileA = 1;
	end
end

estfileB=0;
for gj=1:length(factorType)
	if factorType(gj,1)>1
		estfileB=1;
	end
end

if typeEst==1
	estfileB=1;
end

if estfileA==0 & estfileB==0
	estfile=1;
elseif estfileA==0 & estfileB==1
	estfile=2;
elseif estfileA==1 & estfileB==0
	estfile=3;
elseif estfileA==1 & estfileB==1
	estfile=4;
end
	
save -v7.3 model_all
