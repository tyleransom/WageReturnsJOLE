function [regrm defaum] = regrinput(regrcorrm)

global stvar numrows dependent present idmodel interaction idequation location auxvariable

regrm=regrcorrm.regr;
defaum = regrcorrm.defau;
numindiv2=max(regrcorrm.numindiv,1);
numbregr=length(regrcorrm.regrid);
for i=1:numbregr %number of changes
	hs=regrcorrm.regrid(1,i); %id of the regresspr
	for j=1:stvar(1,numrows,hs) %places where the regressor goes
		if (stvar(j,dependent,hs)==0 | stvar(j,dependent,hs)==2) & stvar(j,present,hs)==1 %if a regressor and present
			vj=stvar(j,idmodel,hs); %where the regressor goes  - authentic
			tj=stvar(1,dependent,hs)*stvar(1,present,hs); %if variable a dependent variable as well
			qj=stvar(j,interaction,hs); %if interacted
			kg=stvar(1,dependent,vj); %type of variable where it goes
			zg=stvar(1,present,vj); %if where it goes - present
			
			if kg==1 & zg==1 & qj==0 %going to a standart outcome
				wj=stvar(j,idequation,hs); %id of the equation
				aj=regrcorrm.legStMar(wj,1); %correspondence to history in the marginal effects
				dj=(regrcorrm.lastfixed<(aj+1));
				if aj>-1 & dj>0
					cj = regrcorrm.indRegrM(aj+1,1); %index relative location of regressors for the variable
					nj = regrcorrm.numRegrM(aj+1,1); %number of regressors of the variable
					lj = stvar(j,location,hs); % location of the regressor
					for gr=1:numindiv2 %across individuals
						regrm(cj*numindiv2+(gr-1)*nj+lj)=regrcorrm.regrval(1,(i-1)*numindiv2+gr); %updating regressors
					end
				end
			elseif kg==4 & zg==1 & qj==0 & tj==0 %if outcome auxilary variable
				wj1=stvar(1,auxvariable,vj); %id of the auxilary variable
				aj1=regrcorrm.legAuxMar(wj1,1); %correspondence to history in the marginal effects
				dj1=(regrcorrm.lastfixed<(aj1+1));
				if aj1>-1 & dj1>0
					cj1 = regrcorrm.indRegrM(aj1+1,1); %index relative location of the variable across other auxilary variables
					for gr=1:numindiv2
						defaum(cj1*numindiv2+gr)=regrcorrm.regrval(1,(i-1)*numindiv2+gr); %updating defaults
					end
				end
			end
		end
	end
end	
					
					
				