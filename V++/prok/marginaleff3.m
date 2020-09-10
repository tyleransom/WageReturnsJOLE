global varlistchron varlistchronmod numRegr typeVarId numOutVar SVar KVar iddep varnumber stvar numrows dependent present idmodel interaction idequation location auxvariable N idsum iddep
global XnumInclOutcA XindInclOutcId XindInclOutcRegA XindInclOutcTyp1 XindInclOutcTyp2 XindInclOutcTyp3 XindInclOutcMult XindInclOutcInter XindInclOutcAlter XindInclOutcMinVal XindInclOutcMaxVal 
global XnumInclOutcAK XindInclOutcIdK XindInclOutcRegAK XindInclOutcTyp1K XindInclOutcTyp2K XindInclOutcTyp3K XindInclOutcMultK XindInclOutcInterK XindInclOutcAlterK XindInclOutcMinValK XindInclOutcMaxValK 
global numCondVar numCondVarK numinter interone intertwo interboth intermult numFa factorId1 maxNumFa
global argmarg IdrawWeightsM IgammaM ISSVarM
global nRestrAM nRestrBM rAM rBM regim
global ban1 IindRegrM InuminterM IinteroneM IintertwoM IinterbothM IintermultM IregrM IdefauM InumindivM InumRegrM
global kaha indFirCoefWgts indFirCoefPts indFirCoefMns indFirCoefVars factorType factorPoints naha maxPoints d_omega d_ksi d_mean d_var AdrawFilesM
global numindiv4 IdrawFilesM numDrawsM1 
load descri
load model_all SVar varnumber KVar	typeRestr typePar numOutcRestrA numAltRestrA parRestrA valRestr numOutcRestrB numAltRestrB parRestrB
for ha=1:SVar
	eval(['global mreg' num2str(ha) ' reg' num2str(ha) ' dmydata' num2str(ha)  ' dv' num2str(ha) ''])
end
for ha=1:KVar
	eval(['global default' num2str(ha) ''])
end
for ha=1:varnumber
	eval(['global varval' num2str(ha) ' msvar' num2str(ha) ''])
end
load model_all varlistchronmod varlistchron X* in* num* id* stvar reg* dv* mreg* varval* msvar* dmydata*
load model_all estfile
if estfile==2 | estfile==4
disp('Gauss-Hermite')
	load finput1b
	load cov1b

elseif estfile==1 | estfile==3
	disp('Monte Carlo')
	load finput1a
	load cov1a
	
end


zamma = gamma_final; %from estimation
zammavar = covMatr; %from estimation

% zamma = 0.01*[1:1:(d_alpha+d_beta+d_sigma+d_ksi+d_omega+d_mean+d_var)]'; %from estimation
% zammavar = zamma(1:end-rAB,1)*zamma(1:end-rAB)'; %from estimation = covMatr

py=exist('varchronmodmarg');
if py<1
	margprep0
else
	if length(varchronmodmarg)<1
		margprep0
	end
end


[numindiv1A thresholdvarA legStMarA legAuxMarA varinterMA uniqueVarIdFMA uniqueVarIdIMA indRegrMA numRegrMA regrA defauA fixedvarvalueA SSVarA sizeoutputIA sizeoutputFA numOutVarMA maxNumOutVarMA fixendA varchronmargA] =margprep(Before,varchronmodmarg);
[numindiv1B thresholdvarB legStMarB legAuxMarB varinterMB uniqueVarIdFMB uniqueVarIdIMB indRegrMB numRegrMB regrB defauB fixedvarvalueB SSVarB sizeoutputIB sizeoutputFB numOutVarMB maxNumOutVarMB fixendB varchronmargB] =margprep(After,varchronmodmarg);
[XnumInclOutcMA XindInclOutcIdMA XindInclOutcRegMA XindInclOutcTyp1MA XindInclOutcTyp2MA XindInclOutcTyp3MA XindInclOutcMultMA XindInclOutcInterMA XindInclOutcAlterMA XindInclOutcMinValMA XindInclOutcMaxValMA maxNumInclOutcMA numCondVarMA typeVarIdMA numinterMA interoneMA intertwoMA interbothMA intermultMA maxInterMA numFaMA factorIdMA]=margoutc1(varchronmargA);

margcoefprep %prepare relevant coefficients


margprep1 %preparing changes in regressors


margdraw %drawing weights and draws
margleg %order for inputs

for mm=1:runnumber;
	regrcorr(mm).numindiv=Before.numindiv;
	regrcorr(mm).samepeople=samepeople;
	regrcorr(mm).lastfixed=-999;
	regrcorr(mm).SSVar = SSVarA;
	regrcorr(mm).legStMar = legStMarA;
	regrcorr(mm).legAuxMar = legAuxMarA;
	regrcorr(mm).regr = regrA;
	regrcorr(mm).defau = defauA;
	regrcorr(mm).indRegrM = indRegrMA;
	regrcorr(mm).numRegrM = numRegrMA;
	
	regrcorr(mm).regrid = regrattr(mm).fixedregrid;
	regrcorr(mm).regrval = regrattr(mm).fixedregrval1;
	
	
	[regrMA defauMA] = regrinput(regrcorr(mm));
	
	
	
	ban1=regrcorr(mm);
	ban1.regr = regrMA;
	ban1.defau = defauMA;
	ban1.regrid = regrattr(mm).changeregrid;
	ban1.lastfixed = fixendA;
	regim = regrattr(mm).changeregrval1;
	
	marglegA %stacking inputs

	
	
	regrcorr(mm).numindiv=After.numindiv;
	regrcorr(mm).SSVar = SSVarA;
	regrcorr(mm).legStMar = legStMarA;
	regrcorr(mm).legStAux = legAuxMarA;
	regrcorr(mm).regr = regrB;
	regrcorr(mm).defau = defauB;
	regrcorr(mm).indRegrM = indRegrMA;
	regrcorr(mm).numRegrM = numRegrMA;
	
	regrcorr(mm).regrid = regrattr(mm).fixedregrid;
	regrcorr(mm).regrval = regrattr(mm).fixedregrval1;
	
	ban2=regrcorr(mm);
	
	[regrBM1 defauBM1] = regrinput(regrcorr(mm));
	
	if samepeople==1
		regrcorr(mm).regr = regrBM1;
		regrcorr(mm).defau = defauBM1;
		
		regrcorr(mm).regrid = regrattr(mm).changeregrid;
		regrcorr(mm).regrval = regrattr(mm).changeregrval1;
		
		regrcorr(mm).lastfixed=fixendB;

		[regrMB defauMB] = regrinput(regrcorr(mm));
	else
		regrMB=regrBM1;
		defauMB =  defauBM1;
	end
	
	marglegB %stacking inputs
	
	% [AmatrEA AmatrEI AmatrW AmatrMU AmatrPI]=marg(argmarg{1,:});
	
	% if samepeople==1 & sameweights==1
		% argmarg{2,IdrawWeightsM} = AmatrW;
	% end
	% [BmatrEA BmatrEI BmatrW BmatrMU BmatrPI]=marg(argmarg{2,:});
	
	% finaloutcome = BmatrEA - AmatrEA;
		
	% AmatrEI1=reshape(AmatrEI,sizeoutputFA, max(1,Before.numindiv));
	% BmatrEI1=reshape(BmatrEI,sizeoutputFB, max(1,After.numindiv));
	
	% [AmatrEA AmatrEI1]
	% [BmatrEA BmatrEI1]
	
	% AmatrW'
	% BmatrW'
	
	% AmatrMU'
	% BmatrMU'
	
	% AmatrPI'
	% BmatrPI'
	if regrattr(runnumber).changeregrcode(1,1)~=-1 
	
		slf1 = margcalc(gammaM);
		glf1 = jacobianest(@(x) margcalc(x),gammaM);
		hlf1=glf1*gammavarM*glf1';
		klf1=sqrt(diag(hlf1));
		disp('Marginal effects:')
		slf1
		disp('And their errors:')
		klf1
		
	else
		slf2 = margcalcn(gammaM);
		glf2 = jacobianest(@(x) margcalcn(x),gammaM);
		hlf2=glf2*gammavarM*glf2';
		klf2=sqrt(diag(hlf2));
		disp('Marginal effects:')
		slf2
		disp('And their errors:')
		klf2
	end
	

end


