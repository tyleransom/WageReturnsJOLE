jj=jj+1; % Note: jj was (hopefully) defined previously
restnum =jj;
restrid = numberrest+(restnum-1)*sizeRest;
stvar(rownumber,restrid+typeRest   ,varnumber)=1;
stvar(rownumber,restrid+numAltRestA,varnumber)=a;
stvar(rownumber,restrid+numRegRestB,varnumber)=c;
stvar(rownumber,restrid+numAltRestB,varnumber)=b;
stvar(rownumber,restrid+parRestB   ,varnumber)=d;
