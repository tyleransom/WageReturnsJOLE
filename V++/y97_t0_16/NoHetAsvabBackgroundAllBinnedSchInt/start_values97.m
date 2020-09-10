clear all; clc;
delete start_values97.diary;
diary  start_values97.diary;

user = getenv('USER')

if     strcmp(user,'jared')
	A = importdata('/home/jared/WageReturnsRepo/Analysis/y97_logits_all_binned_t0_16_coef.csv');
	B = importdata('/home/jared/WageReturnsRepo/Analysis/y97_wages_anyschool_school_interaction_t0_16_coef.csv');
	C = importdata('/home/jared/WageReturnsRepo/Analysis/y97_asvab_noFvars_t0_16_coef.csv');
elseif strcmp(user,'ransom')
	A = importdata('/home/data/ransom/WageReturnsRepo/Analysis/y97_logits_all_binned_t0_16_coef.csv');
	B = importdata('/home/data/ransom/WageReturnsRepo/Analysis/y97_wages_anyschool_school_interaction_t0_16_coef.csv');
	C = importdata('/home/data/ransom/WageReturnsRepo/Analysis/y97_asvab_noFvars_t0_16_coef.csv');
else
	'Invalid user'
end

beta_logit  = A.data;
beta_wage   = B.data(1:end-3);
sigma_wage  = B.data(end-2:end);
beta_asvab  = C.data(1:end-6);
sigma_asvab = C.data(end-5:end);


beta  = [beta_logit; beta_wage; beta_asvab];
beta  = beta  + beta.*(0.1*rand(size(beta))-0.05 ); % Perturb beta by +/- 5%;
sigma = [sigma_wage; sigma_asvab];
sigma = sigma + sigma.*(0.1*rand(size(sigma))-0.05 ); % Perturb sigma by +/- 5%;

size(beta)
size(sigma)

save start_values.mat  beta beta_logit beta_wage sigma

diary off
