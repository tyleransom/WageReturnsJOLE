function [lnL derek] = urax(gamma)

global d_alpha d_beta d_sigma d_omega d_ksi d_mean d_var argum nRestrA nRestrB rA rB GroupN
%Restrictions
if rA>0
for sA=1:rA
	gamma(nRestrA(sA,1),1)=nRestrA(sA,2);
end
end
if rB>0
for sB=1:rB
	gamma(nRestrB(sB,1),1)=gamma(nRestrB(sB,2),1);
end
end
%gamma(14,1)=1;
%%Some restrictions for checking derivatives

%gamma(1:d_beta,1)=2*ones(d_beta,1);
%gamma(d_beta+1:d_beta+d_alpha,1)=3*ones(d_alpha,1);
delta1=[d_beta; d_alpha; d_sigma; d_omega; d_ksi; d_mean; d_var; gamma];
argum1=argum;
%argum1{1,4}=delta1;
if rand<0.01
	save optim gamma delta1
end

bq1=zeros(1,1);
bq2=zeros(d_beta,1);
bq3=zeros(d_alpha,1);
bq4=zeros(d_sigma,1);
bq5=zeros(d_omega,1);
bq6=zeros(d_ksi,1);
bq7=zeros(d_mean,1);
bq8=zeros(d_var,1);
for yy=1:GroupN
argum1{yy,4}=delta1;
[aq1 aq2 aq3 aq4 aq5 aq6 aq7 aq8]=prok3x(argum1{yy,:});
bq1=bq1+aq1;
bq2=bq2+aq2;
bq3=bq3+aq3;
bq4=bq4+aq4;
bq5=bq5+aq5;
bq6=bq6+aq6;
bq7=bq7+aq7;
bq8=bq8+aq8;
end

%%Some restrictions for checking derivatives

%[bq1 bq2 bq3 bq4]=prok2(argum1{:});
%bq2=zeros(d_beta,1);
%bq3=zeros(d_alpha,1);
%bq4=zeros(d_alpha,1);
%bq8(1,1)=0;


lnL=-bq1;
derekQ=-[bq2' bq3' bq4' bq5' bq6' bq7' bq8'];
if rA>0
for sA=1:rA
	derekQ(1,nRestrA(sA,1))=0;
end
end
if rB>0
for sB=1:rB
	derekQ(1,nRestrB(sB,2))=derekQ(1,nRestrB(sB,2))+derekQ(1,nRestrB(sB,1));
	derekQ(1,nRestrB(sB,1))=0;
end
end
derek =  derekQ;

