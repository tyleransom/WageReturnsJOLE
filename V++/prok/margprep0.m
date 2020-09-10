% function [varchronmodmarg] = margprep0(Before)

% global varlistchron varlistchronmod



firstvar=find(varlistchronmod==Before.earlyvar,1);
lastvar=find(varlistchronmod==Before.varinter(1,end),1);

for i=1:length(Before.fixedvar)
	fas=find(varlistchronmod==Before.fixedvar(1,i),1);
	if length(fas)>0
		firstvar=min(fas,firstvar);
		lastvar=max(fas,lastvar);
	end
end

for j=1:length(Before.varinter)
	fas=find(varlistchronmod==Before.varinter(1,j),1);
	if length(fas)>0
		firstvar=min(fas,firstvar);
		lastvar=max(fas,lastvar);
	end
end

for i=1:length(After.fixedvar)
	fas=find(varlistchronmod==After.fixedvar(1,i),1);
	if length(fas)>0
		firstvar=min(fas,firstvar);
		lastvar=max(fas,lastvar);
	end
end

for j=1:length(After.varinter)
	fas=find(varlistchronmod==After.varinter(1,j),1);
	if length(fas)>0
		firstvar=min(fas,firstvar);
		lastvar=max(fas,lastvar);
	end
end

varchronmodmarg=varlistchronmod(firstvar:lastvar,1);