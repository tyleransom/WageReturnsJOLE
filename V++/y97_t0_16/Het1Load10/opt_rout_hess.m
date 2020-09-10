clear all;
delete opt_rout_hess.diary;
diary  opt_rout_hess.diary;
vladppadd
tic
global argum d_beta d_alpha d_sigma d_ksi d_omega d_mean d_var nRestrA nRestrB rA rB GroupN
rand('seed',12345);
randn('seed',12345);

%============================================================================
% Initial Starting values
%============================================================================
% Load data
load finput1b     % Load first  (all but beta)

% Import starting values from nohet estimation
load start_values % Load second (beta; sigma_wage)
coefs=beta;
loadings=2*rand(d_alpha,1)-1;
% variance=0.5*rand(d_sigma,1)+0.25;
variance=sigma;
gamma0_nohet=[coefs;loadings;variance];

% Import starting values from 2016 het results
file = dir('startValues*from2016.csv');
jay = importdata(file.name);
gamma0_2016 = jay.data(:,1);
gamma0_2016(gamma0_2016==-999) = 0.2;

% Draw new starting values from uniform distribution between the two gamma0's
x = pwd;
rand('seed',str2num(x(end-1:end)));  % Use name of folder to change the seed
randn('seed',str2num(x(end-1:end))); % Use name of folder to change the seed
c = rand(size(gamma0_nohet));
gamma0 = gamma0_nohet.*c + gamma0_2016.*(1-c);

if ~isequal(size(gamma0),size(delta0))
	error('You made a mistake somewhere')
	return
end
delta=[d_beta;d_alpha;d_sigma;d_omega;d_ksi;d_mean;d_var;gamma0];

%============================================================================
% Forming the inputs for the likelihood estimation
%============================================================================
for yy=1:GroupN
	argum{yy,1}=Axxmat{1,yy};
	argum{yy,2}=Admat{1,yy};
	argum{yy,3}=mmat;
	argum{yy,4}=delta;
	argum{yy,5}=kmat;
	argum{yy,6}=ffmat;
	argum{yy,7}=ggmat;
	argum{yy,8}=hhmat;
end
save arguments argum d_beta d_alpha d_sigma d_ksi d_omega d_mean d_var GroupN nRestrA nRestrB rA rB gamma0 N1 nRestrMat rAB
clear 
load arguments argum d_beta d_alpha d_sigma d_omega d_ksi d_mean d_var GroupN nRestrA nRestrB rA rB gamma0 N1 nRestrMat rAB

%============================================================================
% Testing one evaluation of the function
%============================================================================
tic

%for i=1:1
%	cq1=zeros(1,1);
%	cq2=zeros(d_beta,1);
%	cq3=zeros(d_alpha,1);
%	cq4=zeros(d_sigma,1);
%	cq5=zeros(d_omega,1);
%	cq6=zeros(d_ksi,1);
%	cq7=zeros(d_mean,1);
%	cq8=zeros(d_var,1);
%	dq1=zeros(1,GroupN);
%	dq2=zeros(d_beta,GroupN);
%	dq3=zeros(d_alpha,GroupN);
%	dq4=zeros(d_sigma,GroupN);
%	dq5=zeros(d_omega,GroupN);
%	dq6=zeros(d_ksi,GroupN);
%	dq7=zeros(d_mean,GroupN);
%	dq8=zeros(d_var,GroupN);
%	
%	for yy=1:GroupN
%		[aq1 aq2 aq3 aq4 aq5 aq6 aq7 aq8]=prok3x(argum{yy,:});
%		cq1=cq1+aq1;
%		cq2=cq2+aq2;
%		cq3=cq3+aq3;
%		cq4=cq4+aq4;
%		cq5=cq5+aq5;
%		cq6=cq6+aq6;
%		cq7=cq7+aq7;
%		cq8=cq8+aq8;
%		
%		dq1(:,yy)=aq1;
%		dq2(:,yy)=aq2;
%		dq3(:,yy)=aq3;
%		dq4(:,yy)=aq4;
%		dq5(:,yy)=aq5;
%		dq6(:,yy)=aq6;
%		dq7(:,yy)=aq7;
%		dq8(:,yy)=aq8;
%	end
%end
%toc
%[aqk dqk] = prok3x_cpp_ofd(gamma0); %checking the file for the optimization
%aqk

%============================================================================
% Optimizing
%============================================================================
tolf  =1e-6;
tolx  =1e-6;
mfeval=1e6;
miter =20000;

% Using old-school 'iter' display
options1 = optimset('Display','Iter'          ,'MaxFunEvals',1e6,'MaxIter',miter,'TolX',tolx,'TolFun',tolf, 'GradObj','on' , 'LargeScale','off', 'DerivativeCheck','off','HessUpdate','bfgs');
options1a= optimset('Display','Iter'          ,'MaxFunEvals',1e6,'MaxIter',miter,'TolX',tolx,'TolFun',tolf, 'GradObj','on' , 'LargeScale','off', 'DerivativeCheck','off','HessUpdate','bfgs');
options2 = optimset('Display','Iter'          ,'MaxFunEvals',1e6,'MaxIter',miter,'TolX',tolx,'TolFun',tolf, 'GradObj','off', 'LargeScale','off');
options3 = optimset('Display','Final-detailed','MaxFunEvals',1  ,'MaxIter',1    ,'TolX',tolx,'TolFun',tolf, 'GradObj','on' , 'LargeScale','off');

%[gamma_f,fval,x]=fminunc('prok3x_cpp_ofd',gamma0,options1);
%disp '  gamma_f   gamma0   gamma0./gamma_f-1 ';
%[gamma_f gamma0 gamma_f./gamma0-1]
%toc;tic;

load results_no_se gamma_f
% Estimate of hessian
[gamma_same,fval,x,o,g,hessie1]=fminunc('prok3x_cpp_ofd',gamma_f,options3);
if sum(gamma_same~=gamma_f)>0; disp 'Uh oh'; return; end; % Kick out on error
toc;tic;

%============================================================================
% Standard Errors
%============================================================================
%---------------------------------
% Getting the covariance matrix
%---------------------------------
derek=zeros(d_beta+d_alpha+d_sigma+d_omega+d_ksi);
fq =  zeros(d_beta+d_alpha+d_sigma+d_omega+d_ksi,1);

delta2=[d_beta; d_alpha; d_sigma; d_omega; d_ksi; d_mean; d_var; gamma_f];
argum2=argum;

for yy=1:GroupN
	argum2{yy,4}=delta2;
	for i=1:N1(yy,1)
		NA2=i-1;
		NB2=i;
		argum2{yy,2}(2,1)=NA2;
		argum2{yy,2}(3,1)=NB2;
	
		[mq1 mq2 mq3 mq4 mq5 mq6 mq7 mq8]=prok3x(argum2{yy,:});
		eq=[mq2' mq3' mq4' mq5' mq6' mq7' mq8'];
		fq = fq+eq';
		if rB>0
			for sB=1:rB %restrictions type B
				eq(1,nRestrB(sB,2))=eq(1,nRestrB(sB,2))+eq(1,nRestrB(sB,1));
			end
		end
		derek =  derek+eq'*eq;
	end
end
% hessie1 = hessian(@(x) prok3x_cpp_ofdd(x),gamma_f); %classic estimation of hessian
% hessie2a = jacobianest(@(x) prok3x_cpp_ofddd(x),gamma_f); %estimation of the hessian from the gradients
% hessie2b = triu(hessie2a);
% hessie2c = triu(hessie2a,1);
% hessie2 = hessie2b + hessie2c';
hessie11 = hessie1;
% hessie21 = hessie2;
derek1 = derek;

%------------------------------------------
% Restrctions for the covariance matrix
%------------------------------------------
if rAB>0
	for sAB=1:rAB
		psAB=rAB-sAB+1;
		derek(nRestrMat(psAB,1),:)=[];
		derek(:,nRestrMat(psAB,1))=[];
		hessie1(nRestrMat(psAB,1),:)=[];
		hessie1(:,nRestrMat(psAB,1))=[];
	end
end
%derek(end,:)=[];
%derek(:,end)=[];

%------------------------------------------------
% Choose preferred metric and create std errors
%------------------------------------------------
covMatr0 = inv(derek);            % from the gradient
covMatr1 = inv(hessie1);          % from the hessian via jacobian
covMatr1S= hessie1\derek/hessie1; % sandwich formula

sErrors0 = diag(covMatr0 ).^(1/2); % std errors
sErrors1 = diag(covMatr1 ).^(1/2); % std errors
sErrors1S= diag(covMatr1S).^(1/2); % std errors

sErrors1  = [0;sErrors1;0];
sErrors1S = [0;sErrors1S;0];

gamma_final = gamma_f; %parameters after restrictions 
if rAB>0
	for kk=1:rAB
		sErrors1= [ sErrors1(1:nRestrMat(kk,1),1);0; sErrors1(nRestrMat(kk,1)+1:end,1)];
		sErrors1S=[sErrors1S(1:nRestrMat(kk,1),1);0;sErrors1S(nRestrMat(kk,1)+1:end,1)];
		if nRestrMat(kk,3)==0
			gamma_final(nRestrMat(kk,1),1) =  nRestrMat(kk,2);
		end
	end
	for kk=1:rAB
		if nRestrMat(kk,3)==1
			sErrors1 (nRestrMat(kk,1)+1,1)=sErrors1 (nRestrMat(kk,2)+1,1);
			sErrors1S(nRestrMat(kk,1)+1,1)=sErrors1S(nRestrMat(kk,2)+1,1);
			gamma_final(nRestrMat(kk,1),1)=gamma_f  (nRestrMat(kk,2),1);
		end
	end
end

sErrors1  = sErrors1 (2:end-1,1);
sErrors1S = sErrors1S(2:end-1,1);
toc;
save results;
dlmwrite ('results.csv',[[gamma_final; -fval] [sErrors1; NaN]]);
diary off;
