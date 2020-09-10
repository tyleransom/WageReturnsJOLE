global varlistchron varlistchronmod numRegr typeVarId numOutVar SVar KVar iddep varnumber stvar numrows dependent present idmodel interaction idequation location auxvariable N idsum iddep
global XnumInclOutcA XindInclOutcId XindInclOutcRegA XindInclOutcTyp1 XindInclOutcTyp2 XindInclOutcTyp3 XindInclOutcMult XindInclOutcInter XindInclOutcAlter XindInclOutcMinVal XindInclOutcMaxVal 
global XnumInclOutcAK XindInclOutcIdK XindInclOutcRegAK XindInclOutcTyp1K XindInclOutcTyp2K XindInclOutcTyp3K XindInclOutcMultK XindInclOutcInterK XindInclOutcAlterK XindInclOutcMinValK XindInclOutcMaxValK 
global numCondVar numCondVarK numinter interone intertwo interboth intermult numFa factorId1 maxNumFa
global argmarg IdrawWeightsM IgammaM ISSVarM
global nRestrAM nRestrBM rAM rBM regim
global ban1 IindRegrM InuminterM IinteroneM IintertwoM IinterbothM IintermultM IregrM IdefauM InumindivM InumRegrM
global kaha indFirCoefWgts indFirCoefPts indFirCoefMns indFirCoefVars factorType factorPoints naha maxPoints d_omega d_ksi d_mean d_var AdrawFilesM
global numindiv4 IdrawFilesM numDrawsM1 
global samepeople sameweights
load descri
load model_all SVar varnumber KVar typeRestr 
if length(typeRestr)>0
	load model_all typePar numOutcRestrA numAltRestrA parRestrA valRestr numOutcRestrB numAltRestrB parRestrB
end
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



Before.earlyvar=Before.varinter; %earliest dependent variable involved
Before.fixedvar=[]; %ids of fixed variables (one row)
Before.fixedvarval=[]; %values to which outcomes are fixed if numindiv==0 or variable id if numindiv>0 (0 if the default from the data set)
Before.numindiv=length(Before.indid);

After=Before;
samepeople=1; %1 if same people in both before and after, 0 otherwise (always 1 if numindiv=0)
sameweights=1; %1 if the weights resulting from run 1 go as an input to run 2

allregr = find(iddep==Before.varinter);
for runnumber=1:numregA(allregr,1) %number of runs
	regrattr(runnumber).fixedregrid=fixedregridC; %id of regressor fixed before and after change (unless in changeregrid, the fixed only before change)
	regrattr(runnumber).fixedregrval=fixedregrvalC; %values to which regressors are fixed if numindiv==0 or variable id if numindiv>0
	regrattr(runnumber).changeregrid=[idregA(runnumber,allregr)]; % regressors changing
	regrattr(runnumber).changeregrcode=-1; % regressors changing
	regrattr(runnumber).changeregrvalue=[0]; % if changeregrcode=1 - the change,  if changeregrcode=2 - the new value if numindiv==0 or variable id if numindiv>0
end

eval(['regrid_' num2str(allregr) '= transpose(idregA(1:numregA(allregr,1),allregr));'])



margprep0


[numindiv1A thresholdvarA legStMarA legAuxMarA varinterMA uniqueVarIdFMA uniqueVarIdIMA indRegrMA numRegrMA regrA defauA fixedvarvalueA SSVarA sizeoutputIA sizeoutputFA numOutVarMA maxNumOutVarMA fixendA varchronmargA] =margprep(Before,varchronmodmarg);
[numindiv1B thresholdvarB legStMarB legAuxMarB varinterMB uniqueVarIdFMB uniqueVarIdIMB indRegrMB numRegrMB regrB defauB fixedvarvalueB SSVarB sizeoutputIB sizeoutputFB numOutVarMB maxNumOutVarMB fixendB varchronmargB] =margprep(After,varchronmodmarg);
[XnumInclOutcMA XindInclOutcIdMA XindInclOutcRegMA XindInclOutcTyp1MA XindInclOutcTyp2MA XindInclOutcTyp3MA XindInclOutcMultMA XindInclOutcInterMA XindInclOutcAlterMA XindInclOutcMinValMA XindInclOutcMaxValMA maxNumInclOutcMA numCondVarMA typeVarIdMA numinterMA interoneMA intertwoMA interbothMA intermultMA maxInterMA numFaMA factorIdMA]=margoutc1(varchronmargA);

% interoneMA - linear
% intertwoMA - quadratic
% interbothMA - cubic
% intermultMA - multiplier

save bintermediateMarginalsVVS interoneMA intertwoMA interbothMA intermultMA numinterMA maxInterMA
interoneMA(1,end+1:end+21)=[0 1 9 0 1 16 0 1 24 0 1 33 0 1 43 0 1 54 0 1 61];
intertwoMA(1,end+1:end+21)=[12 12 12 19 19 19 27 27 27 36 36 36 46 46 46 57 57 57 64 64 64];
interbothMA(1,end+1:end+21)=[13 14 15 21 22 23 30 31 32 40 41 42 51 52 53 58 59 60 65 66 67];
intermultMA(1,end+1:end+21)=[1 1 0.1 1 1 0.1 1 1 0.1 1 1 0.1 1 1 0.1 1 1 0.1 1 1 0.1];
% interoneMA(1,end+1:end+1)=[0]; 
% intertwoMA(1,end+1:end+1)=[12];
% interbothMA(1,end+1:end+1)=[13];
% intermultMA(1,end+1:end+1)=[1];
numinterMA=size(interoneMA,2);
maxInterMA=numinterMA;

numCondVarMA=0;

margcoefprep %prepare relevant coefficients


margprep1 %preparing changes in regressors


margdraw %drawing weights and draws
margleg %order for inputs

eval(['eff_' num2str(allregr) '= [];'])
eval(['steff_' num2str(allregr) '= [];'])
eval(['geff_' num2str(allregr) '= [];'])

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
	regrMA
	
	
	ban1=regrcorr(mm);
	ban1.regr = regrMA;
	ban1.defau = defauMA;
	ban1.regrid = regrattr(mm).changeregrid;
	ban1.lastfixed = fixendA;
	%kan(mm)=ban1;
	regim = regrattr(mm).changeregrval1;
	kegim(mm)=regim;
	
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
	
	[AmatrEA AmatrEI AmatrW AmatrMU AmatrPI]=marg(argmarg{1,:});
	AmatrEA
	save cintermediateMarginalsVVS regrMA interoneMA intertwoMA interbothMA intermultMA regrMB AmatrEA numinterMA maxInterMA
	
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
	
	
	if regrattr(mm).changeregrcode(1,1)~=-1 
		slf1 = margcalc(gammaM);
		glf1 = jacobianest(@(x) margcalc(x),gammaM);
		hlf1=glf1*gammavarM*glf1';
		klf1=sqrt(diag(hlf1));
		eval(['eff_' num2str(allregr)   '= [eff_'   num2str(allregr) ' slf1];'])
		eval(['steff_' num2str(allregr) '= [steff_' num2str(allregr) ' klf1];'])
		eval(['geff_' num2str(allregr)  '= [geff_'  num2str(allregr) '; glf1];'])
	else
		slf2 = margcalcn(gammaM);
		glf2 = jacobianest(@(x) margcalcn(x),gammaM);
		hlf2=glf2*gammavarM*glf2';
		klf2=sqrt(diag(hlf2));
		eval(['eff_' num2str(allregr)   '= [eff_'   num2str(allregr) ' slf2];'])
		eval(['steff_' num2str(allregr) '= [steff_' num2str(allregr) ' klf2];'])
		eval(['geff_' num2str(allregr)  '= [geff_'  num2str(allregr) '; glf2];'])
	end
	

end
save dintermediateMarginalsVVS  eff* steff* geff*
% disp(['Number of runs is: ',num2str(runnumber)]);
% allregr; % DV#

% mfx.regrid = eval(['regrid_' num2str(allregr) '''']);
% mfx.eff    = eval(['eff_'    num2str(allregr) '''']);
% mfx.se     = eval(['steff_'  num2str(allregr) '''']);
% mfx.gees   = eval(['geff_'   num2str(allregr) ]);

% [mfx.R mfx.C] = size(mfx.eff);

% mfx.alt    = mfx.eff;
% mfx.alt(:,1) = ones(mfx.R,1);

% if mfx.C>1 
	% for j=2:mfx.C
		% mfx.alt(:,j)=mfx.alt(:,j-1)+ones(mfx.R,1);
	% end
	
	% mfx.regrid = repmat(mfx.regrid,mfx.C-1,1);
	
	% mfx.eff    = mfx.eff(:,1:mfx.C-1);
	% mfx.eff    = mfx.eff(:);
	
	% mfx.se     = mfx.se(:,1:mfx.C-1);
	% mfx.se     = mfx.se(:);
	
	% mfx.alt    = mfx.alt(:,1:mfx.C-1);
	% mfx.alt    = mfx.alt(:);	
% end
% [mfx.R2 mfx.C2] = size(mfx.regrid);

% fprintf('\n %8s %4g','DV --',allregr);
% fprintf('\n --------------------------------------------------------------');
% fprintf('\n %13s %13s %13s %13s','alternative ','varnumber ','mfx ','se mfx ');
% fprintf('\n --------------------------------------------------------------\n');
% for i = 1:mfx.R2
	% fprintf('%13g %13g %13g %13g \n',mfx.alt(i),mfx.regrid(i),mfx.eff(i),mfx.se(i));
% end
% fprintf(' --------------------------------------------------------------\n');