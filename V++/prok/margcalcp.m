function [derip] = margcalcp(regi)
global argmarg ban1 IregrM IdefauM %IindRegrM InuminterM IinteroneM IintertwoM IinterbothM IintermultM ISSVarM  InumindivM InumRegrM

ban1.regrval = regi;
[regrMC defauMC] = regrinput(ban1);
% regrMD=regrMC;
% for yi=1:argmarg{1,InumindivM}
	% for tf = 1:argmarg{1,ISSVarM}
		% for to=1:argmarg{1,InuminterM}(tf,1)
			% regrMD(argmarg{1,IindRegrM}(tf,1)*argmarg{1,InumindivM}+(yi-1)*argmarg{1,InumRegrM}(tf,1)+argmarg{1,IinterbothM}(tf,to)+1)=regrMD(argmarg{1,IindRegrM}(tf,1)*argmarg{1,InumindivM}+(yi-1)*argmarg{1,InumRegrM}(tf,1)+argmarg{1,IinteroneM}(tf,to)+1)*regrMD(argmarg{1,IindRegrM}(tf,1)*argmarg{1,InumindivM}+(yi-1)*argmarg{1,InumRegrM}(tf,1)+argmarg{1,IintertwoM}(tf,to)+1)*argmarg{1,IintermultM}(tf,to);
		% end
	% end
% end
argmarg{1,IregrM} = regrMC;
argmarg{1,IdefauM} = defauMC;
[CmatrEAZ CmatrEIZ CmatrWZ CmatrMUZ CmatrPIZ]=marg(argmarg{1,:});
derip = CmatrEAZ;
