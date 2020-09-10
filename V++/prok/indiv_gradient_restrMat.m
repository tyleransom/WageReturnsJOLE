function [lnL meat] = indiv_gradient(gamma_final)

global d_alpha d_beta d_sigma d_omega d_ksi d_mean d_var argum nRestrA nRestrB rA rB GroupN restrMat

delta1=[d_beta; d_alpha; d_sigma; d_omega; d_ksi; d_mean; d_var; gamma_final];
argum1=argum;
R3 = size(restrMat,1);

if rand<0.01
	save optim gamma_final delta1
end

bq1=zeros(1,1);
sizer = d_beta+d_alpha+d_sigma+d_omega+d_ksi+d_mean+d_var;
meatQ = zeros(sizer-size(nRestrA,1)-size(nRestrB,1)-size(restrMat,1));
for yy=1:GroupN
	argum1{yy,4}=delta1;
	[aq1 aq2 aq3 aq4 aq5 aq6 aq7 aq8]=prok3x(argum1{yy,:});
	gradientQyy = [aq2' aq3' aq4' aq5' aq6' aq7' aq8'];
	bq1=bq1+aq1;

	% Need to reduce the dimensionality of the gradient so it will be conformable with dimension-reduced hessian
	% V++
	if rA>0
		for sA=1:rA
			gradientQyy(1,nRestrA(sA,1))=NaN;
		end
	end
	if rB>0
		for sB=1:rB
			gradientQyy(1,nRestrB(sB,2))=gradientQyy(1,nRestrB(sB,2))+gradientQyy(1,nRestrB(sB,1));
			gradientQyy(1,nRestrB(sB,1))=NaN;
		end
	end

	% applyRestr3
	gradientQyy(1,d_beta+1:d_beta+d_alpha) = applyRestrGrad3(restrMat,gradientQyy(1,d_beta+1:d_beta+d_alpha)); % Applies restrictions but doesn't reduce size...
	for r=R3:-1:1
		gradientQyy(1,d_beta+restrMat(r,2))=NaN; % these should be the constrained parms
	end

    gradientQyy(isnan(gradientQyy)) = [];
	meatQyy = gradientQyy'*gradientQyy;
	meatQ   = meatQ + meatQyy;
end

lnL=-bq1;
meat = meatQ;
