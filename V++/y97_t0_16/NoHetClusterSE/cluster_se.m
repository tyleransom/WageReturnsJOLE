clear all;
delete cluster_se.diary;
diary  cluster_se.diary;
vladppadd
tic
global argum d_beta d_alpha d_sigma d_ksi d_omega d_mean d_var nRestrA nRestrB rA rB GroupN
rand('seed',12345);
randn('seed',12345);

%============================================================================
% Initial Starting values
%============================================================================
load finput1b     
load ../NoHetAsvabBackgroundAllBinnedSchInt/results gamma_final hessie1 fval
if ~isequal(size(gamma_final),size(delta0))
	error('You made a mistake somewhere')
	return
end
delta=[d_beta;d_alpha;d_sigma;d_omega;d_ksi;d_mean;d_var;gamma_final];

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
save arguments argum d_beta d_alpha d_sigma d_ksi d_omega d_mean d_var GroupN nRestrA nRestrB rA rB gamma_final N1 nRestrMat rAB
clear 
load arguments argum d_beta d_alpha d_sigma d_omega d_ksi d_mean d_var GroupN nRestrA nRestrB rA rB gamma_final N1 nRestrMat rAB
load ../NoHetAsvabBackgroundAllBinnedSchInt/results gamma_final hessie1 fval

%============================================================================
% Call function to return sum of outer product of individual gradients
%============================================================================
tic
[likey meat] = indiv_gradient(gamma_final);
toc
fval
likey

covMatr1 = inv(hessie1);         % from the hessian via jacobian
covMatr1S= hessie1\meat/hessie1; % sandwich formula

sErrors1 = diag(covMatr1 ).^(1/2); % std errors
sErrors1S= diag(covMatr1S).^(1/2); % std errors

sErrors1  = [0;sErrors1;0];
sErrors1S = [0;sErrors1S;0];

if rAB>0
	for kk=1:rAB
		sErrors1= [ sErrors1(1:nRestrMat(kk,1),1);0; sErrors1(nRestrMat(kk,1)+1:end,1)];
		sErrors1S=[sErrors1S(1:nRestrMat(kk,1),1);0;sErrors1S(nRestrMat(kk,1)+1:end,1)];
		% if nRestrMat(kk,3)==0
			% gamma_final(nRestrMat(kk,1),1) =  nRestrMat(kk,2);
		% end
	end
	for kk=1:rAB
		if nRestrMat(kk,3)==1
			sErrors1 (nRestrMat(kk,1)+1,1)=sErrors1 (nRestrMat(kk,2)+1,1);
			sErrors1S(nRestrMat(kk,1)+1,1)=sErrors1S(nRestrMat(kk,2)+1,1);
			% gamma_final(nRestrMat(kk,1),1)=gamma_f  (nRestrMat(kk,2),1);
		end
	end
end

sErrors1  = sErrors1 (2:end-1,1);
sErrors1S = sErrors1S(2:end-1,1);

save cluster_se;
dlmwrite ('results_cluster_se.csv',[[gamma_final sErrors1S];[-fval NaN]]);
diary off;
