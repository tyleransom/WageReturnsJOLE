load model_all estfile typeEst estfileB estfileA
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

if estfile==1
	disp('Monte Carlo, no missing data')
	form_inputTJK2
elseif estfile==2
	disp('Gauss-Hermite, no missing data')
	%form_inputTJL2b
	form_inputTJL2a
elseif estfile==3
	disp('Monte Carlo, missing data')
	form_inputTJK1
elseif estfile==4
	disp('Gauss-Hermite, missing data')
	form_inputTJL1b
	form_inputTJL1a
end