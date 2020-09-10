user = getenv('USER')

if     strcmp(user,'jared')
	addpath  [REDACTED]V++/prok -end
elseif strcmp(user,'ransom')
	addpath  [REDACTED]V++/prok -end
else
	'Invalid user'
end
