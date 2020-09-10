clear all
tic
global argum d_beta d_alpha d_sigma nRestrA nRestrB rA rB GroupN

load finput1a
delta=[d_beta;d_alpha;d_sigma;delta0];
%forming the inputs for the likelihood estimation
for yy=1:GroupN
argum{yy,1}=Axxmat{1,yy};
argum{yy,2}=Admat{1,yy};
argum{yy,3}=mmat;
argum{yy,4}=delta;
argum{yy,5}=kmat;
argum{yy,6}=Arrmat{1,yy};
argum{yy,7}=Amrmat{1,yy};
for ty=1:drawFileCount
	argum{yy,7+ty}=AdrawFiles{1,ty}(:,yy);
end
for ky=1:drawFileCountMiss
	argum{yy,7+drawFileCount+ky}=AdrawFilesMiss{1,ky}(:,yy);
end
end 
save arguments argum d_beta d_alpha d_sigma GroupN nRestrA nRestrB rA rB delta0 N1 nRestrMat rAB
clear 
load arguments d_beta d_alpha d_sigma GroupN argum nRestrA nRestrB rA rB delta0 N1 nRestrMat rAB

%testing one evaluation of the function
tic

for i=1:1
cq1=zeros(1,1);
cq2=zeros(d_beta,1);
cq3=zeros(d_alpha,1);
cq4=zeros(d_sigma,1);
dq1=zeros(1,GroupN);
dq2=zeros(d_beta,GroupN);
dq3=zeros(d_alpha,GroupN);
dq4=zeros(d_sigma,GroupN);

for yy=1:GroupN

[aq1 aq2 aq3 aq4]=prok2(argum{yy,:});

cq1=cq1+aq1;
cq2=cq2+aq2;
cq3=cq3+aq3;
cq4=cq4+aq4;

dq1(:,yy)=aq1;
dq2(:,yy)=aq2;
dq3(:,yy)=aq3;
dq4(:,yy)=aq4;

end
end
toc

tolf=1e-5;
tolx=1e-5;
miter=1000;
options1 = optimset('Display','Iter','MaxFunEvals',1000000,'MaxIter',miter,'TolX',tolx,'TolFun',tolf, 'GradObj','on', 'LargeScale','off', 'DerivativeCheck','off','HessUpdate','bfgs');
options2 = optimset('Display','Iter','MaxFunEvals',1000000,'MaxIter',miter,'TolX',tolx,'TolFun',tolf, 'GradObj','off', 'LargeScale','off');


[aqk dqk] = prok2_cpp_ofd(delta0); %checking the file for the optimization

gamma_f = delta0;
[gamma_f,fval,exitflag]=fminunc('prok2_cpp_ofd',delta0,options1);
[gamma_f,fval,exitflag]=fminunc('prok2_cpp_ofd',gamma_f,options1);
% gamma_f = delta0;

% %getting the covariance matrix
% derek=zeros(d_beta+d_alpha+d_sigma);
% fq=zeros(d_beta+d_alpha+d_sigma,1);

% delta2=[d_beta; d_alpha; d_sigma; gamma_f];
% argum2=argum;

% for yy=1:GroupN
	% argum2{yy,4}=delta2;
	% for i=1:N1(yy,1)
		% NA2=i-1;
		% NB2=i;
		% argum2{yy,2}(2,1)=NA2;
		% argum2{yy,2}(3,1)=NB2;
	
		% [mq1 mq2 mq3 mq4]=prok2(argum2{yy,:});
		% eq=[mq2' mq3' mq4'];
		% fq = fq+eq';
		% if rB>0
		% for sB=1:rB %restrictions type B
			% eq(1,nRestrB(sB,2))=eq(1,nRestrB(sB,2))+eq(1,nRestrB(sB,1));
		% end
		% end
		% derek =  derek+eq'*eq;
	% end
% end
% hessie1 = hessian(@(x) prok2_cpp_ofdd(x),gamma_f); %classic estimation of hessian
% hessie2a = jacobianest(@(x) prok2_cpp_ofddd(x),gamma_f); %estimation of the hessian from the gradients
% hessie2b = triu(hessie2a);
% hessie2c = triu(hessie2a,1);
% hessie2 = hessie2b + hessie2c';
% hessie11 = hessie1;
% hessie21 = hessie2;
% derek1 = derek;
%Restrctions for the covariance matrix
% if rAB>0
% for sAB=1:rAB
	% psAB=rAB-sAB+1;
	% derek(nRestrMat(psAB,1),:)=[];
	% derek(:,nRestrMat(psAB,1))=[];
	% hessie1(nRestrMat(psAB,1),:)=[];
	% hessie1(:,nRestrMat(psAB,1))=[];
	% hessie2(nRestrMat(psAB,1),:)=[];
	% hessie2(:,nRestrMat(psAB,1))=[];
% end
% end
%derek(end,:)=[];
%derek(:,end)=[];
% covMatr=inv(derek); %from the gradient
% covMatr=inv(hessie1); %from hessian
% covMatr=inv(hessie2); %from the hessian
% covMatr=hessie1\derek/hessie1; %sandwich formula

%covMatr=inv(hessie2)*derek*inv(hessie2); %sandwich formula
% sErrors = diag(covMatr).^(1/2); %standard errors
% sErrors=[0;sErrors;0];
% gamma_final = gamma_f; %parameters after restrictions 
% if rAB>0
% for kk=1:rAB
	% sErrors=[sErrors(1:nRestrMat(kk,1),1);0;sErrors(nRestrMat(kk,1)+1:end,1)];
	% if nRestrMat(kk,3)==0
		% gamma_final(nRestrMat(kk,1),1) =  nRestrMat(kk,2);
	% end
% end
% for kk=1:rAB
	% if nRestrMat(kk,3)==1
		% sErrors(nRestrMat(kk,1)+1,1)=sErrors(nRestrMat(kk,2)+1,1);
		% gamma_final(nRestrMat(kk,1),1) =  gamma_f(nRestrMat(kk,2),1);
	% end
% end
% end
% sErrors=sErrors(2:end-1,1);

% save cov1a gamma_final covMatr sErrors





			
		
