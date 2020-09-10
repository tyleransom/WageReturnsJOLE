load model_all regnames outcname numRegrU numOutVarU numFaU factorIdU unvarU factorTypes factorPoints factorEval estfile
if estfile==1 | estfile==3
	load finput1a indFir* d_beta d_alpha d_sigma d_ksi d_omega d_mean d_var
	load cov1a
else
	load finput1b indFir* d_beta d_alpha d_sigma d_ksi d_omega d_mean d_var
	load cov1b
end

kaf=length(unvarU);
headers = cellstr(char('Coef','Std Error'))';
for i=1:kaf
	if numOutVarU(i,1)==1
		gammaob=gamma_final(indFirCoefOb(unvarU(i,1),1)+1:indFirCoefOb(unvarU(i,1),1)+numRegrU(i,1),1);
		sErrorsob=sErrors(indFirCoefOb(unvarU(i,1),1)+1:indFirCoefOb(unvarU(i,1),1)+numRegrU(i,1),1);
		if numFaU(i,1)>0
			gammaob=[gammaob; gamma_final(d_beta+indFirCoefUnob(unvarU(i,1),1)+1:d_beta+d_alpha+indFirCoefUnob(unvarU(i,1),1)+numFaU(i,1),1)];
			sErrorsob=[sErrors; sErrors(d_beta+indFirCoefUnob(unvarU(i,1),1)+1:d_beta+d_alpha+indFirCoefUnob(unvarU(i,1),1)+numFaU(i,1),1)];
		end
		gammaob=[gammaob; gamma_final(d_beta+d_alpha+indFirCoefIds(unvarU(i,1),1)+1,1)];
		sErrorsob=[sErrorsob; sErrors(d_beta+d_alpha+indFirCoefIds(unvarU(i,1),1)+1,1)];
		
		estimob = num2cell([gammaob sErrorsob]);
		
		resie = cat(2,regnames{i,1},cat(1,headers,estimob));
		
		disp(outcname{i,1})
		resie
	else
		for kaj=1:numOutVarU(i,1)-1
			gammaob=gamma_final(indFirCoefOb(unvarU(i,1),1)+1+(kaj-1)*numRegrU(i,1):indFirCoefOb(unvarU(i,1),1)+kaj*numRegrU(i,1),1);
			sErrorsob=sErrors(indFirCoefOb(unvarU(i,1),1)+1+(kaj-1)*numRegrU(i,1):indFirCoefOb(unvarU(i,1),1)+kaj*numRegrU(i,1),1);
			if numFaU(i,1)>0
				gammaob=[gammaob; gamma_final(d_beta+indFirCoefUnob(unvarU(i,1),1)+1+(kaj-1)*numFaU(i,1):d_beta+d_alpha+indFirCoefUnob(unvarU(i,1),1)+kaj*numFaU(i,1),1)];
				sErrorsob=[sErrors; sErrors(d_beta+indFirCoefUnob(unvarU(i,1),1)+1+(kaj-1)*numFaU(i,1):d_beta+d_alpha+indFirCoefUnob(unvarU(i,1),1)+kaj*numFaU(i,1),1)];
			end
			
			estimob = num2cell([gammaob sErrorsob]);
			
			resie = cat(2,regnames{i,1},cat(1,headers,estimob));
			
			disp(outcname{i,1})
			disp('Alternative' num2str(kaj))
			resie
		end
	end
end
			