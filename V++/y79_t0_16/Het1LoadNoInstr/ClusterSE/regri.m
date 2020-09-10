clear all;
delete regri.diary;
diary  regri.diary;
tic

vladppadd
descri
load ../../data_import79

typeEst  = 1; % 1 if numerical integration, 0 if simulated draws (only if all factors are type 1)
typeRand = 1; %type of draws if typeEst=0 (1 if random, 2 halton sequence, 3 scrambled halton)

factorType   = 1*ones(2,1);
factorEval   = 7*ones(2,1);
factorPoints = 1*ones(2,1);
% factorType(1,1)  =1;   % type factor (1 if standard normal distribution, 2 if discrete distribution, 3 if normal distribution with mean and variance, 4 if mixture of normal distributions
% factorEval(1,1)  =100; % If Monte Carlo, number of draws. If numerical integration, number of quadrature points per distribution; set to 1 for discrete distribution.
% factorPoints(1,1)=1;   % Only if numerical integration??? If continuous distribution, number of distributions in the mixture. If discrete distribution, number of mass points.

GroupN=N; %for speed of calculations
drawFileCount=1;    %number of files in which the random draws are stored /factors/ - if only types 1, otherwise 1 by default

maxNumFa =  length(factorType);

numcond = numfac+maxNumFa+1; %number of conditions for vairables resulting from switching modes

numberrest = numcond+1; %number of parameter restrictions for the variable

stvar=zeros(1,numberrest);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% reference names
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
T=240;
holder                  = 153; % placeholder for varnumber sequence. JA - Why not 150?

name.black              = 1 ;
name.hispanic           = 2 ;
name.born1957           = 3 ;
name.born1958           = 4 ;
name.born1959           = 5 ;
name.born1960           = 6 ;
name.born1961           = 7 ;
name.born1962           = 8 ;
name.born1963           = 9 ;
name.born1980           = 10;
name.born1981           = 11;
name.born1982           = 12;
name.born1983           = 13;
name.foreignBorn        = 14;
name.afqt               = 15;
name.asvabAR            = 16;
name.asvabCS            = 17;
name.asvabMK            = 18;
name.asvabNO            = 19;
name.asvabPC            = 20;
name.asvabWK            = 21;
name.m_afqt             = 22;
name.m_asvabAR          = 23;
name.m_asvabCS          = 24;
name.m_asvabMK          = 25;
name.m_asvabNO          = 26;
name.m_asvabPC          = 27;
name.m_asvabWK          = 28;
name.empPct             = 29;
name.incPerCapita       = 30;
name.schoolOnly         = 31;
name.schoolOnlySqBlack  = 32;
name.schoolOnlySqHisp   = 33;
name.schoolOnlyCu       = 34;
name.anySchool          = 35;
name.anySchoolSqBlack   = 36;
name.anySchoolSqHisp    = 37;
name.anySchoolCu        = 38;
name.workK12            = 39;
name.workK12SqBlack     = 40;
name.workK12SqHisp      = 41;
name.workK12Cu          = 42;
name.workCollege        = 43;
name.workCollegeSqBlack = 44;
name.workCollegeSqHisp  = 45;
name.workCollegeCu      = 46;
name.workPT             = 47;
name.workPTSqBlack      = 48;
name.workPTSqHisp       = 49;
name.workPTCu           = 50;
name.workFT             = 51;
name.workFTSqBlack      = 52;
name.workFTSqHisp       = 53;
name.workFTCu           = 54;
name.military           = 55;
name.militarySqBlack    = 56;
name.militarySqHisp     = 57;
name.militaryCu         = 58;
name.other              = 59;
name.otherSqBlack       = 60;
name.otherSqHisp        = 61;
name.otherCu            = 62;
name.potExp             = 63;
name.potExpSq           = 64;
name.potExpCu           = 65;
name.gradHS             = 66;
name.grad4yr            = 67;
name.inSchWork          = 68;
name.PTwork             = 69;
name.Choices1           = 70;
name.Choices2           = 71;
name.Choices3           = 72;
name.Wage1              = 73;
name.Wage2              = 74;
name.Wage3              = 75;
name.workSchL12         = 76;
name.hgcMoth            = 77;
name.hgcMothSq          = 78;
name.m_hgcMoth          = 79;
name.hgcFath            = 80;
name.hgcFathSq          = 81;
name.m_hgcFath          = 82;
name.famInc             = 83;
name.famIncSq           = 84;
name.m_famInc           = 85;
name.femaleHeadHH14     = 86;
name.liveWithMom14      = 87;
name.numBAzero          = 88 ;
name.numBAperCapita     = 89 ;
name.tuitionFlagship    = 90 ;
name.schoolOnlyBin1     = 91 ;
name.schoolOnlyBin2     = 92 ;
name.schoolOnlyBin3     = 93 ;
name.schoolOnlyBin4     = 94 ;
name.schoolOnlyBin5     = 95 ;
name.schoolOnlyBin6     = 96 ;
name.schoolOnlyBin7     = 97 ;
name.schoolOnlyBin8     = 98 ;
name.schoolOnlyBin9     = 99 ;
name.workK12Bin1        = 100;
name.workK12Bin2        = 101;
name.workK12Bin3        = 102;
name.workK12Bin4        = 103;
name.workK12Bin5        = 104;
name.workK12Bin6        = 105;
name.workK12Bin7        = 106;
name.workK12Bin8        = 107;
name.workK12Bin9        = 108;
name.workCollegeBin1    = 109;
name.workCollegeBin2    = 110;
name.workCollegeBin3    = 111;
name.workCollegeBin4    = 112;
name.workCollegeBin5    = 113;
name.workCollegeBin6    = 114;
name.workCollegeBin7    = 115;
name.workCollegeBin8    = 116;
name.workCollegeBin9    = 117;
name.workPTonlyBin1     = 118;
name.workPTonlyBin2     = 119;
name.workPTonlyBin3     = 120;
name.workPTonlyBin4     = 121;
name.workPTonlyBin5     = 122;
name.workPTonlyBin6     = 123;
name.workPTonlyBin7     = 124;
name.workPTonlyBin8     = 125;
name.workPTonlyBin9     = 126;
name.workFTonlyBin1     = 127;
name.workFTonlyBin2     = 128;
name.workFTonlyBin3     = 129;
name.workFTonlyBin4     = 130;
name.workFTonlyBin5     = 131;
name.workFTonlyBin6     = 132;
name.workFTonlyBin7     = 133;
name.workFTonlyBin8     = 134;
name.workFTonlyBin9     = 135;
name.militaryBin1       = 136;
name.militaryBin2       = 137;
name.militaryBin3       = 138;
name.militaryBin4       = 139;
name.militaryBin5       = 140;
name.otherBin1          = 141;
name.otherBin2          = 142;
name.otherBin3          = 143;
name.otherBin4          = 144;
name.otherBin5          = 145;
name.otherBin6          = 146;
name.otherBin7          = 147;
name.otherBin8          = 148;
name.otherBin9          = 149;
name.constant           = 150;

type.d.regressor        = 0;
type.d.dependent        = 1;
type.d.ChoiceOrSum      = 2;
type.d.condition        = 3;
type.d.stateVar         = 4;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Period 0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%==========================================================
% Constant/Non-time varying variables
%==========================================================
for t=1:T;t
	varnumber=t*holder+name.black; eval(['varval' num2str(varnumber) ' = black(:,:,1);']); namevar{varnumber,1}='black'; stvar(1,discrete,varnumber)=1;
		rownumber= 1; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices1;
		rownumber= 2; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices1; stvar(rownumber,multiplier ,varnumber)=1; stvar(rownumber,interaction,varnumber)=t*holder+name.schoolOnly;
		rownumber= 3; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices1; stvar(rownumber,multiplier ,varnumber)=1; stvar(rownumber,interaction,varnumber)=t*holder+name.workK12;
		% rownumber= 4; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices1; stvar(rownumber,multiplier ,varnumber)=1; stvar(rownumber,interaction,varnumber)=t*holder+name.workCollege;
		rownumber= 5; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices1; stvar(rownumber,multiplier ,varnumber)=1; stvar(rownumber,interaction,varnumber)=t*holder+name.workPT;
		rownumber= 6; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices1; stvar(rownumber,multiplier ,varnumber)=1; stvar(rownumber,interaction,varnumber)=t*holder+name.workFT;
		% rownumber= 7; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices1; stvar(rownumber,multiplier ,varnumber)=1; stvar(rownumber,interaction,varnumber)=t*holder+name.military;
		rownumber= 8; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices1; stvar(rownumber,multiplier ,varnumber)=1; stvar(rownumber,interaction,varnumber)=t*holder+name.other;

		rownumber= 9; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices2;
		rownumber=10; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices2; stvar(rownumber,multiplier ,varnumber)=1; stvar(rownumber,interaction,varnumber)=t*holder+name.schoolOnly;
		rownumber=11; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices2; stvar(rownumber,multiplier ,varnumber)=1; stvar(rownumber,interaction,varnumber)=t*holder+name.workK12;
		rownumber=12; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices2; stvar(rownumber,multiplier ,varnumber)=1; stvar(rownumber,interaction,varnumber)=t*holder+name.workCollege;
		rownumber=13; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices2; stvar(rownumber,multiplier ,varnumber)=1; stvar(rownumber,interaction,varnumber)=t*holder+name.workPT;
		rownumber=14; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices2; stvar(rownumber,multiplier ,varnumber)=1; stvar(rownumber,interaction,varnumber)=t*holder+name.workFT;
		rownumber=15; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices2; stvar(rownumber,multiplier ,varnumber)=1; stvar(rownumber,interaction,varnumber)=t*holder+name.military;
		rownumber=16; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices2; stvar(rownumber,multiplier ,varnumber)=1; stvar(rownumber,interaction,varnumber)=t*holder+name.other;

		rownumber=17; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices3;
		rownumber=18; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices3; stvar(rownumber,multiplier ,varnumber)=1; stvar(rownumber,interaction,varnumber)=t*holder+name.schoolOnly;
		rownumber=19; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices3; stvar(rownumber,multiplier ,varnumber)=1; stvar(rownumber,interaction,varnumber)=t*holder+name.workK12;
		rownumber=20; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices3; stvar(rownumber,multiplier ,varnumber)=1; stvar(rownumber,interaction,varnumber)=t*holder+name.workCollege;
		rownumber=21; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices3; stvar(rownumber,multiplier ,varnumber)=1; stvar(rownumber,interaction,varnumber)=t*holder+name.workPT;
		rownumber=22; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices3; stvar(rownumber,multiplier ,varnumber)=1; stvar(rownumber,interaction,varnumber)=t*holder+name.workFT;
		rownumber=23; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices3; stvar(rownumber,multiplier ,varnumber)=1; stvar(rownumber,interaction,varnumber)=t*holder+name.military;
		rownumber=24; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices3; stvar(rownumber,multiplier ,varnumber)=1; stvar(rownumber,interaction,varnumber)=t*holder+name.other;

		rownumber=25; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Wage1;
		rownumber=26; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Wage2;
		rownumber=27; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Wage3;
		if t==1
			rownumber=28; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.asvabAR;
			rownumber=29; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.asvabCS;
			rownumber=30; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.asvabMK;
			rownumber=31; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.asvabNO;
			rownumber=32; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.asvabPC;
			rownumber=33; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.asvabWK;
		end
		stvar(1,numrows,varnumber)=rownumber;

	varnumber=t*holder+name.hispanic; eval(['varval' num2str(varnumber) ' = hispanic(:,:,1);']); namevar{varnumber,1}='hispanic'; stvar(1,discrete,varnumber)=1;
		rownumber= 1; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices1;
		rownumber= 2; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices1; stvar(rownumber,multiplier ,varnumber)=1; stvar(rownumber,interaction,varnumber)=t*holder+name.schoolOnly;
		rownumber= 3; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices1; stvar(rownumber,multiplier ,varnumber)=1; stvar(rownumber,interaction,varnumber)=t*holder+name.workK12;
		rownumber= 4; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices1; stvar(rownumber,multiplier ,varnumber)=1; stvar(rownumber,interaction,varnumber)=t*holder+name.workCollege;
		rownumber= 5; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices1; stvar(rownumber,multiplier ,varnumber)=1; stvar(rownumber,interaction,varnumber)=t*holder+name.workPT;
		rownumber= 6; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices1; stvar(rownumber,multiplier ,varnumber)=1; stvar(rownumber,interaction,varnumber)=t*holder+name.workFT;
		% rownumber= 7; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices1; stvar(rownumber,multiplier ,varnumber)=1; stvar(rownumber,interaction,varnumber)=t*holder+name.military;
		rownumber= 8; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices1; stvar(rownumber,multiplier ,varnumber)=1; stvar(rownumber,interaction,varnumber)=t*holder+name.other;

		rownumber= 9; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices2;
		rownumber=10; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices2; stvar(rownumber,multiplier ,varnumber)=1; stvar(rownumber,interaction,varnumber)=t*holder+name.schoolOnly;
		rownumber=11; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices2; stvar(rownumber,multiplier ,varnumber)=1; stvar(rownumber,interaction,varnumber)=t*holder+name.workK12;
		rownumber=12; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices2; stvar(rownumber,multiplier ,varnumber)=1; stvar(rownumber,interaction,varnumber)=t*holder+name.workCollege;
		rownumber=13; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices2; stvar(rownumber,multiplier ,varnumber)=1; stvar(rownumber,interaction,varnumber)=t*holder+name.workPT;
		rownumber=14; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices2; stvar(rownumber,multiplier ,varnumber)=1; stvar(rownumber,interaction,varnumber)=t*holder+name.workFT;
		rownumber=15; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices2; stvar(rownumber,multiplier ,varnumber)=1; stvar(rownumber,interaction,varnumber)=t*holder+name.military;
		rownumber=16; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices2; stvar(rownumber,multiplier ,varnumber)=1; stvar(rownumber,interaction,varnumber)=t*holder+name.other;

		rownumber=17; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices3;
			if t==1; a=4;b=4;restricter; end;
		rownumber=18; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices3; stvar(rownumber,multiplier ,varnumber)=1; stvar(rownumber,interaction,varnumber)=t*holder+name.schoolOnly;
		rownumber=19; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices3; stvar(rownumber,multiplier ,varnumber)=1; stvar(rownumber,interaction,varnumber)=t*holder+name.workK12;
		rownumber=20; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices3; stvar(rownumber,multiplier ,varnumber)=1; stvar(rownumber,interaction,varnumber)=t*holder+name.workCollege;
		rownumber=21; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices3; stvar(rownumber,multiplier ,varnumber)=1; stvar(rownumber,interaction,varnumber)=t*holder+name.workPT;
		rownumber=22; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices3; stvar(rownumber,multiplier ,varnumber)=1; stvar(rownumber,interaction,varnumber)=t*holder+name.workFT;
		rownumber=23; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices3; stvar(rownumber,multiplier ,varnumber)=1; stvar(rownumber,interaction,varnumber)=t*holder+name.military;
		rownumber=24; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices3; stvar(rownumber,multiplier ,varnumber)=1; stvar(rownumber,interaction,varnumber)=t*holder+name.other;

		rownumber=25; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Wage1;
		rownumber=26; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Wage2;
		rownumber=27; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Wage3;
		if t==1
			rownumber=28; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.asvabAR;
			rownumber=29; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.asvabCS;
			rownumber=30; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.asvabMK;
			rownumber=31; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.asvabNO;
			rownumber=32; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.asvabPC;
			rownumber=33; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.asvabWK;
		end
		stvar(1,numrows,varnumber)=rownumber;

	varnumber=t*holder+name.born1959; eval(['varval' num2str(varnumber) ' = born1959(:,:,1);']); namevar{varnumber,1}='born1959'; stvar(1,discrete,varnumber)=1;
		rownumber=1; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices1;
		rownumber=2; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices2;
		rownumber=3; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices3;
		rownumber=4; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Wage1;
		rownumber=5; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Wage2;
		rownumber=6; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Wage3;
		if t==1
			rownumber= 7; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.asvabAR;
			rownumber= 8; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.asvabCS;
			rownumber= 9; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.asvabMK;
			rownumber=10; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.asvabNO;
			rownumber=11; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.asvabPC;
			rownumber=12; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.asvabWK;
		end
		stvar(1,numrows,varnumber)=rownumber;

	varnumber=t*holder+name.born1960; eval(['varval' num2str(varnumber) ' = born1960(:,:,1);']); namevar{varnumber,1}='born1960'; stvar(1,discrete,varnumber)=1;
		rownumber=1; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices1;
		rownumber=2; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices2;
		rownumber=3; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices3;
		rownumber=4; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Wage1;
		rownumber=5; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Wage2;
		rownumber=6; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Wage3;
		if t==1
			rownumber= 7; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.asvabAR;
			rownumber= 8; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.asvabCS;
			rownumber= 9; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.asvabMK;
			rownumber=10; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.asvabNO;
			rownumber=11; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.asvabPC;
			rownumber=12; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.asvabWK;
		end
		stvar(1,numrows,varnumber)=rownumber;

	varnumber=t*holder+name.born1961; eval(['varval' num2str(varnumber) ' = born1961(:,:,1);']); namevar{varnumber,1}='born1961'; stvar(1,discrete,varnumber)=1;
		rownumber=1; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices1;
		rownumber=2; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices2;
		rownumber=3; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices3;
		rownumber=4; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Wage1;
		rownumber=5; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Wage2;
		rownumber=6; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Wage3;
		if t==1
			rownumber= 7; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.asvabAR;
			rownumber= 8; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.asvabCS;
			rownumber= 9; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.asvabMK;
			rownumber=10; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.asvabNO;
			rownumber=11; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.asvabPC;
			rownumber=12; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.asvabWK;
		end
		stvar(1,numrows,varnumber)=rownumber;

	varnumber=t*holder+name.born1962; eval(['varval' num2str(varnumber) ' = born1962(:,:,1);']); namevar{varnumber,1}='born1962'; stvar(1,discrete,varnumber)=1;
		rownumber=1; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices1;
		rownumber=2; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices2;
		rownumber=3; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices3;
		rownumber=4; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Wage1;
		rownumber=5; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Wage2;
		rownumber=6; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Wage3;
		if t==1
			rownumber= 7; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.asvabAR;
			rownumber= 8; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.asvabCS;
			rownumber= 9; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.asvabMK;
			rownumber=10; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.asvabNO;
			rownumber=11; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.asvabPC;
			rownumber=12; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.asvabWK;
		end
		stvar(1,numrows,varnumber)=rownumber;

	varnumber=t*holder+name.born1963; eval(['varval' num2str(varnumber) ' = born1963(:,:,1);']); namevar{varnumber,1}='born1963'; stvar(1,discrete,varnumber)=1;
		rownumber=1; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices1;
		rownumber=2; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices2;
		rownumber=3; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices3;
		rownumber=4; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Wage1;
		rownumber=5; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Wage2;
		rownumber=6; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Wage3;
		if t==1
			rownumber= 7; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.asvabAR;
			rownumber= 8; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.asvabCS;
			rownumber= 9; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.asvabMK;
			rownumber=10; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.asvabNO;
			rownumber=11; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.asvabPC;
			rownumber=12; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.asvabWK;
		end
		stvar(1,numrows,varnumber)=rownumber;

	varnumber=t*holder+name.foreignBorn; eval(['varval' num2str(varnumber) ' = foreignBorn(:,:,1);']); namevar{varnumber,1}='foreignBorn'; stvar(1,discrete,varnumber)=1;
		rownumber=1; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices1;
			if t==1; a=4;b=4;restricter; end;
		rownumber=2; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices2;
		rownumber=3; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices3;
			if t==1; a=4;b=4;restricter; end;
		rownumber=4; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Wage1;
		rownumber=5; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Wage2;
		rownumber=6; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Wage3;
		if t==1
			rownumber= 7; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.asvabAR;
			rownumber= 8; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.asvabCS;
			rownumber= 9; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.asvabMK;
			rownumber=10; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.asvabNO;
			rownumber=11; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.asvabPC;
			rownumber=12; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.asvabWK;
		end
		stvar(1,numrows,varnumber)=rownumber;

	varnumber=t*holder+name.empPct; eval(['varval' num2str(varnumber) ' = empPct(:,:,t);']); namevar{varnumber,1}='empPct';
		rownumber=1; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices1;
			if t==1; a=4;b=4;restricter; end;
		rownumber=2; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices2;
		rownumber=3; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices3;
			if t==1; a=4;b=4;restricter; end;
		rownumber=4; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Wage1;
		rownumber=5; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Wage2;
		rownumber=6; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Wage3;
		stvar(1,numrows,varnumber)=rownumber;

	varnumber=t*holder+name.incPerCapita; eval(['varval' num2str(varnumber) ' = incPerCapita(:,:,t);']); namevar{varnumber,1}='incPerCapita';
		rownumber=1; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices1;
			if t==1; a=4;b=4;restricter; end;
		rownumber=2; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices2;
		rownumber=3; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices3;
			if t==1; a=4;b=4;restricter; end;
		rownumber=4; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Wage1;
		rownumber=5; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Wage2;
		rownumber=6; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Wage3;
		stvar(1,numrows,varnumber)=rownumber;

	varnumber=t*holder+name.hgcMoth; eval(['varval' num2str(varnumber) ' = hgcMoth       (:,:,1);']); namevar{varnumber,1}='hgcMoth';
		rownumber=1; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices1;
			if t==1; a=4;b=4;restricter; end;
		rownumber=2; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices2;
		rownumber=3; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices3;
			if t==1; a=4;b=4;restricter; end;
		stvar(1,numrows,varnumber)=rownumber;

	varnumber=t*holder+name.hgcMothSq; eval(['varval' num2str(varnumber) ' = hgcMothSq     (:,:,1);']); namevar{varnumber,1}='hgcMothSq'; stvar(1,discrete,varnumber)=1;
		rownumber=1; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices1;
			if t==1; a=4;b=4;restricter; end;
		rownumber=2; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices2;
		rownumber=3; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices3;
			if t==1; a=4;b=4;restricter; end;
		stvar(1,numrows,varnumber)=rownumber;

	varnumber=t*holder+name.m_hgcMoth; eval(['varval' num2str(varnumber) ' = m_hgcMoth     (:,:,1);']); namevar{varnumber,1}='m_hgcMoth'; stvar(1,discrete,varnumber)=1;
		rownumber=1; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices1;
			if t==1; a=4;b=4;restricter; end;
		rownumber=2; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices2;
		rownumber=3; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices3;
			if t==1; a=4;b=4;restricter; end;
		stvar(1,numrows,varnumber)=rownumber;

	varnumber=t*holder+name.hgcFath; eval(['varval' num2str(varnumber) ' = hgcFath       (:,:,1);']); namevar{varnumber,1}='hgcFath';
		rownumber=1; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices1;
			if t==1; a=4;b=4;restricter; end;
		rownumber=2; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices2;
		rownumber=3; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices3;
			if t==1; a=4;b=4;restricter; end;
		stvar(1,numrows,varnumber)=rownumber;

	varnumber=t*holder+name.hgcFathSq; eval(['varval' num2str(varnumber) ' = hgcFathSq     (:,:,1);']); namevar{varnumber,1}='hgcFathSq';
		rownumber=1; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices1;
			if t==1; a=4;b=4;restricter; end;
		rownumber=2; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices2;
		rownumber=3; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices3;
			if t==1; a=4;b=4;restricter; end;
		stvar(1,numrows,varnumber)=rownumber;

	varnumber=t*holder+name.m_hgcFath; eval(['varval' num2str(varnumber) ' = m_hgcFath     (:,:,1);']); namevar{varnumber,1}='m_hgcFath'; stvar(1,discrete,varnumber)=1;
		rownumber=1; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices1;
			if t==1; a=4;b=4;restricter; end;
		rownumber=2; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices2;
		rownumber=3; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices3;
			if t==1; a=4;b=4;restricter; end;
		stvar(1,numrows,varnumber)=rownumber;

	varnumber=t*holder+name.famInc; eval(['varval' num2str(varnumber) ' = famInc        (:,:,1);']); namevar{varnumber,1}='famInc';
		rownumber=1; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices1;
			if t==1; a=4;b=4;restricter; end;
		rownumber=2; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices2;
		rownumber=3; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices3;
			if t==1; a=4;b=4;restricter; end;
		stvar(1,numrows,varnumber)=rownumber;

	varnumber=t*holder+name.famIncSq; eval(['varval' num2str(varnumber) ' = famIncSq      (:,:,1);']); namevar{varnumber,1}='famIncSq';
		rownumber=1; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices1;
			if t==1; a=4;b=4;restricter; end;
		rownumber=2; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices2;
		rownumber=3; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices3;
			if t==1; a=4;b=4;restricter; end;
		stvar(1,numrows,varnumber)=rownumber;

	varnumber=t*holder+name.m_famInc; eval(['varval' num2str(varnumber) ' = m_famInc      (:,:,1);']); namevar{varnumber,1}='m_famInc'; stvar(1,discrete,varnumber)=1;
		rownumber=1; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices1;
			if t==1; a=4;b=4;restricter; end;
		rownumber=2; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices2;
		rownumber=3; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices3;
			if t==1; a=4;b=4;restricter; end;
		stvar(1,numrows,varnumber)=rownumber;

	varnumber=t*holder+name.femaleHeadHH14; eval(['varval' num2str(varnumber) ' = femaleHeadHH14(:,:,1);']); namevar{varnumber,1}='femaleHeadHH14'; stvar(1,discrete,varnumber)=1;
		rownumber=1; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices1;
			if t==1; a=4;b=4;restricter; end;
		rownumber=2; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices2;
		rownumber=3; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices3;
			if t==1; a=4;b=4;restricter; end;
		stvar(1,numrows,varnumber)=rownumber;

	varnumber=t*holder+name.liveWithMom14; eval(['varval' num2str(varnumber) ' = liveWithMom14 (:,:,1);']); namevar{varnumber,1}='liveWithMom14'; stvar(1,discrete,varnumber)=1;
		rownumber=1; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices1;
			if t==1; a=4;b=4;restricter; end;
		rownumber=2; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices2;
		rownumber=3; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices3;
			if t==1; a=4;b=4;restricter; end;
		stvar(1,numrows,varnumber)=rownumber;

	varnumber=t*holder+name.numBAzero; eval(['varval' num2str(varnumber) ' = numBAzero (:,:,1);']); namevar{varnumber,1}='numBAzero'; stvar(1,discrete,varnumber)=1;
		rownumber=1; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices1;
			if t==1; a=4;b=4;restricter; end;
		rownumber=2; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices2;
		rownumber=3; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices3;
			if t==1; a=4;b=4;restricter; end;
		stvar(1,numrows,varnumber)=rownumber;

	varnumber=t*holder+name.numBAperCapita; eval(['varval' num2str(varnumber) ' = numBAperCapita (:,:,1);']); namevar{varnumber,1}='numBAperCapita'; stvar(1,discrete,varnumber)=1;
		rownumber=1; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices1;
			if t==1; a=4;b=4;restricter; end;
		rownumber=2; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices2;
		rownumber=3; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices3;
			if t==1; a=4;b=4;restricter; end;
		stvar(1,numrows,varnumber)=rownumber;

	varnumber=t*holder+name.tuitionFlagship; eval(['varval' num2str(varnumber) ' = tuitionFlagship (:,:,1);']); namevar{varnumber,1}='tuitionFlagship'; stvar(1,discrete,varnumber)=1;
		rownumber=1; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices1;
			if t==1; a=4;b=4;restricter; end;
		rownumber=2; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices2;
		rownumber=3; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices3;
			if t==1; a=4;b=4;restricter; end;
		stvar(1,numrows,varnumber)=rownumber;

	varnumber=t*holder+name.constant; eval(['varval' num2str(varnumber) ' = constant      (:,:,1);']); namevar{varnumber,1}='constant'; stvar(1,discrete,varnumber)=1;
		rownumber= 1; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices1;
		rownumber= 2; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices2;
		rownumber= 3; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices3;
		rownumber= 4; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Wage1;
		rownumber= 5; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Wage2;
		rownumber= 6; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Wage3;
		if t==1
			rownumber= 7; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.asvabAR;
			rownumber= 8; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.asvabCS;
			rownumber= 9; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.asvabMK;
			rownumber=10; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.asvabNO;
			rownumber=11; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.asvabPC;
			rownumber=12; stvar(rownumber,present  ,varnumber)=1; stvar(rownumber,idmodel  ,varnumber)=t*holder+name.asvabWK;
		end
		stvar(1,numrows,varnumber)=rownumber;

	%============================================================================
	% State variables - Experience terms
	%  schoolOnly | anySchool (1) workK12 (2) workCollege (3) workPT (4) workFT (5) military (6) other (7)
	%============================================================================
	% Note, now schoolOnly appears in the choice equations and anySchool appears in the wage equations
	varnumber=t*holder+name.schoolOnly; eval(['varval' num2str(varnumber) ' = [schoolOnlyt(:,:,t) ];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('schoolOnly',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;
		% rownumber=2;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1;
			% if t==1; a=4;b=4;restricter; end;
		rownumber=3;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1; stvar(rownumber,multiplier,varnumber)=1   ; stvar(rownumber,interaction,varnumber)=t*holder+name.black;
			if t==1; a=4;b=4;restricter; end;
		rownumber=4;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1; stvar(rownumber,multiplier,varnumber)=1   ; stvar(rownumber,interaction,varnumber)=t*holder+name.hispanic;
			if t==1; a=4;b=4;restricter; end;
		% rownumber=5;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1; stvar(rownumber,multiplier,varnumber)=1/10; stvar(rownumber,interaction,varnumber)=t*holder+name.schoolOnly;
			% if t==1; a=4;b=4;restricter; end;

		% rownumber=6;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2;
			% if t==1; a=6;b=6;restricter; end;
		rownumber=7;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2; stvar(rownumber,multiplier,varnumber)=1   ; stvar(rownumber,interaction,varnumber)=t*holder+name.black;
			% if t==1; a=6;b=6;restricter; end;
		rownumber=8;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2; stvar(rownumber,multiplier,varnumber)=1   ; stvar(rownumber,interaction,varnumber)=t*holder+name.hispanic;
			% if t==1; a=6;b=6;restricter; end;
		% rownumber=9;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2; stvar(rownumber,multiplier,varnumber)=1/10; stvar(rownumber,interaction,varnumber)=t*holder+name.schoolOnly;
			% if t==1; a=6;b=6;restricter; end;

		% rownumber=10; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3;
			% if t==1; a=4;b=4;restricter; end;
		rownumber=11; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3; stvar(rownumber,multiplier,varnumber)=1   ; stvar(rownumber,interaction,varnumber)=t*holder+name.black;
			if t==1; a=4;b=4;restricter; end;
		rownumber=12; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3; stvar(rownumber,multiplier,varnumber)=1   ; stvar(rownumber,interaction,varnumber)=t*holder+name.hispanic;
			if t==1; a=4;b=4;restricter; end;
		% rownumber=13; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3; stvar(rownumber,multiplier,varnumber)=1/10; stvar(rownumber,interaction,varnumber)=t*holder+name.schoolOnly;
			% if t==1; a=4;b=4;restricter; end;
		if t<T
			rownumber=14;stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=(t+1)*holder+name.schoolOnly; %experience at the beginning of t+1
		end
		stvar(1,numrows,varnumber)=rownumber;

	varnumber=t*holder+name.anySchool; eval(['varval' num2str(varnumber) ' = [anySchoolt(:,:,t) ];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('anySchool',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;

		rownumber=2; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage1;
		rownumber=3; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage1;    stvar(rownumber,multiplier,varnumber)=1/10; stvar(rownumber,interaction,varnumber)=t*holder+name.anySchool;
		rownumber=4; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage1;    stvar(rownumber,multiplier,varnumber)=1/10; stvar(rownumber,interaction,varnumber)=t*holder+name.workK12;
		rownumber=5; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage1;    stvar(rownumber,multiplier,varnumber)=1/10; stvar(rownumber,interaction,varnumber)=t*holder+name.workCollege;
		rownumber=6; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage1;    stvar(rownumber,multiplier,varnumber)=1/10; stvar(rownumber,interaction,varnumber)=t*holder+name.workPT;
		rownumber=7; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage1;    stvar(rownumber,multiplier,varnumber)=1/10; stvar(rownumber,interaction,varnumber)=t*holder+name.workFT;

		rownumber=8; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage2;
		rownumber=9; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage2;    stvar(rownumber,multiplier,varnumber)=1/10; stvar(rownumber,interaction,varnumber)=t*holder+name.anySchool;
		rownumber=10; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage2;    stvar(rownumber,multiplier,varnumber)=1/10; stvar(rownumber,interaction,varnumber)=t*holder+name.workK12;
		rownumber=11; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage2;    stvar(rownumber,multiplier,varnumber)=1/10; stvar(rownumber,interaction,varnumber)=t*holder+name.workCollege;
		rownumber=12; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage2;    stvar(rownumber,multiplier,varnumber)=1/10; stvar(rownumber,interaction,varnumber)=t*holder+name.workPT;
		rownumber=13; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage2;    stvar(rownumber,multiplier,varnumber)=1/10; stvar(rownumber,interaction,varnumber)=t*holder+name.workFT;

		rownumber=14; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage3;
		rownumber=15; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage3;    stvar(rownumber,multiplier,varnumber)=1/10; stvar(rownumber,interaction,varnumber)=t*holder+name.anySchool;
		rownumber=16; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage3;    stvar(rownumber,multiplier,varnumber)=1/10; stvar(rownumber,interaction,varnumber)=t*holder+name.workK12;
		rownumber=17; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage3;    stvar(rownumber,multiplier,varnumber)=1/10; stvar(rownumber,interaction,varnumber)=t*holder+name.workCollege;
		rownumber=18; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage3;    stvar(rownumber,multiplier,varnumber)=1/10; stvar(rownumber,interaction,varnumber)=t*holder+name.workPT;
		rownumber=19; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage3;    stvar(rownumber,multiplier,varnumber)=1/10; stvar(rownumber,interaction,varnumber)=t*holder+name.workFT;
		if t<T
			rownumber=20;stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=(t+1)*holder+name.anySchool; %experience at the beginning of t+1
		end
		stvar(1,numrows,varnumber)=rownumber;

	varnumber=t*holder+name.anySchoolCu; eval(['varval' num2str(varnumber) ' = [(anySchoolt(:,:,t).^3)./100];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('anySchoolCu',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage1;
		rownumber=2; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage2;
		rownumber=3; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage3;
		stvar(1,numrows,varnumber)=rownumber;

	varnumber=t*holder+name.workK12; eval(['varval' num2str(varnumber) ' = [workK12t(:,:,t) ];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('workK12',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;
		% rownumber=2;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1;
			% if t==1; a=4;b=4;restricter; end;
		rownumber=3;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1; stvar(rownumber,multiplier,varnumber)=1   ; stvar(rownumber,interaction,varnumber)=t*holder+name.black;
			if t==1; a=4;b=4;restricter; end;
		rownumber=4;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1; stvar(rownumber,multiplier,varnumber)=1   ; stvar(rownumber,interaction,varnumber)=t*holder+name.hispanic;
			if t==1; a=4;b=4;restricter; end;
		% rownumber=5;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1; stvar(rownumber,multiplier,varnumber)=1/10; stvar(rownumber,interaction,varnumber)=t*holder+name.workK12;
			% if t==1; a=4;b=4;restricter; end;

		% rownumber=6;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2;
		rownumber=7;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2; stvar(rownumber,multiplier,varnumber)=1   ; stvar(rownumber,interaction,varnumber)=t*holder+name.black;
		rownumber=8;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2; stvar(rownumber,multiplier,varnumber)=1   ; stvar(rownumber,interaction,varnumber)=t*holder+name.hispanic;
		% rownumber=9;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2; stvar(rownumber,multiplier,varnumber)=1/10; stvar(rownumber,interaction,varnumber)=t*holder+name.workK12;

		% rownumber=10; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3;
			% if t==1; a=4;b=4;restricter; end;
		rownumber=11; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3; stvar(rownumber,multiplier,varnumber)=1   ; stvar(rownumber,interaction,varnumber)=t*holder+name.black;
			if t==1; a=4;b=4;restricter; end;
		rownumber=12; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3; stvar(rownumber,multiplier,varnumber)=1   ; stvar(rownumber,interaction,varnumber)=t*holder+name.hispanic;
			if t==1; a=4;b=4;restricter; end;
		% rownumber=13; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3; stvar(rownumber,multiplier,varnumber)=1/10; stvar(rownumber,interaction,varnumber)=t*holder+name.workK12;
			% if t==1; a=4;b=4;restricter; end;

		rownumber=14; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage1;
		rownumber=15; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage1;    stvar(rownumber,multiplier,varnumber)=1/10; stvar(rownumber,interaction,varnumber)=t*holder+name.workK12;
		rownumber=16; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage1;    stvar(rownumber,multiplier,varnumber)=1/10; stvar(rownumber,interaction,varnumber)=t*holder+name.anySchool;

		rownumber=17; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage2;
		rownumber=18; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage2;    stvar(rownumber,multiplier,varnumber)=1/10; stvar(rownumber,interaction,varnumber)=t*holder+name.workK12;
		rownumber=19; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage2;    stvar(rownumber,multiplier,varnumber)=1/10; stvar(rownumber,interaction,varnumber)=t*holder+name.anySchool;

		rownumber=20; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage3;
		rownumber=21; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage3;    stvar(rownumber,multiplier,varnumber)=1/10; stvar(rownumber,interaction,varnumber)=t*holder+name.workK12;
		rownumber=22; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage3;    stvar(rownumber,multiplier,varnumber)=1/10; stvar(rownumber,interaction,varnumber)=t*holder+name.anySchool;
		if t<T
			rownumber=23;stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=(t+1)*holder+name.workK12; %experience at the beginning of t+1
		end
		stvar(1,numrows,varnumber)=rownumber;

	varnumber=t*holder+name.workK12Cu; eval(['varval' num2str(varnumber) ' = [(workK12t(:,:,t).^3)./100];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('workK12Cu',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage1;
		rownumber=2; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage2;
		rownumber=3; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage3;
		stvar(1,numrows,varnumber)=rownumber;

	varnumber=t*holder+name.workCollege; eval(['varval' num2str(varnumber) ' = [workColleget(:,:,t) ];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('workCollege',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;
		% rownumber=2;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1;
			% if t==1; a=1;b=6;restricter; end;
		% rownumber=3;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1; stvar(rownumber,multiplier,varnumber)=1   ; stvar(rownumber,interaction,varnumber)=t*holder+name.black;
			% if t==1; a=1;b=6;restricter; end;
		% rownumber=4;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1; stvar(rownumber,multiplier,varnumber)=1   ; stvar(rownumber,interaction,varnumber)=t*holder+name.hispanic;
			% if t==1; a=1;b=6;restricter; end;
		% rownumber=5;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1; stvar(rownumber,multiplier,varnumber)=1/10; stvar(rownumber,interaction,varnumber)=t*holder+name.workCollege;
			% if t==1; a=1;b=6;restricter; end;

		% rownumber=6;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2;
		rownumber=7;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2; stvar(rownumber,multiplier,varnumber)=1   ; stvar(rownumber,interaction,varnumber)=t*holder+name.black;
		rownumber=8;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2; stvar(rownumber,multiplier,varnumber)=1   ; stvar(rownumber,interaction,varnumber)=t*holder+name.hispanic;
		% rownumber=9;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2; stvar(rownumber,multiplier,varnumber)=1/10; stvar(rownumber,interaction,varnumber)=t*holder+name.workCollege;

		% rownumber=10; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3;
			% if t==1; a=4;b=4;restricter; end;
		rownumber=11; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3; stvar(rownumber,multiplier,varnumber)=1   ; stvar(rownumber,interaction,varnumber)=t*holder+name.black;
			if t==1; a=4;b=4;restricter; end;
		rownumber=12; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3; stvar(rownumber,multiplier,varnumber)=1   ; stvar(rownumber,interaction,varnumber)=t*holder+name.hispanic;
			if t==1; a=4;b=4;restricter; end;
		% rownumber=13; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3; stvar(rownumber,multiplier,varnumber)=1/10; stvar(rownumber,interaction,varnumber)=t*holder+name.workCollege;
			% if t==1; a=4;b=4;restricter; end;

		rownumber=14; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage1;
		rownumber=15; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage1;    stvar(rownumber,multiplier,varnumber)=1/10; stvar(rownumber,interaction,varnumber)=t*holder+name.workCollege;
		rownumber=16; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage1;    stvar(rownumber,multiplier,varnumber)=1/10; stvar(rownumber,interaction,varnumber)=t*holder+name.anySchool;

		rownumber=17; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage2;
		rownumber=18; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage2;    stvar(rownumber,multiplier,varnumber)=1/10; stvar(rownumber,interaction,varnumber)=t*holder+name.workCollege;
		rownumber=19; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage2;    stvar(rownumber,multiplier,varnumber)=1/10; stvar(rownumber,interaction,varnumber)=t*holder+name.anySchool;

		rownumber=20; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage3;
		rownumber=21; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage3;    stvar(rownumber,multiplier,varnumber)=1/10; stvar(rownumber,interaction,varnumber)=t*holder+name.workCollege;
		rownumber=22; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage3;    stvar(rownumber,multiplier,varnumber)=1/10; stvar(rownumber,interaction,varnumber)=t*holder+name.anySchool;
		if t<T
			rownumber=23;stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=(t+1)*holder+name.workCollege; %experience at the beginning of t+1
		end
		stvar(1,numrows,varnumber)=rownumber;

	varnumber=t*holder+name.workCollegeCu; eval(['varval' num2str(varnumber) ' = [(workColleget(:,:,t).^3)./100];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('workCollegeCu',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage1;
		rownumber=2; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage2;
		rownumber=3; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage3;
		stvar(1,numrows,varnumber)=rownumber;

	varnumber=t*holder+name.workPT; eval(['varval' num2str(varnumber) ' = [workPTonlyt(:,:,t) ];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('workPT',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;
		% rownumber=2;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1;
			% if t==1; a=4;b=4;restricter; end;
		rownumber=3;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1; stvar(rownumber,multiplier,varnumber)=1   ; stvar(rownumber,interaction,varnumber)=t*holder+name.black;
			if t==1; a=4;b=4;restricter; end;
		rownumber=4;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1; stvar(rownumber,multiplier,varnumber)=1   ; stvar(rownumber,interaction,varnumber)=t*holder+name.hispanic;
			if t==1; a=4;b=4;restricter; end;
		% rownumber=5;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1; stvar(rownumber,multiplier,varnumber)=1/10; stvar(rownumber,interaction,varnumber)=t*holder+name.workPT;
			% if t==1; a=4;b=4;restricter; end;

		% rownumber=6;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2;
		rownumber=7;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2; stvar(rownumber,multiplier,varnumber)=1   ; stvar(rownumber,interaction,varnumber)=t*holder+name.black;
		rownumber=8;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2; stvar(rownumber,multiplier,varnumber)=1   ; stvar(rownumber,interaction,varnumber)=t*holder+name.hispanic;
		% rownumber=9;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2; stvar(rownumber,multiplier,varnumber)=1/10; stvar(rownumber,interaction,varnumber)=t*holder+name.workPT;

		% rownumber=10; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3;
			% if t==1; a=4;b=4;restricter; end;
		rownumber=11; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3; stvar(rownumber,multiplier,varnumber)=1   ; stvar(rownumber,interaction,varnumber)=t*holder+name.black;
			if t==1; a=4;b=4;restricter; end;
		rownumber=12; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3; stvar(rownumber,multiplier,varnumber)=1   ; stvar(rownumber,interaction,varnumber)=t*holder+name.hispanic;
			if t==1; a=4;b=4;restricter; end;
		% rownumber=13; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3; stvar(rownumber,multiplier,varnumber)=1/10; stvar(rownumber,interaction,varnumber)=t*holder+name.workPT;
			% if t==1; a=4;b=4;restricter; end;

		rownumber=14; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage1;
		rownumber=15; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage1;    stvar(rownumber,multiplier,varnumber)=1/10; stvar(rownumber,interaction,varnumber)=t*holder+name.workPT;
		rownumber=16; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage1;    stvar(rownumber,multiplier,varnumber)=1/10; stvar(rownumber,interaction,varnumber)=t*holder+name.anySchool;

		rownumber=17; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage2;
		rownumber=18; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage2;    stvar(rownumber,multiplier,varnumber)=1/10; stvar(rownumber,interaction,varnumber)=t*holder+name.workPT;
		rownumber=19; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage2;    stvar(rownumber,multiplier,varnumber)=1/10; stvar(rownumber,interaction,varnumber)=t*holder+name.anySchool;

		rownumber=20; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage3;
		rownumber=21; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage3;    stvar(rownumber,multiplier,varnumber)=1/10; stvar(rownumber,interaction,varnumber)=t*holder+name.workPT;
		rownumber=22; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage3;    stvar(rownumber,multiplier,varnumber)=1/10; stvar(rownumber,interaction,varnumber)=t*holder+name.anySchool;
		if t<T
			rownumber=23;stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=(t+1)*holder+name.workPT; %experience at the beginning of t+1
		end
		stvar(1,numrows,varnumber)=rownumber;

	varnumber=t*holder+name.workPTCu; eval(['varval' num2str(varnumber) ' = [(workPTonlyt(:,:,t).^3)./100];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('workPTCu',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage1;
		rownumber=2; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage2;
		rownumber=3; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage3;
		stvar(1,numrows,varnumber)=rownumber;

	varnumber=t*holder+name.workFT; eval(['varval' num2str(varnumber) ' = [workFTonlyt(:,:,t) ];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('workFT',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;
		% rownumber=2;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1;
			% if t==1; a=4;b=4;restricter; end;
		rownumber=3;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1; stvar(rownumber,multiplier,varnumber)=1   ; stvar(rownumber,interaction,varnumber)=t*holder+name.black;
			if t==1; a=4;b=4;restricter; end;
		rownumber=4;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1; stvar(rownumber,multiplier,varnumber)=1   ; stvar(rownumber,interaction,varnumber)=t*holder+name.hispanic;
			if t==1; a=4;b=4;restricter; end;
		% rownumber=5;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1; stvar(rownumber,multiplier,varnumber)=1/10; stvar(rownumber,interaction,varnumber)=t*holder+name.workFT;
			% if t==1; a=4;b=4;restricter; end;

		% rownumber=6;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2;
		rownumber=7;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2; stvar(rownumber,multiplier,varnumber)=1   ; stvar(rownumber,interaction,varnumber)=t*holder+name.black;
		rownumber=8;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2; stvar(rownumber,multiplier,varnumber)=1   ; stvar(rownumber,interaction,varnumber)=t*holder+name.hispanic;
		% rownumber=9;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2; stvar(rownumber,multiplier,varnumber)=1/10; stvar(rownumber,interaction,varnumber)=t*holder+name.workFT;

		% rownumber=10; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3;
			% if t==1; a=4;b=4;restricter; end;
		rownumber=11; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3; stvar(rownumber,multiplier,varnumber)=1   ; stvar(rownumber,interaction,varnumber)=t*holder+name.black;
			if t==1; a=4;b=4;restricter; end;
		rownumber=12; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3; stvar(rownumber,multiplier,varnumber)=1   ; stvar(rownumber,interaction,varnumber)=t*holder+name.hispanic;
			if t==1; a=4;b=4;restricter; end;
		% rownumber=13; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3; stvar(rownumber,multiplier,varnumber)=1/10; stvar(rownumber,interaction,varnumber)=t*holder+name.workFT;
			% if t==1; a=4;b=4;restricter; end;

		rownumber=14; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage1;
		rownumber=15; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage1;    stvar(rownumber,multiplier,varnumber)=1/10; stvar(rownumber,interaction,varnumber)=t*holder+name.workFT;
		rownumber=16; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage1;    stvar(rownumber,multiplier,varnumber)=1/10; stvar(rownumber,interaction,varnumber)=t*holder+name.anySchool;

		rownumber=17; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage2;
		rownumber=18; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage2;    stvar(rownumber,multiplier,varnumber)=1/10; stvar(rownumber,interaction,varnumber)=t*holder+name.workFT;
		rownumber=19; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage2;    stvar(rownumber,multiplier,varnumber)=1/10; stvar(rownumber,interaction,varnumber)=t*holder+name.anySchool;

		rownumber=20; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage3;
		rownumber=21; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage3;    stvar(rownumber,multiplier,varnumber)=1/10; stvar(rownumber,interaction,varnumber)=t*holder+name.workFT;
		rownumber=22; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage3;    stvar(rownumber,multiplier,varnumber)=1/10; stvar(rownumber,interaction,varnumber)=t*holder+name.anySchool;
		if t<T
			rownumber=23;stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=(t+1)*holder+name.workFT; %experience at the beginning of t+1
		end
		stvar(1,numrows,varnumber)=rownumber;

	varnumber=t*holder+name.workFTCu; eval(['varval' num2str(varnumber) ' = [(workFTonlyt(:,:,t).^3)./100];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('workFTCu',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage1;
		rownumber=2; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage2;
		rownumber=3; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage3;
		stvar(1,numrows,varnumber)=rownumber;

	varnumber=t*holder+name.military; eval(['varval' num2str(varnumber) ' = [militaryt(:,:,t) ];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('military',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;
		% rownumber=2;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1;
			% if t==1; a=1;b=6;restricter; end;
		% rownumber=3;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1; stvar(rownumber,multiplier,varnumber)=1   ; stvar(rownumber,interaction,varnumber)=t*holder+name.black;
			% if t==1; a=1;b=6;restricter; end;
		% rownumber=4;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1; stvar(rownumber,multiplier,varnumber)=1   ; stvar(rownumber,interaction,varnumber)=t*holder+name.hispanic;
			% if t==1; a=1;b=6;restricter; end;
		% rownumber=5;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1; stvar(rownumber,multiplier,varnumber)=1/10; stvar(rownumber,interaction,varnumber)=t*holder+name.military;
			% if t==1; a=1;b=6;restricter; end;

		% rownumber=6;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2;
		rownumber=7;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2; stvar(rownumber,multiplier,varnumber)=1   ; stvar(rownumber,interaction,varnumber)=t*holder+name.black;
			if t==1; a=6;b=6;restricter; end; % Exclude military/race interactions in Choice2, act 17 (no male hispanic college grads);
		rownumber=8;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2; stvar(rownumber,multiplier,varnumber)=1   ; stvar(rownumber,interaction,varnumber)=t*holder+name.hispanic;
			if t==1; a=6;b=6;restricter; end; % Exclude military/race interactions in Choice2, act 17 (no male hispanic college grads);
		% rownumber=9;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2; stvar(rownumber,multiplier,varnumber)=1/10; stvar(rownumber,interaction,varnumber)=t*holder+name.military;

		% rownumber=10; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3;
			% if t==1; a=4;b=4;restricter; end;
		rownumber=11; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3; stvar(rownumber,multiplier,varnumber)=1   ; stvar(rownumber,interaction,varnumber)=t*holder+name.black;
			if t==1; a=1;b=5;restricter; end; % Exclude military/race interactions in Choice3 (no male hispanic college grads);
		rownumber=12; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3; stvar(rownumber,multiplier,varnumber)=1   ; stvar(rownumber,interaction,varnumber)=t*holder+name.hispanic;
			if t==1; a=1;b=5;restricter; end; % Exclude military/race interactions in Choice3 (no male hispanic college grads);
		% rownumber=13; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3; stvar(rownumber,multiplier,varnumber)=1/10; stvar(rownumber,interaction,varnumber)=t*holder+name.military;
			% if t==1; a=4;b=4;restricter; end;

		rownumber=14; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage1;
		rownumber=15; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage1;    stvar(rownumber,multiplier,varnumber)=1/10; stvar(rownumber,interaction,varnumber)=t*holder+name.military;

		rownumber=16; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage2;
		rownumber=17; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage2;    stvar(rownumber,multiplier,varnumber)=1/10; stvar(rownumber,interaction,varnumber)=t*holder+name.military;

		rownumber=18; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage3;
		rownumber=19; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage3;    stvar(rownumber,multiplier,varnumber)=1/10; stvar(rownumber,interaction,varnumber)=t*holder+name.military;
		if t<T
			rownumber=20;stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=(t+1)*holder+name.military; %experience at the beginning of t+1
		end
		stvar(1,numrows,varnumber)=rownumber;

	varnumber=t*holder+name.militaryCu; eval(['varval' num2str(varnumber) ' = [(militaryt(:,:,t).^3)./100];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('militaryCu',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage1;
		rownumber=2; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage2;
		rownumber=3; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage3;
		stvar(1,numrows,varnumber)=rownumber;

	varnumber=t*holder+name.other; eval(['varval' num2str(varnumber) ' = [othert(:,:,t) ];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('other',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;
		% rownumber=2;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1;
			% if t==1; a=4;b=4;restricter; end;
		rownumber=3;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1; stvar(rownumber,multiplier,varnumber)=1   ; stvar(rownumber,interaction,varnumber)=t*holder+name.black;
			if t==1; a=4;b=4;restricter; end;
		rownumber=4;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1; stvar(rownumber,multiplier,varnumber)=1   ; stvar(rownumber,interaction,varnumber)=t*holder+name.hispanic;
			if t==1; a=4;b=4;restricter; end;
		% rownumber=5;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1; stvar(rownumber,multiplier,varnumber)=1/10; stvar(rownumber,interaction,varnumber)=t*holder+name.other;
			% if t==1; a=4;b=4;restricter; end;

		% rownumber=6;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2;
		rownumber=7;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2; stvar(rownumber,multiplier,varnumber)=1   ; stvar(rownumber,interaction,varnumber)=t*holder+name.black;
		rownumber=8;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2; stvar(rownumber,multiplier,varnumber)=1   ; stvar(rownumber,interaction,varnumber)=t*holder+name.hispanic;
		% rownumber=9;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2; stvar(rownumber,multiplier,varnumber)=1/10; stvar(rownumber,interaction,varnumber)=t*holder+name.other;

		% rownumber=10; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3;
			% if t==1; a=4;b=4;restricter; end;
		rownumber=11; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3; stvar(rownumber,multiplier,varnumber)=1   ; stvar(rownumber,interaction,varnumber)=t*holder+name.black;
			if t==1; a=4;b=4;restricter; end;
		rownumber=12; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3; stvar(rownumber,multiplier,varnumber)=1   ; stvar(rownumber,interaction,varnumber)=t*holder+name.hispanic;
			if t==1; a=4;b=4;restricter; end;
		% rownumber=13; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3; stvar(rownumber,multiplier,varnumber)=1/10; stvar(rownumber,interaction,varnumber)=t*holder+name.other;
			% if t==1; a=4;b=4;restricter; end;

		rownumber=14; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage1;
		rownumber=15; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage1;    stvar(rownumber,multiplier,varnumber)=1/10; stvar(rownumber,interaction,varnumber)=t*holder+name.other;

		rownumber=16; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage2;
		rownumber=17; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage2;    stvar(rownumber,multiplier,varnumber)=1/10; stvar(rownumber,interaction,varnumber)=t*holder+name.other;

		rownumber=18; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage3;
		rownumber=19; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage3;    stvar(rownumber,multiplier,varnumber)=1/10; stvar(rownumber,interaction,varnumber)=t*holder+name.other;
		if t<T
			rownumber=20;stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=(t+1)*holder+name.other; %experience at the beginning of t+1
		end
		stvar(1,numrows,varnumber)=rownumber;

	varnumber=t*holder+name.otherCu; eval(['varval' num2str(varnumber) ' = [(othert(:,:,t).^3)./100];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('otherCu',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage1;
		rownumber=2; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage2;
		rownumber=3; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage3;
		stvar(1,numrows,varnumber)=rownumber;

	%------------------
	% schoolOnlyBin
	%------------------
	varnumber=t*holder+name.schoolOnlyBin1; eval(['varval' num2str(varnumber) ' = [schoolOnlyt(:,:,t)>=0 & schoolOnlyt(:,:,t)<0.5];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('schoolOnlyBin1',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;
		rownumber=2;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1;
			if t==1; a=4;b=4;restricter; end;
		rownumber=3;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2;
		rownumber=4;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3;
			if t==1; a=4;b=4;restricter; end;
		stvar(1,numrows,varnumber)=rownumber;
	varnumber=t*holder+name.schoolOnlyBin2; eval(['varval' num2str(varnumber) ' = [schoolOnlyt(:,:,t)>=0.5 & schoolOnlyt(:,:,t)<1];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('schoolOnlyBin2',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;
		rownumber=2;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1;
			if t==1; a=4;b=4;restricter; end;
		rownumber=3;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2;
		rownumber=4;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3;
			if t==1; a=4;b=4;restricter; end;
		stvar(1,numrows,varnumber)=rownumber;
	varnumber=t*holder+name.schoolOnlyBin3; eval(['varval' num2str(varnumber) ' = [schoolOnlyt(:,:,t)>=1 & schoolOnlyt(:,:,t)<1.5];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('schoolOnlyBin3',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;
		rownumber=2;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1;
			if t==1; a=4;b=4;restricter; end;
		rownumber=3;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2;
		rownumber=4;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3;
			if t==1; a=4;b=4;restricter; end;
		stvar(1,numrows,varnumber)=rownumber;
	varnumber=t*holder+name.schoolOnlyBin4; eval(['varval' num2str(varnumber) ' = [schoolOnlyt(:,:,t)>=1.5 & schoolOnlyt(:,:,t)<2];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('schoolOnlyBin4',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;
		rownumber=2;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1;
			if t==1; a=1;b=6;restricter; end;
		rownumber=3;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2;
			if t==1; a=1;b=6;restricter; end;
		rownumber=4;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3;
			if t==1; a=1;b=5;restricter; end;
		stvar(1,numrows,varnumber)=rownumber;
	varnumber=t*holder+name.schoolOnlyBin5; eval(['varval' num2str(varnumber) ' = [schoolOnlyt(:,:,t)>=2 & schoolOnlyt(:,:,t)<3];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('schoolOnlyBin5',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;
		rownumber=2;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1;
			if t==1; a=4;b=4;restricter; end;
		rownumber=3;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2;
		rownumber=4;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3;
			if t==1; a=4;b=4;restricter; end;
		stvar(1,numrows,varnumber)=rownumber;
	varnumber=t*holder+name.schoolOnlyBin6; eval(['varval' num2str(varnumber) ' = [schoolOnlyt(:,:,t)>=3 & schoolOnlyt(:,:,t)<4];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('schoolOnlyBin6',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;
		rownumber=2;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1;
			if t==1; a=4;b=4;restricter; end;
		rownumber=3;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2;
		rownumber=4;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3;
			if t==1; a=4;b=4;restricter; end;
		stvar(1,numrows,varnumber)=rownumber;
	varnumber=t*holder+name.schoolOnlyBin7; eval(['varval' num2str(varnumber) ' = [schoolOnlyt(:,:,t)>=4 & schoolOnlyt(:,:,t)<5];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('schoolOnlyBin7',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;
		rownumber=2;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1;
			if t==1; a=4;b=4;restricter; end;
		rownumber=3;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2;
		rownumber=4;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3;
			if t==1; a=4;b=4;restricter; end;
		stvar(1,numrows,varnumber)=rownumber;
	varnumber=t*holder+name.schoolOnlyBin8; eval(['varval' num2str(varnumber) ' = [schoolOnlyt(:,:,t)>=5 & schoolOnlyt(:,:,t)<6];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('schoolOnlyBin8',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;
		% rownumber=2;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1;
		rownumber=3;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2;
		rownumber=4;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3;
			if t==1; a=4;b=4;restricter; end;
		stvar(1,numrows,varnumber)=rownumber;
	varnumber=t*holder+name.schoolOnlyBin9; eval(['varval' num2str(varnumber) ' = [schoolOnlyt(:,:,t)>=6                       ];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('schoolOnlyBin9',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;
		% rownumber=2;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1;
		rownumber=3;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2;
			if t==1;
				stvar(rownumber,numberrest,varnumber)=1;jj=0;
				a=4;b=4;d=rownumber;c=t*holder+name.schoolOnlyBin8;restricterType1;
			end;
		rownumber=4;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3;
			if t==1; a=4;b=4;restricter; end;
		stvar(1,numrows,varnumber)=rownumber;

	%------------------
	% workK12Bin
	%------------------
	varnumber=t*holder+name.workK12Bin1; eval(['varval' num2str(varnumber) ' = [workK12t(:,:,t)>=0 & workK12t(:,:,t)<0.2];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('workK12Bin1',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;
		rownumber=2;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1;
			if t==1; a=4;b=4;restricter; end;
		rownumber=3;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2;
		rownumber=4;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3;
			if t==1; a=4;b=4;restricter; end;
		stvar(1,numrows,varnumber)=rownumber;
	varnumber=t*holder+name.workK12Bin2; eval(['varval' num2str(varnumber) ' = [workK12t(:,:,t)>=0.2 & workK12t(:,:,t)<0.4];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('workK12Bin2',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;
		rownumber=2;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1;
			if t==1; a=4;b=4;restricter; end;
		rownumber=3;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2;
		rownumber=4;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3;
			if t==1; a=4;b=4;restricter; end;
		stvar(1,numrows,varnumber)=rownumber;
	varnumber=t*holder+name.workK12Bin3; eval(['varval' num2str(varnumber) ' = [workK12t(:,:,t)>=0.4 & workK12t(:,:,t)<0.6];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('workK12Bin3',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;
		rownumber=2;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1;
			if t==1; a=1;b=6;restricter; end;
		rownumber=3;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2;
			if t==1; a=1;b=6;restricter; end;
		rownumber=4;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3;
			if t==1; a=1;b=5;restricter; end;
		stvar(1,numrows,varnumber)=rownumber;
	varnumber=t*holder+name.workK12Bin4; eval(['varval' num2str(varnumber) ' = [workK12t(:,:,t)>=0.6 & workK12t(:,:,t)<0.8];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('workK12Bin4',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;
		rownumber=2;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1;
			if t==1; a=4;b=4;restricter; end;
		rownumber=3;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2;
		rownumber=4;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3;
			if t==1; a=4;b=4;restricter; end;
		stvar(1,numrows,varnumber)=rownumber;
	varnumber=t*holder+name.workK12Bin5; eval(['varval' num2str(varnumber) ' = [workK12t(:,:,t)>=0.8 & workK12t(:,:,t)<1.0];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('workK12Bin5',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;
		rownumber=2;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1;
			if t==1; a=4;b=4;restricter; end;
		rownumber=3;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2;
		rownumber=4;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3;
			if t==1; a=4;b=4;restricter; end;
		stvar(1,numrows,varnumber)=rownumber;
	varnumber=t*holder+name.workK12Bin6; eval(['varval' num2str(varnumber) ' = [workK12t(:,:,t)>=1.0 & workK12t(:,:,t)<1.2];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('workK12Bin6',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;
		rownumber=2;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1;
			if t==1; a=4;b=4;restricter; end;
		rownumber=3;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2;
		rownumber=4;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3;
			if t==1; a=4;b=4;restricter; end;
		stvar(1,numrows,varnumber)=rownumber;
	varnumber=t*holder+name.workK12Bin7; eval(['varval' num2str(varnumber) ' = [workK12t(:,:,t)>=1.2 & workK12t(:,:,t)<1.4];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('workK12Bin7',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;
		rownumber=2;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1;
			if t==1; a=4;b=4;restricter; end;
		rownumber=3;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2;
		rownumber=4;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3;
			if t==1; a=4;b=4;restricter; end;
		stvar(1,numrows,varnumber)=rownumber;
	varnumber=t*holder+name.workK12Bin8; eval(['varval' num2str(varnumber) ' = [workK12t(:,:,t)>=1.4 & workK12t(:,:,t)<1.6];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('workK12Bin8',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;
		rownumber=2;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1;
			if t==1; a=4;b=4;restricter; end;
		rownumber=3;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2;
		rownumber=4;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3;
			if t==1; a=4;b=4;restricter; end;
		stvar(1,numrows,varnumber)=rownumber;
	varnumber=t*holder+name.workK12Bin9; eval(['varval' num2str(varnumber) ' = [workK12t(:,:,t)>=1.6                      ];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('workK12Bin9',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;
		rownumber=2;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1;
			if t==1; a=4;b=4;restricter; end;
		rownumber=3;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2;
		rownumber=4;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3;
			if t==1; a=4;b=4;restricter; end;
		stvar(1,numrows,varnumber)=rownumber;

	%------------------
	% workCollegeBin
	%------------------
	varnumber=t*holder+name.workCollegeBin1; eval(['varval' num2str(varnumber) ' = [workColleget(:,:,t)>=0 & workColleget(:,:,t)<0.5];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('workCollegeBin1',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;
		% rownumber=2;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1;
		rownumber=3;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2;
		rownumber=4;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3;
			if t==1; a=4;b=4;restricter; end;
		stvar(1,numrows,varnumber)=rownumber;
	varnumber=t*holder+name.workCollegeBin2; eval(['varval' num2str(varnumber) ' = [workColleget(:,:,t)>=0.5 & workColleget(:,:,t)<1];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('workCollegeBin2',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;
		% rownumber=2;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1;
		rownumber=3;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2;
		rownumber=4;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3;
			if t==1; a=4;b=4;restricter; end;
		stvar(1,numrows,varnumber)=rownumber;
	varnumber=t*holder+name.workCollegeBin3; eval(['varval' num2str(varnumber) ' = [workColleget(:,:,t)>=1 & workColleget(:,:,t)<1.5];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('workCollegeBin3',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;
		% rownumber=2;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1;
		rownumber=3;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2;
			if t==1; a=1;b=6;restricter; end;
		rownumber=4;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3;
			if t==1; a=1;b=5;restricter; end;
		stvar(1,numrows,varnumber)=rownumber;
	varnumber=t*holder+name.workCollegeBin4; eval(['varval' num2str(varnumber) ' = [workColleget(:,:,t)>=1.5 & workColleget(:,:,t)<2];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('workCollegeBin4',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;
		% rownumber=2;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1;
		rownumber=3;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2;
		rownumber=4;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3;
			if t==1; a=4;b=4;restricter; end;
		stvar(1,numrows,varnumber)=rownumber;
	varnumber=t*holder+name.workCollegeBin5; eval(['varval' num2str(varnumber) ' = [workColleget(:,:,t)>=2 & workColleget(:,:,t)<2.5];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('workCollegeBin5',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;
		% rownumber=2;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1;
		rownumber=3;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2;
		rownumber=4;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3;
			if t==1; a=4;b=4;restricter; end;
		stvar(1,numrows,varnumber)=rownumber;
	varnumber=t*holder+name.workCollegeBin6; eval(['varval' num2str(varnumber) ' = [workColleget(:,:,t)>=2.5 & workColleget(:,:,t)<3];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('workCollegeBin6',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;
		% rownumber=2;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1;
		rownumber=3;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2;
		rownumber=4;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3;
			if t==1; a=4;b=4;restricter; end;
		stvar(1,numrows,varnumber)=rownumber;
	varnumber=t*holder+name.workCollegeBin7; eval(['varval' num2str(varnumber) ' = [workColleget(:,:,t)>=3 & workColleget(:,:,t)<4];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('workCollegeBin7',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;
		% rownumber=2;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1;
		rownumber=3;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2;
		rownumber=4;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3;
			if t==1; a=4;b=4;restricter; end;
		stvar(1,numrows,varnumber)=rownumber;
	varnumber=t*holder+name.workCollegeBin8; eval(['varval' num2str(varnumber) ' = [workColleget(:,:,t)>=4 & workColleget(:,:,t)<5];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('workCollegeBin8',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;
		% rownumber=2;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1;
		rownumber=3;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2;
			if t==1;
				stvar(rownumber,numberrest,varnumber)=1;jj=0;
				a=4;b=4;d=rownumber;c=t*holder+name.workCollegeBin7;restricterType1;
			end;
		rownumber=4;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3;
			if t==1; a=4;b=4;restricter; end;
		stvar(1,numrows,varnumber)=rownumber;
	varnumber=t*holder+name.workCollegeBin9; eval(['varval' num2str(varnumber) ' = [workColleget(:,:,t)>=5                       ];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('workCollegeBin9',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;
		% rownumber=2;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1;
		rownumber=3;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2;
			if t==1;
				stvar(rownumber,numberrest,varnumber)=2;jj=0;
				a=4;b=4;d=rownumber;c=t*holder+name.workCollegeBin7;restricterType1;
				a=6;b=6;d=rownumber;c=t*holder+name.workCollegeBin8;restricterType1;
			end;
		rownumber=4;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3;
			if t==1; a=4;b=4;restricter; end;
		stvar(1,numrows,varnumber)=rownumber;

	%------------------
	% workPTonlyBin
	%------------------
	varnumber=t*holder+name.workPTonlyBin1; eval(['varval' num2str(varnumber) ' = [workPTonlyt(:,:,t)>=(0/3) & workPTonlyt(:,:,t)<(1/3)];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('workPTonlyBin1',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;
		rownumber=2;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1;
			if t==1; a=4;b=4;restricter; end;
		rownumber=3;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2;
		rownumber=4;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3;
			if t==1; a=4;b=4;restricter; end;
		stvar(1,numrows,varnumber)=rownumber;
	varnumber=t*holder+name.workPTonlyBin2; eval(['varval' num2str(varnumber) ' = [workPTonlyt(:,:,t)>=(1/3) & workPTonlyt(:,:,t)<(2/3)];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('workPTonlyBin2',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;
		rownumber=2;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1;
			if t==1; a=4;b=4;restricter; end;
		rownumber=3;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2;
		rownumber=4;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3;
			if t==1; a=4;b=4;restricter; end;
		stvar(1,numrows,varnumber)=rownumber;
	varnumber=t*holder+name.workPTonlyBin3; eval(['varval' num2str(varnumber) ' = [workPTonlyt(:,:,t)>=(2/3) & workPTonlyt(:,:,t)<(3/3)];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('workPTonlyBin3',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;
		rownumber=2;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1;
			if t==1; a=4;b=4;restricter; end;
		rownumber=3;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2;
		rownumber=4;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3;
			if t==1; a=4;b=4;restricter; end;
		stvar(1,numrows,varnumber)=rownumber;
	varnumber=t*holder+name.workPTonlyBin4; eval(['varval' num2str(varnumber) ' = [workPTonlyt(:,:,t)>=(3/3) & workPTonlyt(:,:,t)<(4/3)];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('workPTonlyBin4',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;
		rownumber=2;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1;
			if t==1; a=1;b=6;restricter; end;
		rownumber=3;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2;
			if t==1; a=1;b=6;restricter; end;
		rownumber=4;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3;
			if t==1; a=1;b=5;restricter; end;
		stvar(1,numrows,varnumber)=rownumber;
	varnumber=t*holder+name.workPTonlyBin5; eval(['varval' num2str(varnumber) ' = [workPTonlyt(:,:,t)>=(4/3) & workPTonlyt(:,:,t)<(5/3)];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('workPTonlyBin5',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;
		rownumber=2;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1;
			if t==1; a=4;b=4;restricter; end;
		rownumber=3;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2;
		rownumber=4;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3;
			if t==1; a=4;b=4;restricter; end;
		stvar(1,numrows,varnumber)=rownumber;
	varnumber=t*holder+name.workPTonlyBin6; eval(['varval' num2str(varnumber) ' = [workPTonlyt(:,:,t)>=(5/3) & workPTonlyt(:,:,t)<(6/3)];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('workPTonlyBin6',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;
		rownumber=2;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1;
			if t==1; a=4;b=4;restricter; end;
		rownumber=3;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2;
		rownumber=4;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3;
			if t==1; a=4;b=4;restricter; end;
		stvar(1,numrows,varnumber)=rownumber;
	varnumber=t*holder+name.workPTonlyBin7; eval(['varval' num2str(varnumber) ' = [workPTonlyt(:,:,t)>=(6/3) & workPTonlyt(:,:,t)<(7/3)];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('workPTonlyBin7',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;
		rownumber=2;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1;
			if t==1; a=4;b=4;restricter; end;
		rownumber=3;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2;
		rownumber=4;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3;
			if t==1;
				stvar(rownumber,numberrest,varnumber)=5;jj=0;
				a=4;b=4;restricterType0;
				a=1;b=1;d=rownumber;c=t*holder+name.workPTonlyBin6;restricterType1;
				a=2;b=2;d=rownumber;c=t*holder+name.workPTonlyBin6;restricterType1;
				a=3;b=3;d=rownumber;c=t*holder+name.workPTonlyBin6;restricterType1;
				a=5;b=5;d=rownumber;c=t*holder+name.workPTonlyBin6;restricterType1;
			end;
		stvar(1,numrows,varnumber)=rownumber;
	varnumber=t*holder+name.workPTonlyBin8; eval(['varval' num2str(varnumber) ' = [workPTonlyt(:,:,t)>=(7/3) & workPTonlyt(:,:,t)<(8/3)];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('workPTonlyBin8',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;
		rownumber=2;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1;
			if t==1; a=4;b=4;restricter; end;
		rownumber=3;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2;
			if t==1;
				stvar(rownumber,numberrest,varnumber)=1;jj=0;
				a=6;b=6;d=rownumber;c=t*holder+name.workPTonlyBin7;restricterType1;
			end;
		rownumber=4;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3;
			if t==1;
				stvar(rownumber,numberrest,varnumber)=5;jj=0;
				a=4;b=4;restricterType0;
				a=1;b=1;d=rownumber;c=t*holder+name.workPTonlyBin6;restricterType1;
				a=2;b=2;d=rownumber;c=t*holder+name.workPTonlyBin6;restricterType1;
				a=3;b=3;d=rownumber;c=t*holder+name.workPTonlyBin6;restricterType1;
				a=5;b=5;d=rownumber;c=t*holder+name.workPTonlyBin6;restricterType1;
			end;
		stvar(1,numrows,varnumber)=rownumber;
	varnumber=t*holder+name.workPTonlyBin9; eval(['varval' num2str(varnumber) ' = [workPTonlyt(:,:,t)>=(8/3)                       ];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('workPTonlyBin9',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;
		rownumber=2;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1;
			if t==1;
				stvar(rownumber,numberrest,varnumber)=2;jj=0;
				a=4;b=4;restricterType0;
				a=6;b=6;d=rownumber;c=t*holder+name.workPTonlyBin8;restricterType1;
			end;
		rownumber=3;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2;
			if t==1;
				stvar(rownumber,numberrest,varnumber)=1;jj=0;
				a=6;b=6;d=rownumber;c=t*holder+name.workPTonlyBin7;restricterType1;
			end;
		rownumber=4;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3;
			if t==1;
				stvar(rownumber,numberrest,varnumber)=5;jj=0;
				a=4;b=4;restricterType0;
				a=1;b=1;d=rownumber;c=t*holder+name.workPTonlyBin6;restricterType1;
				a=2;b=2;d=rownumber;c=t*holder+name.workPTonlyBin6;restricterType1;
				a=3;b=3;d=rownumber;c=t*holder+name.workPTonlyBin6;restricterType1;
				a=5;b=5;d=rownumber;c=t*holder+name.workPTonlyBin6;restricterType1;
			end;
		stvar(1,numrows,varnumber)=rownumber;

	%------------------
	% workFTonlyBin
	%------------------
	varnumber=t*holder+name.workFTonlyBin1; eval(['varval' num2str(varnumber) ' = [workFTonlyt(:,:,t)>=0 & workFTonlyt(:,:,t)<1];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('workFTonlyBin1',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;
		rownumber=2;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1;
			if t==1; a=4;b=4;restricter; end;
		rownumber=3;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2;
		rownumber=4;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3;
			if t==1; a=4;b=4;restricter; end;
		stvar(1,numrows,varnumber)=rownumber;
	varnumber=t*holder+name.workFTonlyBin2; eval(['varval' num2str(varnumber) ' = [workFTonlyt(:,:,t)>=1 & workFTonlyt(:,:,t)<2];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('workFTonlyBin2',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;
		rownumber=2;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1;
			if t==1; a=4;b=4;restricter; end;
		rownumber=3;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2;
		rownumber=4;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3;
			if t==1; a=4;b=4;restricter; end;
		stvar(1,numrows,varnumber)=rownumber;
	varnumber=t*holder+name.workFTonlyBin3; eval(['varval' num2str(varnumber) ' = [workFTonlyt(:,:,t)>=2 & workFTonlyt(:,:,t)<3];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('workFTonlyBin3',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;
		rownumber=2;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1;
			if t==1; a=1;b=6;restricter; end;
		rownumber=3;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2;
			if t==1; a=1;b=6;restricter; end;
		rownumber=4;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3;
			if t==1; a=1;b=5;restricter; end;
		stvar(1,numrows,varnumber)=rownumber;
	varnumber=t*holder+name.workFTonlyBin4; eval(['varval' num2str(varnumber) ' = [workFTonlyt(:,:,t)>=3 & workFTonlyt(:,:,t)<4];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('workFTonlyBin4',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;
		rownumber=2;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1;
			if t==1; a=4;b=4;restricter; end;
		rownumber=3;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2;
		rownumber=4;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3;
			if t==1; a=4;b=4;restricter; end;
		stvar(1,numrows,varnumber)=rownumber;
	varnumber=t*holder+name.workFTonlyBin5; eval(['varval' num2str(varnumber) ' = [workFTonlyt(:,:,t)>=4 & workFTonlyt(:,:,t)<5];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('workFTonlyBin5',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;
		rownumber=2;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1;
			if t==1; a=4;b=4;restricter; end;
		rownumber=3;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2;
		rownumber=4;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3;
			if t==1; a=4;b=4;restricter; end;
		stvar(1,numrows,varnumber)=rownumber;
	varnumber=t*holder+name.workFTonlyBin6; eval(['varval' num2str(varnumber) ' = [workFTonlyt(:,:,t)>=5 & workFTonlyt(:,:,t)<6];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('workFTonlyBin6',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;
		rownumber=2;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1;
			if t==1; a=4;b=4;restricter; end;
		rownumber=3;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2;
			if t==1;
				stvar(rownumber,numberrest,varnumber)=2;jj=0;
				a=4;b=4;d=rownumber;c=t*holder+name.workFTonlyBin5;restricterType1;
				a=6;b=6;d=rownumber;c=t*holder+name.workFTonlyBin5;restricterType1;
			end;
		rownumber=4;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3;
			if t==1; a=4;b=4;restricter; end;
		stvar(1,numrows,varnumber)=rownumber;
	varnumber=t*holder+name.workFTonlyBin7; eval(['varval' num2str(varnumber) ' = [workFTonlyt(:,:,t)>=6 & workFTonlyt(:,:,t)<7];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('workFTonlyBin7',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;
		rownumber=2;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1;
			if t==1; a=4;b=4;restricter; end;
		rownumber=3;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2;
			if t==1;
				stvar(rownumber,numberrest,varnumber)=1;jj=0;
				a=6;b=6;d=rownumber;c=t*holder+name.workFTonlyBin5;restricterType1;
			end;
		rownumber=4;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3;
			if t==1;
				stvar(rownumber,numberrest,varnumber)=5;jj=0;
				a=4;b=4;restricterType0;
				a=1;b=1;d=rownumber;c=t*holder+name.workFTonlyBin6;restricterType1;
				a=2;b=2;d=rownumber;c=t*holder+name.workFTonlyBin6;restricterType1;
				a=3;b=3;d=rownumber;c=t*holder+name.workFTonlyBin6;restricterType1;
				a=5;b=5;d=rownumber;c=t*holder+name.workFTonlyBin6;restricterType1;
			end;
		stvar(1,numrows,varnumber)=rownumber;
	varnumber=t*holder+name.workFTonlyBin8; eval(['varval' num2str(varnumber) ' = [workFTonlyt(:,:,t)>=7 & workFTonlyt(:,:,t)<8];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('workFTonlyBin8',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;
		rownumber=2;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1;
			if t==1;
				stvar(rownumber,numberrest,varnumber)=6;jj=0;
				a=4;b=4;restricterType0;
				a=1;b=1;d=rownumber;c=t*holder+name.workFTonlyBin7;restricterType1;
				a=2;b=2;d=rownumber;c=t*holder+name.workFTonlyBin7;restricterType1;
				a=3;b=3;d=rownumber;c=t*holder+name.workFTonlyBin7;restricterType1;
				a=5;b=5;d=rownumber;c=t*holder+name.workFTonlyBin7;restricterType1;
				a=6;b=6;d=rownumber;c=t*holder+name.workFTonlyBin7;restricterType1;
			end;
		rownumber=3;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2;
			if t==1;
				stvar(rownumber,numberrest,varnumber)=1;jj=0;
				a=6;b=6;d=rownumber;c=t*holder+name.workFTonlyBin5;restricterType1;
			end;
		rownumber=4;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3;
			if t==1;
				stvar(rownumber,numberrest,varnumber)=5;jj=0;
				a=4;b=4;restricterType0;
				a=1;b=1;d=rownumber;c=t*holder+name.workFTonlyBin6;restricterType1;
				a=2;b=2;d=rownumber;c=t*holder+name.workFTonlyBin6;restricterType1;
				a=3;b=3;d=rownumber;c=t*holder+name.workFTonlyBin6;restricterType1;
				a=5;b=5;d=rownumber;c=t*holder+name.workFTonlyBin6;restricterType1;
			end;
		stvar(1,numrows,varnumber)=rownumber;
	varnumber=t*holder+name.workFTonlyBin9; eval(['varval' num2str(varnumber) ' = [workFTonlyt(:,:,t)>=8                       ];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('workFTonlyBin9',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;
		rownumber=2;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1;
			if t==1;
				stvar(rownumber,numberrest,varnumber)=6;jj=0;
				a=4;b=4;restricterType0;
				a=1;b=1;d=rownumber;c=t*holder+name.workFTonlyBin7;restricterType1;
				a=2;b=2;d=rownumber;c=t*holder+name.workFTonlyBin7;restricterType1;
				a=3;b=3;d=rownumber;c=t*holder+name.workFTonlyBin7;restricterType1;
				a=5;b=5;d=rownumber;c=t*holder+name.workFTonlyBin7;restricterType1;
				a=6;b=6;d=rownumber;c=t*holder+name.workFTonlyBin7;restricterType1;
			end;
		rownumber=3;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2;
			if t==1;
				stvar(rownumber,numberrest,varnumber)=1;jj=0;
				a=6;b=6;d=rownumber;c=t*holder+name.workFTonlyBin5;restricterType1;
			end;
		rownumber=4;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3;
			if t==1;
				stvar(rownumber,numberrest,varnumber)=5;jj=0;
				a=4;b=4;restricterType0;
				a=1;b=1;d=rownumber;c=t*holder+name.workFTonlyBin6;restricterType1;
				a=2;b=2;d=rownumber;c=t*holder+name.workFTonlyBin6;restricterType1;
				a=3;b=3;d=rownumber;c=t*holder+name.workFTonlyBin6;restricterType1;
				a=5;b=5;d=rownumber;c=t*holder+name.workFTonlyBin6;restricterType1;
			end;
		stvar(1,numrows,varnumber)=rownumber;

	%------------------
	% militaryBin
	%------------------
	varnumber=t*holder+name.militaryBin1; eval(['varval' num2str(varnumber) ' = [militaryt(:,:,t)>=0 & militaryt(:,:,t)<1];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('militaryBin1',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;
		% rownumber=2;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1;
		rownumber=3;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2;
			if t==1; a=6;b=6;restricter; end;
		rownumber=4;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3;
			if t==1; a=1;b=5;restricter; end;
		stvar(1,numrows,varnumber)=rownumber;
	varnumber=t*holder+name.militaryBin2; eval(['varval' num2str(varnumber) ' = [militaryt(:,:,t)>=1 & militaryt(:,:,t)<1.5];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('militaryBin2',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;
		% rownumber=2;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1;
		rownumber=3;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2;
			if t==1; a=6;b=6;restricter; end;
		rownumber=4;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3;
			if t==1; a=1;b=5;restricter; end;
		stvar(1,numrows,varnumber)=rownumber;
	varnumber=t*holder+name.militaryBin3; eval(['varval' num2str(varnumber) ' = [militaryt(:,:,t)>=1.5 & militaryt(:,:,t)<2];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('militaryBin3',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;
		% rownumber=2;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1;
		rownumber=3;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2;
			if t==1; a=1;b=6;restricter; end;
		rownumber=4;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3;
			if t==1; a=1;b=5;restricter; end;
		stvar(1,numrows,varnumber)=rownumber;
	varnumber=t*holder+name.militaryBin4; eval(['varval' num2str(varnumber) ' = [militaryt(:,:,t)>=2 & militaryt(:,:,t)<3];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('militaryBin4',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;
		% rownumber=2;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1;
		rownumber=3;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2;
			if t==1; a=6;b=6;restricter; end;
		rownumber=4;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3;
			if t==1; a=1;b=5;restricter; end;
		stvar(1,numrows,varnumber)=rownumber;
	varnumber=t*holder+name.militaryBin5; eval(['varval' num2str(varnumber) ' = [militaryt(:,:,t)>=3                     ];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('militaryBin5',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;
		% rownumber=2;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1;
		rownumber=3;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2;
			if t==1; a=6;b=6;restricter; end;
		rownumber=4;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3;
			if t==1; a=1;b=5;restricter; end;
		stvar(1,numrows,varnumber)=rownumber;

	%------------------
	% otherBin
	%------------------
	varnumber=t*holder+name.otherBin1; eval(['varval' num2str(varnumber) ' = [othert(:,:,t)>=0 & othert(:,:,t)<0.25];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('otherBin1',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;
		rownumber=2;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1;
			if t==1; a=4;b=4;restricter; end;
		rownumber=3;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2;
		rownumber=4;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3;
			if t==1; a=4;b=4;restricter; end;
		stvar(1,numrows,varnumber)=rownumber;
	varnumber=t*holder+name.otherBin2; eval(['varval' num2str(varnumber) ' = [othert(:,:,t)>=0.25 & othert(:,:,t)<0.5];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('otherBin2',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;
		rownumber=2;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1;
			if t==1; a=4;b=4;restricter; end;
		rownumber=3;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2;
		rownumber=4;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3;
			if t==1; a=4;b=4;restricter; end;
		stvar(1,numrows,varnumber)=rownumber;
	varnumber=t*holder+name.otherBin3; eval(['varval' num2str(varnumber) ' = [othert(:,:,t)>=0.5 & othert(:,:,t)<1];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('otherBin3',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;
		rownumber=2;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1;
			if t==1; a=4;b=4;restricter; end;
		rownumber=3;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2;
		rownumber=4;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3;
			if t==1; a=4;b=4;restricter; end;
		stvar(1,numrows,varnumber)=rownumber;
	varnumber=t*holder+name.otherBin4; eval(['varval' num2str(varnumber) ' = [othert(:,:,t)>=1 & othert(:,:,t)<1.5];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('otherBin4',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;
		rownumber=2;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1;
			if t==1; a=1;b=6;restricter; end;
		rownumber=3;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2;
			if t==1; a=1;b=6;restricter; end;
		rownumber=4;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3;
			if t==1; a=1;b=5;restricter; end;
		stvar(1,numrows,varnumber)=rownumber;
	varnumber=t*holder+name.otherBin5; eval(['varval' num2str(varnumber) ' = [othert(:,:,t)>=1.5 & othert(:,:,t)<2];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('otherBin5',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;
		rownumber=2;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1;
			if t==1; a=4;b=4;restricter; end;
		rownumber=3;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2;
		rownumber=4;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3;
			if t==1; a=4;b=4;restricter; end;
		stvar(1,numrows,varnumber)=rownumber;
	varnumber=t*holder+name.otherBin6; eval(['varval' num2str(varnumber) ' = [othert(:,:,t)>=2 & othert(:,:,t)<3];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('otherBin6',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;
		rownumber=2;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1;
			if t==1; a=4;b=4;restricter; end;
		rownumber=3;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2;
		rownumber=4;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3;
			if t==1; a=4;b=4;restricter; end;
		stvar(1,numrows,varnumber)=rownumber;
	varnumber=t*holder+name.otherBin7; eval(['varval' num2str(varnumber) ' = [othert(:,:,t)>=3 & othert(:,:,t)<4];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('otherBin7',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;
		rownumber=2;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1;
			if t==1; a=4;b=4;restricter; end;
		rownumber=3;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2;
		rownumber=4;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3;
			if t==1;
				stvar(rownumber,numberrest,varnumber)=5;jj=0;
				a=4;b=4;restricterType0;
				a=1;b=1;d=rownumber;c=t*holder+name.otherBin6;restricterType1;
				a=2;b=2;d=rownumber;c=t*holder+name.otherBin6;restricterType1;
				a=3;b=3;d=rownumber;c=t*holder+name.otherBin6;restricterType1;
				a=5;b=5;d=rownumber;c=t*holder+name.otherBin6;restricterType1;
			end;
		stvar(1,numrows,varnumber)=rownumber;
	varnumber=t*holder+name.otherBin8; eval(['varval' num2str(varnumber) ' = [othert(:,:,t)>=4 & othert(:,:,t)<5];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('otherBin8',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;
		rownumber=2;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1;
			if t==1; a=4;b=4;restricter; end;
		rownumber=3;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2;
			if t==1;
				stvar(rownumber,numberrest,varnumber)=1;jj=0;
				a=6;b=6;d=rownumber;c=t*holder+name.otherBin7;restricterType1;
			end;
		rownumber=4;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3;
			if t==1;
				stvar(rownumber,numberrest,varnumber)=5;jj=0;
				a=4;b=4;restricterType0;
				a=1;b=1;d=rownumber;c=t*holder+name.otherBin6;restricterType1;
				a=2;b=2;d=rownumber;c=t*holder+name.otherBin6;restricterType1;
				a=3;b=3;d=rownumber;c=t*holder+name.otherBin6;restricterType1;
				a=5;b=5;d=rownumber;c=t*holder+name.otherBin6;restricterType1;
			end;
		stvar(1,numrows,varnumber)=rownumber;
	varnumber=t*holder+name.otherBin9; eval(['varval' num2str(varnumber) ' = [othert(:,:,t)>=5                       ];']); eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']); namevar{varnumber,1}=strcat('otherBin9',num2str(t)); %experience at the beginning of t - from the data set
		rownumber=1;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,dependent ,varnumber)=type.d.stateVar;
		rownumber=2;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices1;
			if t==1; a=4;b=4;restricter; end;
		rownumber=3;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices2;
			if t==1;
				stvar(rownumber,numberrest,varnumber)=2;jj=0;
				a=4;b=4;d=rownumber;c=t*holder+name.otherBin8;restricterType1;
				a=6;b=6;d=rownumber;c=t*holder+name.otherBin7;restricterType1;
			end;
		rownumber=4;  stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Choices3;
			if t==1;
				stvar(rownumber,numberrest,varnumber)=5;jj=0;
				a=4;b=4;restricterType0;
				a=1;b=1;d=rownumber;c=t*holder+name.otherBin6;restricterType1;
				a=2;b=2;d=rownumber;c=t*holder+name.otherBin6;restricterType1;
				a=3;b=3;d=rownumber;c=t*holder+name.otherBin6;restricterType1;
				a=5;b=5;d=rownumber;c=t*holder+name.otherBin6;restricterType1;
			end;
		stvar(1,numrows,varnumber)=rownumber;


	%============================================================================
	% State variables - Transition/graduation terms
	%============================================================================
	%------------------
	% HS Diploma (8)
	%------------------
	varnumber=t*holder+name.gradHS;
	eval(['varval' num2str(varnumber) ' = [gradHS(:,1,t)];']);
	eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']);
	namevar{varnumber,1}='gradHS';

	stvar(1,discrete,varnumber)=1;

	rownumber=1; % sum of previous degree status & whether gradutated
	stvar(rownumber,present  ,varnumber)=1;
	stvar(rownumber,dependent,varnumber)=type.d.stateVar;

	rownumber=2; % activating condition for risk set 1 - no high school diploma
	stvar(rownumber,present  ,varnumber)=1;
	stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices1;
	stvar(rownumber,dependent,varnumber)=type.d.condition;
	stvar(rownumber,minival  ,varnumber)=-0.05;
	stvar(rownumber,maxival  ,varnumber)=0.05;

	rownumber=3; % activating condition #1 for risk set 2 - high school diploma
	stvar(rownumber,present  ,varnumber)=1;
	stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices2;
	stvar(rownumber,dependent,varnumber)=type.d.condition;
	stvar(rownumber,minival  ,varnumber)=0.95;
	stvar(rownumber,maxival  ,varnumber)=1.05;

	if t<T
		rownumber=4; % gradHS in next period
		stvar(rownumber,present  ,varnumber)=1;
		stvar(rownumber,idmodel  ,varnumber)=(t+1)*holder+name.gradHS;
	end

	% add dummy to Wage1 equation
	rownumber= 5; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage1;

	% add dummy to Wage2 equation
	rownumber= 6; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage2;

	% add dummy to Wage3 equation
	rownumber= 7; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage3;

	stvar(1,numrows,varnumber)=rownumber;

	%----------------
	% BA Degree (9)
	%----------------
	varnumber=t*holder+name.grad4yr;
	eval(['varval' num2str(varnumber) ' = [grad4yr(:,1,t)];']);
	eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']);
	namevar{varnumber,1}='grad4yr';

	stvar(1,discrete,varnumber)=1;

	rownumber=1; % sum of previous degree status & whether gradutated
	stvar(rownumber,present  ,varnumber)=1;
	stvar(rownumber,dependent,varnumber)=type.d.stateVar;

	rownumber=2; %activating condition #2 for risk set 2 - no BA
	stvar(rownumber,present  ,varnumber)=1;
	stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices2;
	stvar(rownumber,dependent,varnumber)=type.d.condition;
	stvar(rownumber,minival  ,varnumber)=-0.05;
	stvar(rownumber,maxival  ,varnumber)=0.05;

	rownumber=3; %activating condition for risk set 3 - bachelor diploma
	stvar(rownumber,present  ,varnumber)=1;
	stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Choices3;
	stvar(rownumber,dependent,varnumber)=type.d.condition;
	stvar(rownumber,minival  ,varnumber)=0.95;
	stvar(rownumber,maxival  ,varnumber)=1.05;

	if t<T
		rownumber=4; % grad4yr in next period
		stvar(rownumber,present  ,varnumber)=1;
		stvar(rownumber,idmodel  ,varnumber)=(t+1)*holder+name.grad4yr;
	end

	% add dummy to Wage1 equation
	rownumber= 5; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage1;

	% add dummy to Wage2 equation
	rownumber= 6; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage2;

	% add dummy to Wage3 equation
	rownumber= 7; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage3;

	stvar(1,numrows,varnumber)=rownumber;

	%============================================================================
	% State variables - Activity dummies for wage
	%============================================================================
	%-----------------
	% inSchWork (10)
	%-----------------
	varnumber=t*holder+name.inSchWork;
	eval(['varval' num2str(varnumber) ' = [inSchWork(:,1,t)];']);
	eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']);
	namevar{varnumber,1}='inSchWork';

	stvar(1,discrete,varnumber)=1;

	rownumber=1; % true if activity==2 or 12 or 22, see rownumber 12 of Outcomes
	stvar(rownumber,present   ,varnumber)=1;
	stvar(rownumber,dependent ,varnumber)=type.d.stateVar;

	% add dummy to Wage1 equation
	rownumber= 2; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage1;

	% add dummy to Wage2 equation
	rownumber= 3; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage2;

	% add dummy to Wage3 equation
	rownumber= 4; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage3;

	stvar(1,numrows,varnumber)=rownumber;

	%-----------------
	% PTwork (11)
	%-----------------
	varnumber=t*holder+name.PTwork;
	eval(['varval' num2str(varnumber) ' = [PTwork(:,1,t)];']);
	eval(['msvar'  num2str(varnumber) ' = 2*(missedInt(:,1,t)==0)-1;']);
	namevar{varnumber,1}='PTwork';

	stvar(1,discrete,varnumber)=1;

	rownumber=1; % true if activity==3 or 13 or 23, see rownumber 13 of Outcomes
	stvar(rownumber,present   ,varnumber)=1;
	stvar(rownumber,dependent ,varnumber)=type.d.stateVar;

	% add dummy to Wage1 equation
	rownumber= 2; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage1;

	% add dummy to Wage2 equation
	rownumber= 3; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage2;

	% add dummy to Wage3 equation
	rownumber= 4; stvar(rownumber,present   ,varnumber)=1; stvar(rownumber,idmodel   ,varnumber)=t*holder+name.Wage3;

	stvar(1,numrows,varnumber)=rownumber;

	%============================================================================
	% Outcomes (Choices & Wages)
	%============================================================================
	%-------------------------
	% Pre HS Grad Choice
	%-------------------------
	varnumber=t*holder+name.Choices1;
	eval(['varval' num2str(varnumber) ' = [choice(:,2:7,t) choice(:,1,t)];']);
	eval(['msvar'  num2str(varnumber) ' = 2*([gradHS(:,1, max(1,t-1) )==0].*[grad4yr(:,1, max(1,t-1) )==0].*[missedInt(:,1,t)==0])-1;']);
	namevar{varnumber,1}='Pre HS Choice';
	stvar(1,discrete,varnumber)=1;

	rownumber=1; % Enters model as a DV
	stvar(rownumber,present   ,varnumber)=1;
	stvar(rownumber,dependent ,varnumber)=type.d.dependent;
	stvar(rownumber,numfac    ,varnumber)=2;
	stvar(rownumber,numfac+1  ,varnumber)=0; %id of the factor
	stvar(rownumber,numfac+2  ,varnumber)=1; %id of the factor
	if t>1
		stvar(rownumber,obscoeff  ,varnumber)=holder+name.Choices1;
		stvar(rownumber,unobscoeff,varnumber)=holder+name.Choices1;
	end
	stvar(rownumber,numcond   ,varnumber)=1;

	rownumber=2; % Creates condition for wage to be turned on; choice workSch
	stvar(rownumber,present  ,varnumber)=1;
	stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Wage1;
	stvar(rownumber,dependent,varnumber)=type.d.condition;
	stvar(rownumber,alter    ,varnumber)=1;

	rownumber=3; % Creates condition for wage to be turned on; choice workPT
	stvar(rownumber,present  ,varnumber)=1;
	stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Wage2;
	stvar(rownumber,dependent,varnumber)=type.d.condition;
	stvar(rownumber,alter    ,varnumber)=2;

	rownumber=4; % Creates condition for wage to be turned on; choice workFT
	stvar(rownumber,present  ,varnumber)=1;
	stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Wage3;
	stvar(rownumber,dependent,varnumber)=type.d.condition;
	stvar(rownumber,alter    ,varnumber)=3;

	if t<T
		rownumber=5; % Increases cumulative XP; schoolOnly
		stvar(rownumber,present  ,varnumber)=1;
		stvar(rownumber,idmodel  ,varnumber)=(t+1)*holder+name.schoolOnly;
		stvar(rownumber,dependent,varnumber)=type.d.ChoiceOrSum;
		stvar(rownumber,alter    ,varnumber)=7;

		rownumber=6; % Increases cumulative XP; anySchool (from choosing schoolOnly)
		stvar(rownumber,present  ,varnumber)=1;
		stvar(rownumber,idmodel  ,varnumber)=(t+1)*holder+name.anySchool;
		stvar(rownumber,dependent,varnumber)=type.d.ChoiceOrSum;
		stvar(rownumber,alter    ,varnumber)=7;

		rownumber=7; % Increases cumulative XP; anySchool (from choosing workK12 NOT college)
		stvar(rownumber,present  ,varnumber)=1;
		stvar(rownumber,idmodel  ,varnumber)=(t+1)*holder+name.anySchool;
		stvar(rownumber,dependent,varnumber)=type.d.ChoiceOrSum;
		stvar(rownumber,alter    ,varnumber)=1;

		rownumber=8; % Increases cumulative XP; workK12 (NOT college)
		stvar(rownumber,present  ,varnumber)=1;
		stvar(rownumber,idmodel  ,varnumber)=(t+1)*holder+name.workK12;
		stvar(rownumber,dependent,varnumber)=type.d.ChoiceOrSum;
		stvar(rownumber,alter    ,varnumber)=1;

		rownumber=9; % Increases cumulative XP; workPT
		stvar(rownumber,present  ,varnumber)=1;
		stvar(rownumber,idmodel  ,varnumber)=(t+1)*holder+name.workPT;
		stvar(rownumber,dependent,varnumber)=type.d.ChoiceOrSum;
		stvar(rownumber,alter    ,varnumber)=2;

		rownumber=10; % Increases cumulative XP; workFT
		stvar(rownumber,present  ,varnumber)=1;
		stvar(rownumber,idmodel  ,varnumber)=(t+1)*holder+name.workFT;
		stvar(rownumber,dependent,varnumber)=type.d.ChoiceOrSum;
		stvar(rownumber,alter    ,varnumber)=3;

		rownumber=11; % Increases cumulative XP; military
		stvar(rownumber,present  ,varnumber)=1;
		stvar(rownumber,idmodel  ,varnumber)=(t+1)*holder+name.military;
		stvar(rownumber,dependent,varnumber)=type.d.ChoiceOrSum;
		stvar(rownumber,alter    ,varnumber)=4;

		rownumber=12; % Increases cumulative XP; other
		stvar(rownumber,present  ,varnumber)=1;
		stvar(rownumber,idmodel  ,varnumber)=(t+1)*holder+name.other;
		stvar(rownumber,dependent,varnumber)=type.d.ChoiceOrSum;
		stvar(rownumber,alter    ,varnumber)=5;

		rownumber=13; % Receive HS diploma
		stvar(rownumber,present  ,varnumber)=1;
		stvar(rownumber,idmodel  ,varnumber)=(t+1)*holder+name.gradHS;
		stvar(rownumber,dependent,varnumber)=type.d.ChoiceOrSum;
		stvar(rownumber,alter    ,varnumber)=6;
	end

	rownumber=14; % Creates condition for inSchWork to be turned on
	stvar(rownumber,present  ,varnumber)=1;
	stvar(rownumber,idmodel  ,varnumber)=t*holder+name.inSchWork;
	stvar(rownumber,dependent,varnumber)=type.d.condition;
	stvar(rownumber,alter    ,varnumber)=1;

	rownumber=15; % Creates condition for PTwork to be turned on
	stvar(rownumber,present  ,varnumber)=1;
	stvar(rownumber,idmodel  ,varnumber)=t*holder+name.PTwork;
	stvar(rownumber,dependent,varnumber)=type.d.condition;
	stvar(rownumber,alter    ,varnumber)=2;

	stvar(1,numrows,varnumber)=rownumber;

	%------------------------------------------
	% Post HS Pre College Grad Choice
	%------------------------------------------
	varnumber=t*holder+name.Choices2;
	eval(['varval' num2str(varnumber) ' = [choice(:,12:17,t) choice(:,11,t)];']);
	eval(['msvar'  num2str(varnumber) ' = 2*([gradHS(:,1, max(1,t-1) )==1].*[grad4yr(:,1, max(1,t-1) )==0].*[missedInt(:,1,t)==0])-1;']);
	namevar{varnumber,1}='Post HS Pre College Grad Choice';
	stvar(1,discrete,varnumber)=1;

	rownumber=1; % Enters model as a DV
	stvar(rownumber,present  ,varnumber)=1;
	stvar(rownumber,dependent,varnumber)=type.d.dependent;
	stvar(rownumber,numfac   ,varnumber)=2;
	stvar(rownumber,numfac+1 ,varnumber)=0; %id of the factor
	stvar(rownumber,numfac+2 ,varnumber)=1; %id of the factor
	if t>1
		stvar(rownumber,obscoeff  ,varnumber)=holder+name.Choices2;
		stvar(rownumber,unobscoeff,varnumber)=holder+name.Choices2;
	end
	stvar(rownumber,numcond  ,varnumber)=2;

	rownumber=2; % Creates condition for wage to be turned on; choice workSch
	stvar(rownumber,present  ,varnumber)=1;
	stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Wage1;
	stvar(rownumber,dependent,varnumber)=type.d.condition;
	stvar(rownumber,alter    ,varnumber)=1;

	rownumber=3; % Creates condition for wage to be turned on; choice workPT
	stvar(rownumber,present  ,varnumber)=1;
	stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Wage2;
	stvar(rownumber,dependent,varnumber)=type.d.condition;
	stvar(rownumber,alter    ,varnumber)=2;

	rownumber=4; % Creates condition for wage to be turned on; choice workFT
	stvar(rownumber,present  ,varnumber)=1;
	stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Wage3;
	stvar(rownumber,dependent,varnumber)=type.d.condition;
	stvar(rownumber,alter    ,varnumber)=3;

	if t<T
		rownumber=5; % Increases cumulative XP; schoolOnly
		stvar(rownumber,present  ,varnumber)=1;
		stvar(rownumber,idmodel  ,varnumber)=(t+1)*holder+name.schoolOnly;
		stvar(rownumber,dependent,varnumber)=type.d.ChoiceOrSum;
		stvar(rownumber,alter    ,varnumber)=7;

		rownumber=6; % Increases cumulative XP; anySchool (from choosing schoolOnly)
		stvar(rownumber,present  ,varnumber)=1;
		stvar(rownumber,idmodel  ,varnumber)=(t+1)*holder+name.anySchool;
		stvar(rownumber,dependent,varnumber)=type.d.ChoiceOrSum;
		stvar(rownumber,alter    ,varnumber)=7;

		rownumber=7; % Increases cumulative XP; anySchool (from choosing workCollege NOT K12)
		stvar(rownumber,present  ,varnumber)=1;
		stvar(rownumber,idmodel  ,varnumber)=(t+1)*holder+name.anySchool;
		stvar(rownumber,dependent,varnumber)=type.d.ChoiceOrSum;
		stvar(rownumber,alter    ,varnumber)=1;

		rownumber=8; % Increases cumulative XP; workCollege (NOT K12)
		stvar(rownumber,present  ,varnumber)=1;
		stvar(rownumber,idmodel  ,varnumber)=(t+1)*holder+name.workCollege;
		stvar(rownumber,dependent,varnumber)=type.d.ChoiceOrSum;
		stvar(rownumber,alter    ,varnumber)=1;

		rownumber=9; % Increases cumulative XP; workPT
		stvar(rownumber,present  ,varnumber)=1;
		stvar(rownumber,idmodel  ,varnumber)=(t+1)*holder+name.workPT;
		stvar(rownumber,dependent,varnumber)=type.d.ChoiceOrSum;
		stvar(rownumber,alter    ,varnumber)=2;

		rownumber=10; % Increases cumulative XP; workFT
		stvar(rownumber,present  ,varnumber)=1;
		stvar(rownumber,idmodel  ,varnumber)=(t+1)*holder+name.workFT;
		stvar(rownumber,dependent,varnumber)=type.d.ChoiceOrSum;
		stvar(rownumber,alter    ,varnumber)=3;

		rownumber=11; % Increases cumulative XP; military
		stvar(rownumber,present  ,varnumber)=1;
		stvar(rownumber,idmodel  ,varnumber)=(t+1)*holder+name.military;
		stvar(rownumber,dependent,varnumber)=type.d.ChoiceOrSum;
		stvar(rownumber,alter    ,varnumber)=4;

		rownumber=12; % Increases cumulative XP; other
		stvar(rownumber,present  ,varnumber)=1;
		stvar(rownumber,idmodel  ,varnumber)=(t+1)*holder+name.other;
		stvar(rownumber,dependent,varnumber)=type.d.ChoiceOrSum;
		stvar(rownumber,alter    ,varnumber)=5;

		rownumber=13; % Receive College Degree
		stvar(rownumber,present  ,varnumber)=1;
		stvar(rownumber,idmodel  ,varnumber)=(t+1)*holder+name.grad4yr;
		stvar(rownumber,dependent,varnumber)=type.d.ChoiceOrSum;
		stvar(rownumber,alter    ,varnumber)=6;
	end

	rownumber=14; % Creates condition for inSchWork to be turned on
	stvar(rownumber,present  ,varnumber)=1;
	stvar(rownumber,idmodel  ,varnumber)=t*holder+name.inSchWork;
	stvar(rownumber,dependent,varnumber)=type.d.condition;
	stvar(rownumber,alter    ,varnumber)=1;

	rownumber=15; % Creates condition for PTwork to be turned on
	stvar(rownumber,present  ,varnumber)=1;
	stvar(rownumber,idmodel  ,varnumber)=t*holder+name.PTwork;
	stvar(rownumber,dependent,varnumber)=type.d.condition;
	stvar(rownumber,alter    ,varnumber)=2;

	stvar(1,numrows,varnumber)=rownumber;

	%---------------------------------
	% Post College Grad Choice
	%---------------------------------
	varnumber=t*holder+name.Choices3;
	eval(['varval' num2str(varnumber) ' = [choice(:,22:26,t) choice(:,21,t)];']);
	eval(['msvar'  num2str(varnumber) ' = 2*([gradHS(:,1, max(1,t-1) )==1].*[grad4yr(:,1, max(1,t-1) )==1].*[missedInt(:,1,t)==0])-1;']);
	namevar{varnumber,1}='Post College Grad Choice';
	stvar(1,discrete,varnumber)=1;

	rownumber=1; % Enters model as a DV
	stvar(rownumber,present  ,varnumber)=1;
	stvar(rownumber,dependent,varnumber)=type.d.dependent;
	stvar(rownumber,numfac   ,varnumber)=2;
	stvar(rownumber,numfac+1 ,varnumber)=0; %id of the factor
	stvar(rownumber,numfac+2 ,varnumber)=1; %id of the factor
	if t>1
		stvar(rownumber,obscoeff  ,varnumber)=holder+name.Choices3;
		stvar(rownumber,unobscoeff,varnumber)=holder+name.Choices3;
	end
	stvar(rownumber,numcond  ,varnumber)=1;

	rownumber=2; % Creates condition for wage to be turned on; choice workSch
	stvar(rownumber,present  ,varnumber)=1;
	stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Wage1;
	stvar(rownumber,dependent,varnumber)=type.d.condition;
	stvar(rownumber,alter    ,varnumber)=1;

	rownumber=3; % Creates condition for wage to be turned on; choice workPT
	stvar(rownumber,present  ,varnumber)=1;
	stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Wage2;
	stvar(rownumber,dependent,varnumber)=type.d.condition;
	stvar(rownumber,alter    ,varnumber)=2;

	rownumber=4; % Creates condition for wage to be turned on; choice workFT
	stvar(rownumber,present  ,varnumber)=1;
	stvar(rownumber,idmodel  ,varnumber)=t*holder+name.Wage3;
	stvar(rownumber,dependent,varnumber)=type.d.condition;
	stvar(rownumber,alter    ,varnumber)=3;

	if t<T
		rownumber=5; % Increases cumulative XP; schoolOnly
		stvar(rownumber,present  ,varnumber)=1;
		stvar(rownumber,idmodel  ,varnumber)=(t+1)*holder+name.schoolOnly;
		stvar(rownumber,dependent,varnumber)=type.d.ChoiceOrSum;
		stvar(rownumber,alter    ,varnumber)=6;

		rownumber=6; % Increases cumulative XP; anySchool (from choosing schoolOnly)
		stvar(rownumber,present  ,varnumber)=1;
		stvar(rownumber,idmodel  ,varnumber)=(t+1)*holder+name.anySchool;
		stvar(rownumber,dependent,varnumber)=type.d.ChoiceOrSum;
		stvar(rownumber,alter    ,varnumber)=6;

		rownumber=7; % Increases cumulative XP; anySchool (from choosing workCollege NOT K12)
		stvar(rownumber,present  ,varnumber)=1;
		stvar(rownumber,idmodel  ,varnumber)=(t+1)*holder+name.anySchool;
		stvar(rownumber,dependent,varnumber)=type.d.ChoiceOrSum;
		stvar(rownumber,alter    ,varnumber)=1;

		rownumber=8; % Increases cumulative XP; workCollege (NOT K12)
		stvar(rownumber,present  ,varnumber)=1;
		stvar(rownumber,idmodel  ,varnumber)=(t+1)*holder+name.workCollege;
		stvar(rownumber,dependent,varnumber)=type.d.ChoiceOrSum;
		stvar(rownumber,alter    ,varnumber)=1;

		rownumber=9; % Increases cumulative XP; workPT
		stvar(rownumber,present  ,varnumber)=1;
		stvar(rownumber,idmodel  ,varnumber)=(t+1)*holder+name.workPT;
		stvar(rownumber,dependent,varnumber)=type.d.ChoiceOrSum;
		stvar(rownumber,alter    ,varnumber)=2;

		rownumber=10; % Increases cumulative XP; workFT
		stvar(rownumber,present  ,varnumber)=1;
		stvar(rownumber,idmodel  ,varnumber)=(t+1)*holder+name.workFT;
		stvar(rownumber,dependent,varnumber)=type.d.ChoiceOrSum;
		stvar(rownumber,alter    ,varnumber)=3;

		rownumber=11; % Increases cumulative XP; military
		stvar(rownumber,present  ,varnumber)=1;
		stvar(rownumber,idmodel  ,varnumber)=(t+1)*holder+name.military;
		stvar(rownumber,dependent,varnumber)=type.d.ChoiceOrSum;
		stvar(rownumber,alter    ,varnumber)=4;

		rownumber=12; % Increases cumulative XP; other
		stvar(rownumber,present  ,varnumber)=1;
		stvar(rownumber,idmodel  ,varnumber)=(t+1)*holder+name.other;
		stvar(rownumber,dependent,varnumber)=type.d.ChoiceOrSum;
		stvar(rownumber,alter    ,varnumber)=5;
	end

	rownumber=14; % Creates condition for inSchWork to be turned on
	stvar(rownumber,present  ,varnumber)=1;
	stvar(rownumber,idmodel  ,varnumber)=t*holder+name.inSchWork;
	stvar(rownumber,dependent,varnumber)=type.d.condition;
	stvar(rownumber,alter    ,varnumber)=1;

	rownumber=15; % Creates condition for PTwork to be turned on
	stvar(rownumber,present  ,varnumber)=1;
	stvar(rownumber,idmodel  ,varnumber)=t*holder+name.PTwork;
	stvar(rownumber,dependent,varnumber)=type.d.condition;
	stvar(rownumber,alter    ,varnumber)=2;

	stvar(1,numrows,varnumber)=rownumber;

	%---------------------------------
	% Wage(s)
	%---------------------------------
	varnumber=t*holder+name.Wage1;
	eval(['varval' num2str(varnumber) ' = [lnWageNoSelf(:,:,t)];']);
	eval([ 'msvar'  num2str(varnumber) ' = 2*((missedInt(:,1,t)==0) & (missedWageNoSelf(:,1,t)==0) & (choice(:,2,t)==1 | choice(:,12,t)==1 | choice(:,22,t)==1))-1;' ]);
	namevar{varnumber,1}='WageWorkSch';

	rownumber=1; % Enters model as a DV
	stvar(rownumber,present   ,varnumber)=1;
	stvar(rownumber,dependent ,varnumber)=type.d.dependent;
	stvar(rownumber,numfac    ,varnumber)=2;
	stvar(rownumber,numfac+1  ,varnumber)=0; %id of the factor
	stvar(rownumber,numfac+2  ,varnumber)=1; %id of the factor
	if t>1
		stvar(rownumber,obscoeff  ,varnumber)=holder+name.Wage1;
		stvar(rownumber,unobscoeff,varnumber)=holder+name.Wage1;
		stvar(rownumber,varcoeff  ,varnumber)=holder+name.Wage1;
	end
	stvar(rownumber,numcond   ,varnumber)=1;

	stvar(1,numrows,varnumber)=rownumber;

	varnumber=t*holder+name.Wage2;
	eval(['varval' num2str(varnumber) ' = [lnWageNoSelf(:,:,t)];']);
	eval([ 'msvar'  num2str(varnumber) ' = 2*((missedInt(:,1,t)==0) & (missedWageNoSelf(:,1,t)==0) & (choice(:,3,t)==1 | choice(:,13,t)==1 | choice(:,23,t)==1))-1;' ]);
	namevar{varnumber,1}='WageWorkPT';

	rownumber=1; % Enters model as a DV
	stvar(rownumber,present   ,varnumber)=1;
	stvar(rownumber,dependent ,varnumber)=type.d.dependent;
	stvar(rownumber,numfac    ,varnumber)=2;
	stvar(rownumber,numfac+1  ,varnumber)=0; %id of the factor
	stvar(rownumber,numfac+2  ,varnumber)=1; %id of the factor
	if t>=1
		stvar(rownumber,obscoeff  ,varnumber)=holder+name.Wage1;
	end
	if t>1
		stvar(rownumber,unobscoeff,varnumber)=holder+name.Wage2;
		stvar(rownumber,varcoeff  ,varnumber)=holder+name.Wage2;
	end
	stvar(rownumber,numcond   ,varnumber)=1;

	stvar(1,numrows,varnumber)=rownumber;

	varnumber=t*holder+name.Wage3;
	eval(['varval' num2str(varnumber) ' = [lnWageNoSelf(:,:,t)];']);
	eval([ 'msvar'  num2str(varnumber) ' = 2*((missedInt(:,1,t)==0) & (missedWageNoSelf(:,1,t)==0) & (choice(:,4,t)==1 | choice(:,14,t)==1 | choice(:,24,t)==1))-1;' ]);
	namevar{varnumber,1}='WageWorkFT';

	rownumber=1; % Enters model as a DV
	stvar(rownumber,present   ,varnumber)=1;
	stvar(rownumber,dependent ,varnumber)=type.d.dependent;
	stvar(rownumber,numfac    ,varnumber)=2;
	stvar(rownumber,numfac+1  ,varnumber)=0; %id of the factor
	stvar(rownumber,numfac+2  ,varnumber)=1; %id of the factor
	if t>=1
		stvar(rownumber,obscoeff  ,varnumber)=holder+name.Wage1;
	end
	if t>1
		stvar(rownumber,unobscoeff,varnumber)=holder+name.Wage3;
		stvar(rownumber,varcoeff  ,varnumber)=holder+name.Wage3;
	end
	stvar(rownumber,numcond   ,varnumber)=1;

	stvar(1,numrows,varnumber)=rownumber;

	%---------------------------------
	% ASVAB(s) - Only enters once
	%---------------------------------
	if t==1
		% asvabAR
		varnumber=t*holder+name.asvabAR;
		eval(['varval' num2str(varnumber) ' = [asvabAR(:,1,t)];']);
		eval([ 'msvar'  num2str(varnumber) ' = 2*(m_asvabAR(:,1,t)==0)-1;' ]);
		namevar{varnumber,1}='asvabAR';

		rownumber=1; % Enters model as a DV
		stvar(rownumber,present   ,varnumber)=1;
		stvar(rownumber,dependent ,varnumber)=type.d.dependent;
		stvar(rownumber,numfac    ,varnumber)=1;
		stvar(rownumber,numfac+1  ,varnumber)=0; %id of the factor

		stvar(1,numrows,varnumber)=rownumber;

		% asvabCS
		varnumber=t*holder+name.asvabCS;
		eval(['varval' num2str(varnumber) ' = [asvabCS(:,1,t)];']);
		eval([ 'msvar'  num2str(varnumber) ' = 2*(m_asvabCS(:,1,t)==0)-1;' ]);
		namevar{varnumber,1}='asvabCS';

		rownumber=1; % Enters model as a DV
		stvar(rownumber,present   ,varnumber)=1;
		stvar(rownumber,dependent ,varnumber)=type.d.dependent;
		stvar(rownumber,numfac    ,varnumber)=1;
		stvar(rownumber,numfac+1  ,varnumber)=0; %id of the factor

		stvar(1,numrows,varnumber)=rownumber;

		% asvabMK
		varnumber=t*holder+name.asvabMK;
		eval(['varval' num2str(varnumber) ' = [asvabMK(:,1,t)];']);
		eval([ 'msvar'  num2str(varnumber) ' = 2*(m_asvabMK(:,1,t)==0)-1;' ]);
		namevar{varnumber,1}='asvabMK';

		rownumber=1; % Enters model as a DV
		stvar(rownumber,present   ,varnumber)=1;
		stvar(rownumber,dependent ,varnumber)=type.d.dependent;
		stvar(rownumber,numfac    ,varnumber)=1;
		stvar(rownumber,numfac+1  ,varnumber)=0; %id of the factor

		stvar(1,numrows,varnumber)=rownumber;

		% asvabNO
		varnumber=t*holder+name.asvabNO;
		eval(['varval' num2str(varnumber) ' = [asvabNO(:,1,t)];']);
		eval([ 'msvar'  num2str(varnumber) ' = 2*(m_asvabNO(:,1,t)==0)-1;' ]);
		namevar{varnumber,1}='asvabNO';

		rownumber=1; % Enters model as a DV
		stvar(rownumber,present   ,varnumber)=1;
		stvar(rownumber,dependent ,varnumber)=type.d.dependent;
		stvar(rownumber,numfac    ,varnumber)=1;
		stvar(rownumber,numfac+1  ,varnumber)=0; %id of the factor

		stvar(1,numrows,varnumber)=rownumber;

		% asvabPC
		varnumber=t*holder+name.asvabPC;
		eval(['varval' num2str(varnumber) ' = [asvabPC(:,1,t)];']);
		eval([ 'msvar'  num2str(varnumber) ' = 2*(m_asvabPC(:,1,t)==0)-1;' ]);
		namevar{varnumber,1}='asvabPC';

		rownumber=1; % Enters model as a DV
		stvar(rownumber,present   ,varnumber)=1;
		stvar(rownumber,dependent ,varnumber)=type.d.dependent;
		stvar(rownumber,numfac    ,varnumber)=1;
		stvar(rownumber,numfac+1  ,varnumber)=0; %id of the factor

		stvar(1,numrows,varnumber)=rownumber;

		% asvabWK
		varnumber=t*holder+name.asvabWK;
		eval(['varval' num2str(varnumber) ' = [asvabWK(:,1,t)];']);
		eval([ 'msvar'  num2str(varnumber) ' = 2*(m_asvabWK(:,1,t)==0)-1;' ]);
		namevar{varnumber,1}='asvabWK';

		rownumber=1; % Enters model as a DV
		stvar(rownumber,present   ,varnumber)=1;
		stvar(rownumber,dependent ,varnumber)=type.d.dependent;
		stvar(rownumber,numfac    ,varnumber)=1;
		stvar(rownumber,numfac+1  ,varnumber)=0; %id of the factor

		stvar(1,numrows,varnumber)=rownumber;
	end
end

disp ('Data Formatted')


numel(stvar)
size(stvar)
% save -v7.3 regri_data79
clear A BAgradrisk HSgradrisk K0 K1 KK PTwork T Wvars activity activity_simple afqt asvabAR asvabCS asvabMK asvabNO asvabPC asvabWK all_long all_vars ans argum black born1957 born1958 born1959 born1960 born1961 born1962 born1963 born1980 born1981 born1982 born1983 chng_vars choice cohortFlag cons_vars constant counter d_alpha d_beta d_sigma data empPct famInc famIncSq female femaleHeadHH14 foreignBorn grad2yr grad4yr gradGraduate gradHS hgcFath hgcFathSq hgcMoth hgcMothSq hispanic hours i id inSchWork incPerCapita liveWithMom14 lnWage lnWageAlt lnWageAltNoSelf lnWageJobMain lnWageNoSelf m_afqt m_asvabAR m_asvabCS m_asvabMK m_asvabNO m_asvabPC m_asvabWK m_famInc m_hgcFath m_hgcMoth militaryBlack militaryCu militaryHisp militarySq militarySqBlack militarySqHisp militaryt missedInt missedWage nRestrA nRestrB otherBlack otherCu otherHisp otherSq otherSqBlack otherSqHisp othert oversampleRace period preHSrisk rA rB schoolOnlyBlack schoolOnlyCu schoolOnlyHisp schoolOnlySq schoolOnlySqBlack schoolOnlySqHisp schoolOnlyt uniqueid wager weight workCollegeBlack workCollegeCu workCollegeHisp workCollegeSq workCollegeSqBlack workCollegeSqHisp workCollegeschoolOnly workColleget workCollegeworkK12 workFTBlack workFTCu workFTHisp workFTSq workFTSqBlack workFTSqHisp workFTonlyt workFTschoolOnly workFTworkCollege workFTworkK12 workFTworkPT workK12Black workK12Cu workK12Hisp workK12Sq workK12SqBlack workK12SqHisp workK12schoolOnly workK12t workPTBlack workPTCu workPTHisp workPTSq workPTSqBlack workPTSqHisp workPTonlyt workPTschoolOnly workPTworkCollege workPTworkK12 working yearmo numBA numBAperCapita tuitionFlagship potExp*
save -v7.3 modeldescr

form_model5
form_inputTJ2
%form_inputTJ2sh %"sh" means "short" -- should only be run if form_inputTJ2 has been run once
toc

diary off
