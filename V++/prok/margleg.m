% unsigned Starter, InumindivM, IregrM, IindRegrM, InumRegrM, InumOutVarM, ImaxNumOutVarM, IdefauM, IfixedvarvalueM, InuminterM, IinteroneM, IintertwoM, IinterbothM, IintermultM, ImaxInterM;
% unsigned ISSVarM, ItypeVarIdM, IthresholdvarM, InumCondVarM, IXnumInclOutcM, IXindInclOutcIdM, IXindInclOutcRegM;
% unsigned IXindInclOutcTyp1M, IXindInclOutcTyp2M, IXindInclOutcTyp3M, IXindInclOutcMultM, IXindInclOutcInterM, IXindInclOutcAlterM, IXindInclOutcMinValM, IXindInclOutcMaxValM;
% unsigned ImaxNumInclOutcM, IvarinterM, IuniqueVarIdFM, IsizeoutputFM, IuniqueVarIdIM, IsizeoutputIM, InumFaM, IfactorIdM;
% unsigned ImaxNumFa, Id_alphaM, Id_betaM, Id_sigmaM, IgammaM, IindFirCoefObM, IindFirCoefUnobM, IindFirCoefIdsM,InumDrawsM;
% unsigned InumVarDrawnM, IindDrawPersonM, IdrawWeightsM, IdrawFilesM;

Starter=1;
InumindivM=Starter;
IregrM = InumindivM+1;
IindRegrM = IregrM+1;
InumRegrM = IindRegrM+1;
InumOutVarM = InumRegrM+1;
ImaxNumOutVarM = InumOutVarM+1;
IdefauM = ImaxNumOutVarM+1;
IfixedvarvalueM = IdefauM+1;

InuminterM = IfixedvarvalueM+1;
IinteroneM = InuminterM+1;
IintertwoM = IinteroneM+1;
IinterbothM = IintertwoM+1;
IintermultM = IinterbothM+1; 
ImaxInterM = IintermultM+1;

ISSVarM = ImaxInterM+1;
ItypeVarIdM = ISSVarM+1;
IthresholdvarM = ItypeVarIdM+1;
InumCondVarM = IthresholdvarM+1;
IXnumInclOutcM = InumCondVarM+1; 
IXindInclOutcIdM = IXnumInclOutcM+1;
IXindInclOutcRegM = IXindInclOutcIdM+1;
IXindInclOutcTyp1M = IXindInclOutcRegM+1;
IXindInclOutcTyp2M = IXindInclOutcTyp1M+1;
IXindInclOutcTyp3M = IXindInclOutcTyp2M+1;
IXindInclOutcMultM = IXindInclOutcTyp3M+1;
IXindInclOutcInterM = IXindInclOutcMultM+1;
IXindInclOutcAlterM = IXindInclOutcInterM+1;
IXindInclOutcMinValM = IXindInclOutcAlterM+1;
IXindInclOutcMaxValM = IXindInclOutcMinValM+1;
ImaxNumInclOutcM = IXindInclOutcMaxValM+1;

IvarinterM = ImaxNumInclOutcM+1;
IuniqueVarIdFM = IvarinterM+1;
IsizeoutputFM = IuniqueVarIdFM+1; 
IuniqueVarIdIM = IsizeoutputFM+1;
IsizeoutputIM = IuniqueVarIdIM+1; 

InumFaM = IsizeoutputIM+1;
IfactorIdM = InumFaM+1;
ImaxNumFa = IfactorIdM+1;

Id_alphaM =  ImaxNumFa+1;
Id_betaM = Id_alphaM+1;
Id_sigmaM = Id_betaM+1;
IgammaM = Id_sigmaM+1;
IindFirCoefObM = IgammaM+1;
IindFirCoefUnobM = IindFirCoefObM+1;
IindFirCoefIdsM = IindFirCoefUnobM+1;

InumDrawsM = IindFirCoefIdsM+1;
InumVarDrawnM = InumDrawsM+1;
IindDrawPersonM = InumVarDrawnM+1;

IdrawWeightsM = IindDrawPersonM+1;
IdrawFilesM = IdrawWeightsM+1;




