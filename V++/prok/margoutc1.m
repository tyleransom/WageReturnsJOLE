function [XnumInclOutcM XindInclOutcIdM XindInclOutcRegM XindInclOutcTyp1M XindInclOutcTyp2M XindInclOutcTyp3M XindInclOutcMultM XindInclOutcInterM XindInclOutcAlterM XindInclOutcMinValM XindInclOutcMaxValM maxNumInclOutcM numCondVarM typeVarIdM numinterM interoneM intertwoM interbothM intermultM maxInterM numFaM factorIdM]=margoutc(varchronmarg)
global XnumInclOutcA XindInclOutcId XindInclOutcRegA XindInclOutcTyp1 XindInclOutcTyp2 XindInclOutcTyp3 XindInclOutcMult XindInclOutcInter XindInclOutcAlter XindInclOutcMinVal XindInclOutcMaxVal 
global XnumInclOutcAK XindInclOutcIdK XindInclOutcRegAK XindInclOutcTyp1K XindInclOutcTyp2K XindInclOutcTyp3K XindInclOutcMultK XindInclOutcInterK XindInclOutcAlterK XindInclOutcMinValK XindInclOutcMaxValK
global typeVarId numCondVar numCondVarK numinter interone intertwo interboth intermult numFa factorId1 maxNumFa

SSVar=length(varchronmarg);

XnumInclOutcM=zeros(SSVar,1);
XindInclOutcIdM=zeros(SSVar,1);
XindInclOutcRegM=zeros(SSVar,1);
XindInclOutcTyp1M=zeros(SSVar,1);
XindInclOutcTyp2M=zeros(SSVar,1);
XindInclOutcTyp3M=zeros(SSVar,1);
XindInclOutcMultM=zeros(SSVar,1);
XindInclOutcInterM=zeros(SSVar,1);
XindInclOutcAlterM=zeros(SSVar,1);
XindInclOutcMinValM=zeros(SSVar,1);
XindInclOutcMaxValM=zeros(SSVar,1);
numinterM=zeros(SSVar,1);
interoneM=zeros(SSVar,1); 
intertwoM=zeros(SSVar,1); 
interbothM=zeros(SSVar,1); 
intermultM=zeros(SSVar,1);
numFaM=zeros(SSVar,1);
factorIdM=zeros(1,maxNumFa);

for i=1:SSVar
	if varchronmarg(i,1)>0
		typeVarIdM(i,1)=typeVarId(varchronmarg(i,1),1);
		numCondVarM(i,1)=numCondVar(varchronmarg(i,1),1);
		numinterM(i,1)=numinter(varchronmarg(i,1),1);
		for k=1:numinter(varchronmarg(i,1),1)
			interoneM(i,k)=interone(varchronmarg(i,1),k);
			intertwoM(i,k)=intertwo(varchronmarg(i,1),k);
			interbothM(i,k)=interboth(varchronmarg(i,1),k); 
			intermultM(i,k)=intermult(varchronmarg(i,1),k);
		end
		numFaM(i,1)=numFa(varchronmarg(i,1),1);
		% for l=1:numFa(varchronmarg(i,1),1)
		if maxNumFa>0
			factorIdM(i,:)=factorId1(varchronmarg(i,1),:);
		end
		% end
		for j=1:XnumInclOutcA(varchronmarg(i,1),1)
			if XindInclOutcId(varchronmarg(i,1),j)>-0.5
				fj=XindInclOutcId(varchronmarg(i,1),j)+1;
			else
				fj=XindInclOutcId(varchronmarg(i,1),j);
			end
			gj=find(varchronmarg==fj);
			if length(gj)>0 
				if XindInclOutcTyp1(varchronmarg(i,1),j)<2
					XnumInclOutcM(i,1)=XnumInclOutcM(i,1)+1;
					XindInclOutcIdM(i,XnumInclOutcM(i,1))=gj-1;
					XindInclOutcRegM(i,XnumInclOutcM(i,1))=XindInclOutcRegA(varchronmarg(i,1),j);
					XindInclOutcTyp1M(i,XnumInclOutcM(i,1))=XindInclOutcTyp1(varchronmarg(i,1),j);
					XindInclOutcTyp2M(i,XnumInclOutcM(i,1))=XindInclOutcTyp2(varchronmarg(i,1),j);
					XindInclOutcTyp3M(i,XnumInclOutcM(i,1))=XindInclOutcTyp3(varchronmarg(i,1),j);
					XindInclOutcMultM(i,XnumInclOutcM(i,1))=XindInclOutcMult(varchronmarg(i,1),j);
					XindInclOutcInterM(i,XnumInclOutcM(i,1))=XindInclOutcInter(varchronmarg(i,1),j);
					XindInclOutcAlterM(i,XnumInclOutcM(i,1))=XindInclOutcAlter(varchronmarg(i,1),j);
					XindInclOutcMinValM(i,XnumInclOutcM(i,1))=XindInclOutcMinVal(varchronmarg(i,1),j);
					XindInclOutcMaxValM(i,XnumInclOutcM(i,1))=XindInclOutcMaxVal(varchronmarg(i,1),j);
				end
			end
		end
	else
		typeVarIdM(i,1)=4;
		numCondVarM(i,1)=numCondVar(-varchronmarg(i,1),1);
		for j=1:XnumInclOutcAK(-varchronmarg(i,1),1)
			if XindInclOutcIdK(-varchronmarg(i,1),j)>-0.5
				fj=XindInclOutcIdK(-varchronmarg(i,1),j)+1;
			else
				fj=XindInclOutcIdK(-varchronmarg(i,1),j);
			end
			gj=find(varchronmarg==fj);
			if length(gj)>0 
				if XindInclOutcTyp1(-varchronmarg(i,1),j)<2
					XnumInclOutcM(i,1)=XnumInclOutcM(i,1)+1;
					XindInclOutcIdM(i,XnumInclOutcM(i,1))=gj-1;
					XindInclOutcRegM(i,XnumInclOutcM(i,1))=XindInclOutcRegAK(-varchronmarg(i,1),j);
					XindInclOutcTyp1M(i,XnumInclOutcM(i,1))=XindInclOutcTyp1K(-varchronmarg(i,1),j);
					XindInclOutcTyp2M(i,XnumInclOutcM(i,1))=XindInclOutcTyp2K(-varchronmarg(i,1),j);
					XindInclOutcTyp3M(i,XnumInclOutcM(i,1))=XindInclOutcTyp3K(-varchronmarg(i,1),j);
					XindInclOutcMultM(i,XnumInclOutcM(i,1))=XindInclOutcMultK(-varchronmarg(i,1),j);
					XindInclOutcInterM(i,XnumInclOutcM(i,1))=XindInclOutcInterK(-varchronmarg(i,1),j);
					XindInclOutcAlterM(i,XnumInclOutcM(i,1))=XindInclOutcAlterK(-varchronmarg(i,1),j);
					XindInclOutcMinValM(i,XnumInclOutcM(i,1))=XindInclOutcMinValK(-varchronmarg(i,1),j);
					XindInclOutcMaxValM(i,XnumInclOutcM(i,1))=XindInclOutcMaxValK(-varchronmarg(i,1),j);
				end
			end
		end
	end
end
maxInterM=max(numinterM);
maxNumInclOutcM=max(XnumInclOutcM);
		
