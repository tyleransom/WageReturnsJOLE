load model_all estfile
if estfile==2
disp('Gauss-Hermite')
	opt_routf3ga
	
elseif estfile==4
	load finput1b exg
	if exg==0
	disp('Gauss-Hermite')
		opt_routf3ga
		
	else
		disp ('Standard normal distribution with Monte Carlo integration should be chose when i.i.d. shocks have to be simulated')
	end
elseif estfile==1 | estfile==3
	disp('Monte Carlo')
	opt_routf2ga
	
end