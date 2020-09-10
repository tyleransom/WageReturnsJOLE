for jj=1:runnumber
	for iu=1:SSVarA
		kaj=find(regrattr(jj).fixedregrid == varchronmodmarg(iu,1));
		if length(kaj)<1
			regrattr(jj).fixedregrid = [regrattr(jj).fixedregrid varchronmodmarg(iu,1)];
			regrattr(jj).fixedregrval = [regrattr(jj).fixedregrval 0];
		end
	end
end
if samepeople==1
	numindiv =  Before.numindiv;
	indid = Before.indid;
	for jj=1:runnumber
		NfixRegr=length(regrattr(jj).fixedregrid);
		NfixRegr1=NfixRegr;
		NchRegr = length(regrattr(jj).changeregrid);
		
		if numindiv==0
			regrattr(jj).fixedregrval1=regrattr(jj).fixedregrval;
			for i=1:NchRegr
				sap=find(regrattr(jj).fixedregrid==regrattr(jj).changeregrid(1,i));
				im=regrattr(jj).changeregrid(1,i);
				
				if regrattr(jj).changeregrcode(1,i)==-1 & stvar(1,discrete,im)==1
					regrattr(jj).changeregrcode(1,i)=0;
				end

				if regrattr(jj).changeregrcode(1,i)==-1 & length(sap)==0
					regrattr(jj).changeregrval1(1,i)=stvar(1,average,im);
				end
				if regrattr(jj).changeregrcode(1,i)==-1 & length(sap)>0
					regrattr(jj).changeregrval1(1,i)=regrattr(jj).fixedregrval1(1,sap);
				end
				
				
				if regrattr(jj).changeregrcode(1,i)==0 & stvar(1,discrete,im)==1 & length(sap)==0 
					NfixRegr1=NfixRegr1+1;
					regrattr(jj).fixedregrid(1,NfixRegr1)=regrattr(jj).changeregrid(1,i);
					regrattr(jj).fixedregrval1(1,NfixRegr1)=0;
					regrattr(jj).changeregrval1(1,i)=1;
				end
				if regrattr(jj).changeregrcode(1,i)==0 & stvar(1,discrete,im)==0 & length(sap)==0
					regrattr(jj).changeregrval1(1,i)=stvar(1,average,im)+stvar(1,chng,im);
				end
				if regrattr(jj).changeregrcode(1,i)==0 & length(sap)>0
					regrattr(jj).changeregrval1(1,i)=regrattr(jj).fixedregrval1(1,sap)+stvar(1,chng,im);
				end
				

				if regrattr(jj).changeregrcode(1,i)==1 & stvar(1,discrete,im)==1 & length(sap)==0
					NfixRegr1=NfixRegr1+1;
					regrattr(jj).fixedregrid(1,NfixRegr1)=regrattr(jj).changeregrid(1,i);
					regrattr(jj).fixedregrval1(1,NfixRegr1)=0;
					regrattr(jj).changeregrval1(1,i)=regrattr(jj).changeregrvalue(1,i);
				end
				if regrattr(jj).changeregrcode(1,i)==1 & stvar(1,discrete,im)==0 & length(sap)==0
					regrattr(jj).changeregrval1(1,i)=stvar(1,average,im)+regrattr(jj).changeregrvalue(1,i);
				end
				if regrattr(jj).changeregrcode(1,i)==1 & length(sap)>0
					regrattr(jj).changeregrval1(1,i)=regrattr(jj).fixedregrval1(1,sap)+regrattr(jj).changeregrvalue(1,i);
				end
				
				if regrattr(jj).changeregrcode(1,i)==2 & stvar(1,discrete,im)==1 & length(sap)==0
					NfixRegr1=NfixRegr1+1;
					regrattr(jj).fixedregrid(1,NfixRegr1)=regrattr(jj).changeregrid(1,i);
					regrattr(jj).fixedregrval1(1,NfixRegr1)=0;
					regrattr(jj).changeregrval1(1,i)=regrattr(jj).changeregrvalue(1,i);
				end
				if regrattr(jj).changeregrcode(1,i)==2 & stvar(1,discrete,im)==0 & length(sap)==0
					regrattr(jj).changeregrval1(1,i)=regrattr(jj).changeregrvalue(1,i);
				end
				if regrattr(jj).changeregrcode(1,i)==2 & length(sap)>0
					regrattr(jj).changeregrval1(1,i)=regrattr(jj).changeregrvalue(1,i);
				end
			end
		else
			regrattr(jj).fixedregrval2=regrattr(jj).fixedregrval;
			for gt=1:NfixRegr1
				il=regrattr(jj).fixedregrval2(1,gt);
				if il>0
					for gr=1:numindiv
						eval(['regrattr(jj).fixedregrval1(1,(gt-1)*numindiv+gr)=varval' num2str(il) '(indid(1,gr),1);'])
					end
				else
					for gr=1:numindiv
						regrattr(jj).fixedregrval1(1,(gt-1)*numindiv+gr)=-il;
					end
				end
			end
			for i=1:NchRegr
				sap=find(regrattr(jj).fixedregrid==regrattr(jj).changeregrid(1,i));
				im=regrattr(jj).changeregrid(1,i);
				if regrattr(jj).changeregrcode(1,i)>0
					ik=regrattr(jj).changeregrvalue(1,i);
				end
				
				if regrattr(jj).changeregrcode(1,i)==-1 & stvar(1,discrete,im)==1
					regrattr(jj).changeregrcode(1,i)=0
				end
				
				if regrattr(jj).changeregrcode(1,i)==-1 & length(sap)==0
					for gr=1:numindiv
						eval(['regrattr(jj).changeregrval1(1,(i-1)*numindiv+gr) = varval' num2str(im) '(indid(1,gr),1);'])
					end
				end
				if regrattr(jj).changeregrcode(1,i)==-1 & length(sap)>0
					for gr=1:numindiv
						regrattr(jj).changeregrval1(1,(i-1)*numindiv+gr)=regrattr(jj).fixedregrval1(1,(sap-1)*numindiv+gr);
					end
				end
				
				if regrattr(jj).changeregrcode(1,i)==0 & stvar(1,discrete,im)==1 & length(sap)==0 
					NfixRegr1=NfixRegr1+1;
					regrattr(jj).fixedregrid(1,NfixRegr1)=regrattr(jj).changeregrid(1,i);
					for gr=1:numindiv
						regrattr(jj).fixedregrval1(1,(NfixRegr1-1)*numindiv+gr)=0;
						regrattr(jj).changeregrval1(1,(i-1)*numindiv+gr)=1;
					end
				end
				if regrattr(jj).changeregrcode(1,i)==0 & stvar(1,discrete,im)==0 & length(sap)==0
					for gr=1:numindiv
						eval(['regrattr(jj).changeregrval1(1,(i-1)*numindiv+gr) = varval' num2str(im) '(indid(1,gr),1)+stvar(1,chng,im);'])
					end
				end
				if regrattr(jj).changeregrcode(1,i)==0 & length(sap)>0
					for gr=1:numindiv
						regrattr(jj).changeregrval1(1,(i-1)*numindiv+gr)=regrattr(jj).fixedregrval1(1,(sap-1)*numindiv+gr)+stvar(1,chng,im);
					end
				end
				

				if regrattr(jj).changeregrcode(1,i)==1 & stvar(1,discrete,im)==1 & length(sap)==0
					NfixRegr1=NfixRegr1+1;
					regrattr(jj).fixedregrid(1,NfixRegr1)=regrattr(jj).changeregrid(1,i);
					for gr=1:numindiv
						regrattr(jj).fixedregrval1(1,(NfixRegr1-1)*numindiv+gr)=0;
						eval(['regrattr(jj).changeregrval1(1,(i-1)*numindiv+gr) = varval' num2str(ik) '(indid(1,gr),1);'])
					end
				end
				if regrattr(jj).changeregrcode(1,i)==1 & stvar(1,discrete,im)==0 & length(sap)==0
					for gr=1:numindiv
						eval(['regrattr(jj).changeregrval1(1,(i-1)*numindiv+gr) = varval' num2str(im) '(indid(1,gr),1)+varval' num2str(ik) '(indid(1,gr),1);'])
					end
				end
				if regrattr(jj).changeregrcode(1,i)==1 & length(sap)>0
					for gr=1:numindiv
						eval(['regrattr(jj).changeregrval1(1,(i-1)*numindiv+gr) = regrattr(jj).fixedregrval1(1,(sap-1)*numindiv+gr)+varval' num2str(ik) '(indid(1,gr),1);'])
					end
				end
				
				if regrattr(jj).changeregrcode(1,i)==2 & stvar(1,discrete,im)==1 & length(sap)==0
					NfixRegr1=NfixRegr1+1;
					regrattr(jj).fixedregrid(1,NfixRegr1)=regrattr(jj).changeregrid(1,i);
					for gr=1:numindiv
						regrattr(jj).fixedregrval1(1,(NfixRegr1-1)*numindiv+gr)=0;
						eval(['regrattr(jj).changeregrval1(1,(i-1)*numindiv+gr) = varval' num2str(ik) '(indid(1,gr),1);'])
					end
				end
				if regrattr(jj).changeregrcode(1,i)==2 & stvar(1,discrete,im)==0 & length(sap)==0
					if ik>0
						for gr=1:numindiv
							eval(['regrattr(jj).changeregrval1(1,(i-1)*numindiv+gr) = varval' num2str(ik) '(indid(1,gr),1);'])
						end
					else
						for gr=1:numindiv
							regrattr(jj).changeregrval1(1,(i-1)*numindiv+gr) = -ik;
						end
					end
				end
				if regrattr(jj).changeregrcode(1,i)==2 & length(sap)>0
					if ik>0
						for gr=1:numindiv
							eval(['regrattr(jj).changeregrval1(1,(i-1)*numindiv+gr) = varval' num2str(ik) '(indid(1,gr),1);'])
						end
					else
						for gr=1:numindiv
							regrattr(jj).changeregrval1(1,(i-1)*numindiv+gr) = -ik;
						end
					end
				end
			end
		end
	end
else
	NfixRegr1=length(regrattr(jj).fixedregrid);
	for gt=1:NfixRegr1
		for gr=1:numindiv
			regrattr(jj).fixedregrval1(1,(gt-1)*numindiv+gr)=0;
		end
	end
	% regrattr(mm).fixedregrid=[];
	% regrattr(mm).fixedregrval1=[];
	regrattr(mm).changeregrid=[];
	regrattr(mm).changeregrval1=[];
end