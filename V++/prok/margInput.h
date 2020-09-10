#ifndef _MARG_INPUT_H_INCLUDED_
#define _MARG_INPUT_H_INCLUDED_

#include <vector>
#include "mex.h"

struct margInput
{
	margInput(const mxArray * const *prhs)
	{
		unsigned Starter, InumindivM, IregrM, IindRegrM, InumRegrM, InumOutVarM, ImaxNumOutVarM, IdefauM, IfixedvarvalueM, InuminterM, IinteroneM, IintertwoM, IinterbothM, IintermultM, ImaxInterM;
		unsigned ISSVarM, ItypeVarIdM, IthresholdvarM, InumCondVarM, IXnumInclOutcM, IXindInclOutcIdM, IXindInclOutcRegM;
		unsigned IXindInclOutcTyp1M, IXindInclOutcTyp2M, IXindInclOutcTyp3M, IXindInclOutcMultM, IXindInclOutcInterM, IXindInclOutcAlterM, IXindInclOutcMinValM, IXindInclOutcMaxValM;
		unsigned ImaxNumInclOutcM, IvarinterM, IuniqueVarIdFM, IsizeoutputFM, IuniqueVarIdIM, IsizeoutputIM, InumFaM, IfactorIdM;
		unsigned ImaxNumFa, Id_alphaM, Id_betaM, Id_sigmaM, IgammaM, IindFirCoefObM, IindFirCoefUnobM, IindFirCoefIdsM, InumDrawsM;
		unsigned InumVarDrawnM, IindDrawPersonM, IdrawWeightsM, IdrawFilesM;

		Starter=0;
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
		
		
		
		SSVarM1 = mxGetPr(prhs[ISSVarM]);
		SSVarM = SSVarM1[0];
		
		//mexPrintf("one_over_sigma_sq[0] is %f[0]\n",one_over_sigma_sq[0]);
		
		maxNumInclOutcM1=mxGetPr(prhs[ImaxNumInclOutcM]);
		maxNumInclOutcM=maxNumInclOutcM1[0];
		
		maxInterM1=mxGetPr(prhs[ImaxInterM]);
		maxInterM=maxInterM1[0];
		
		maxNumFa1=mxGetPr(prhs[ImaxNumFa]);
		maxNumFa=maxNumFa1[0];
		//mexPrintf("maxNumFa is %d\n",maxNumFa);
		
		maxNumOutVarM1=mxGetPr(prhs[ImaxNumOutVarM]);
		maxNumOutVarM=maxNumOutVarM1[0];
		
		numindivM1 = mxGetPr(prhs[InumindivM]);
		numindivM = numindivM1[0];
		//mexPrintf("numindivM is %d\n",numindivM);
		
		regrM = mxGetPr(prhs[IregrM]);
		regrM_size = mxGetN(prhs[IregrM]);
		
		indRegrM1 = mxGetPr(prhs[IindRegrM]);
		std::copy(indRegrM1, indRegrM1 + SSVarM, std::back_inserter(indRegrM));
		
		numRegrM1 = mxGetPr(prhs[InumRegrM]);
		std::copy(numRegrM1, numRegrM1 + SSVarM, std::back_inserter(numRegrM));
		
		numOutVarM1 = mxGetPr(prhs[InumOutVarM]);
		std::copy(numOutVarM1, numOutVarM1 + SSVarM, std::back_inserter(numOutVarM));
		
		defauM = mxGetPr(prhs[IdefauM]);
		defauM_size = mxGetN(prhs[IdefauM]);
		
		sizeob = SSVarM*numindivM;
		
		fixedvarvalueM = mxGetPr(prhs[IfixedvarvalueM]);
		//std::copy(fixedvarvalueM1, fixedvarvalueM1 + sizeob, std::back_inserter(fixedvarvalueM));
		
		numinterM1 = mxGetPr(prhs[InuminterM]);
		std::copy(numinterM1, numinterM1 + SSVarM, std::back_inserter(numinterM));
		
		sizeinter = SSVarM*maxInterM;
		
		interoneM1 = mxGetPr(prhs[IinteroneM]);
		std::copy(interoneM1, interoneM1 + sizeinter, std::back_inserter(interoneM));
		
		intertwoM1 = mxGetPr(prhs[IintertwoM]);
		std::copy(intertwoM1, intertwoM1 + sizeinter, std::back_inserter(intertwoM));
		
		interbothM1 = mxGetPr(prhs[IinterbothM]);
		std::copy(interbothM1, interbothM1 + sizeinter, std::back_inserter(interbothM));
		
		intermultM = mxGetPr(prhs[IintermultM]);
		//std::copy(intermultM1, intermultM1 + sizeinter, std::back_inserter(intermultM));

		typeVarIdM1 = mxGetPr(prhs[ItypeVarIdM]);
		std::copy(typeVarIdM1, typeVarIdM1 + SSVarM, std::back_inserter(typeVarIdM));
		
		thresholdvarM1=mxGetPr(prhs[IthresholdvarM]);
		thresholdvarM=thresholdvarM1[0];
		
		numCondVarM1 = mxGetPr(prhs[InumCondVarM]);
		std::copy(numCondVarM1, numCondVarM1 + SSVarM, std::back_inserter(numCondVarM));
		
		XnumInclOutcM1 = mxGetPr(prhs[IXnumInclOutcM]);
		std::copy(XnumInclOutcM1, XnumInclOutcM1 + SSVarM, std::back_inserter(XnumInclOutcM));
		
		sizeincl=SSVarM*maxNumInclOutcM;
		
		XindInclOutcIdM1 = mxGetPr(prhs[IXindInclOutcIdM]);
		std::copy(XindInclOutcIdM1, XindInclOutcIdM1 + sizeincl, std::back_inserter(XindInclOutcIdM));
		
		XindInclOutcRegM1 = mxGetPr(prhs[IXindInclOutcRegM]);
		std::copy(XindInclOutcRegM1, XindInclOutcRegM1 + sizeincl, std::back_inserter(XindInclOutcRegM));
		
		XindInclOutcTyp1M1 = mxGetPr(prhs[IXindInclOutcTyp1M]);
		std::copy(XindInclOutcTyp1M1, XindInclOutcTyp1M1 + sizeincl, std::back_inserter(XindInclOutcTyp1M));
		
		XindInclOutcTyp2M1 = mxGetPr(prhs[IXindInclOutcTyp2M]);
		std::copy(XindInclOutcTyp2M1, XindInclOutcTyp2M1 + sizeincl, std::back_inserter(XindInclOutcTyp2M));
		
		XindInclOutcTyp3M1 = mxGetPr(prhs[IXindInclOutcTyp3M]);
		std::copy(XindInclOutcTyp3M1, XindInclOutcTyp3M1 + sizeincl, std::back_inserter(XindInclOutcTyp3M));
		
		XindInclOutcMultM = mxGetPr(prhs[IXindInclOutcMultM]);
		
		XindInclOutcInterM1 = mxGetPr(prhs[IXindInclOutcInterM]);
		std::copy(XindInclOutcInterM1, XindInclOutcInterM1 + sizeincl, std::back_inserter(XindInclOutcInterM));
		
		XindInclOutcAlterM1 = mxGetPr(prhs[IXindInclOutcAlterM]);
		std::copy(XindInclOutcAlterM1, XindInclOutcAlterM1 + sizeincl, std::back_inserter(XindInclOutcAlterM));
		
		XindInclOutcMinValM = mxGetPr(prhs[IXindInclOutcMinValM]);
		
		XindInclOutcMaxValM = mxGetPr(prhs[IXindInclOutcMaxValM]);
		
		varinterM1 = mxGetPr(prhs[IvarinterM]);
		inter_size = mxGetM(prhs[IvarinterM]);
		std::copy(varinterM1, varinterM1 + inter_size, std::back_inserter(varinterM));
		
		uniqueVarIdFM1 = mxGetPr(prhs[IuniqueVarIdFM]);
		std::copy(uniqueVarIdFM1, uniqueVarIdFM1 + inter_size, std::back_inserter(uniqueVarIdFM));
		
		sizeoutputFM1=mxGetPr(prhs[IsizeoutputFM]);
		sizeoutputFM=sizeoutputFM1[0];
		//mexPrintf("sizeoutputFM is %d\n",sizeoutputFM);
		
		
		sizeoutputIM1=mxGetPr(prhs[IsizeoutputIM]);
		sizeoutputIM=sizeoutputIM1[0];
		
		uniqueVarIdIM1 = mxGetPr(prhs[IuniqueVarIdIM]);
		std::copy(uniqueVarIdIM1, uniqueVarIdIM1 + sizeoutputIM, std::back_inserter(uniqueVarIdIM));
		
		numFaM1 = mxGetPr(prhs[InumFaM]);
		std::copy(numFaM1, numFaM1 + SSVarM, std::back_inserter(numFaM));
		
		sizefa=maxNumFa*SSVarM;
		
		factorIdM1 = mxGetPr(prhs[IfactorIdM]);
		std::copy(factorIdM1, factorIdM1 + sizefa, std::back_inserter(factorIdM));
		
		d_alphaM1=mxGetPr(prhs[Id_alphaM]);
		d_alphaM=d_alphaM1[0];
		
		d_betaM1=mxGetPr(prhs[Id_betaM]);
		d_betaM=d_betaM1[0];
		
		d_sigmaM1=mxGetPr(prhs[Id_sigmaM]);
		d_sigmaM=d_sigmaM1[0];
		
		gammaM = mxGetPr(prhs[IgammaM]);
		
		indFirCoefObM1 = mxGetPr(prhs[IindFirCoefObM]);
		std::copy(indFirCoefObM1, indFirCoefObM1 + SSVarM, std::back_inserter(indFirCoefObM));
		
		indFirCoefUnobM1 = mxGetPr(prhs[IindFirCoefUnobM]);
		std::copy(indFirCoefUnobM1, indFirCoefUnobM1 + SSVarM, std::back_inserter(indFirCoefUnobM));
		
		indFirCoefIdsM1 = mxGetPr(prhs[IindFirCoefIdsM]);
		std::copy(indFirCoefIdsM1, indFirCoefIdsM1 + SSVarM, std::back_inserter(indFirCoefIdsM));
		
		numDrawsM1=mxGetPr(prhs[InumDrawsM]);
		numDrawsM=numDrawsM1[0];
		
		numVarDrawnM1=mxGetPr(prhs[InumVarDrawnM]);
		numVarDrawnM=numVarDrawnM1[0];
		
		indDrawPersonM1 = mxGetPr(prhs[IindDrawPersonM]);
		std::copy(indDrawPersonM1, indDrawPersonM1 + numindivM, std::back_inserter(indDrawPersonM));
		
		drawWeightsM = mxGetPr(prhs[IdrawWeightsM]);
		
		drawFilesM = mxGetPr(prhs[IdrawFilesM]);
		

		
		
	}
	
	double* SSVarM1;
	unsigned SSVarM;
	
	double* maxNumInclOutcM1;
	unsigned maxNumInclOutcM;
	
	double* maxInterM1;
	unsigned maxInterM;
	
	double* maxNumFa1;
	unsigned maxNumFa;
	
	double* maxNumOutVarM1;
	unsigned maxNumOutVarM;
	
	double* numindivM1;
	unsigned numindivM;
	
	double* regrM;
	unsigned regrM_size;
	
	double* indRegrM1;
	std::vector<unsigned>indRegrM;
	
	double* numRegrM1;
	std::vector<unsigned>numRegrM;
	
	double* numOutVarM1;
	std::vector<unsigned>numOutVarM;
	
	double* defauM;
	unsigned defauM_size;
	
	unsigned sizeob;
	
	double* fixedvarvalueM;
	//std::vector<double>fixedvarvalueM;
	
	double* numinterM1;
	std::vector<unsigned>numinterM;
	
	unsigned sizeinter;
	
	double* interoneM1;
	std::vector<unsigned>interoneM;
	
	double* intertwoM1;
	std::vector<unsigned>intertwoM;
	
	double* interbothM1;
	std::vector<unsigned>interbothM;
	
	double* intermultM;
	//std::vector<unsigned>intermultM;
	
	double* typeVarIdM1;
	std::vector<unsigned>typeVarIdM;
	
	double* thresholdvarM1;
	unsigned thresholdvarM;
	
	double* numCondVarM1;
	std::vector<unsigned>numCondVarM;
	
	double* XnumInclOutcM1;
	std::vector<unsigned>XnumInclOutcM;
	
	unsigned sizeincl;
	
	double* XindInclOutcIdM1;
	std::vector<unsigned>XindInclOutcIdM;
	
	double* XindInclOutcRegM1;
	std::vector<unsigned>XindInclOutcRegM;
	
	double* XindInclOutcTyp1M1;
	std::vector<unsigned>XindInclOutcTyp1M;
	
	double* XindInclOutcTyp2M1;
	std::vector<unsigned>XindInclOutcTyp2M;
	
	double* XindInclOutcTyp3M1;
	std::vector<unsigned>XindInclOutcTyp3M;
	
	double* XindInclOutcMultM;
	
	double* XindInclOutcInterM1;
	std::vector<unsigned>XindInclOutcInterM;
	
	double* XindInclOutcAlterM1;
	std::vector<unsigned>XindInclOutcAlterM;
	
	double* XindInclOutcMinValM;
	
	double* XindInclOutcMaxValM;
	
	double* varinterM1;
	unsigned inter_size; 
	std::vector<unsigned>varinterM;
	
	double* uniqueVarIdFM1; 
	std::vector<unsigned>uniqueVarIdFM;
	
	double* sizeoutputFM1;
	unsigned sizeoutputFM;
	
	double* sizeoutputIM1;
	unsigned sizeoutputIM;
	
	double* uniqueVarIdIM1; 
	std::vector<unsigned>uniqueVarIdIM;
	
	double* numFaM1;
	std::vector<unsigned>numFaM;
		
	unsigned sizefa;
		
	double* factorIdM1;
	std::vector<unsigned>factorIdM;
	
	double* d_alphaM1;
	unsigned d_alphaM;
		
	double* d_betaM1;
	unsigned d_betaM;
		
	double* d_sigmaM1;
	unsigned d_sigmaM;
		
	double* gammaM;
	
	double* indFirCoefObM1;
	std::vector<unsigned>indFirCoefObM;
	
	double* indFirCoefUnobM1;
	std::vector<unsigned>indFirCoefUnobM;
	
	double* indFirCoefIdsM1;
	std::vector<unsigned>indFirCoefIdsM;
		
	double* numDrawsM1;
	unsigned numDrawsM;
		
	double* numVarDrawnM1;
	unsigned numVarDrawnM;
	
	double* indDrawPersonM1;
	std::vector<unsigned>indDrawPersonM;
	
	double* drawWeightsM;

	double* drawFilesM; 
	
	

};
	

/* Notes:
	*/
#endif //_MARG_INPUT_H_INCLUDED_
