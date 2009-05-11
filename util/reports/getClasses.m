function classes = getClasses(source)
% Get a list of all of the classes below the specified directory that are 
% on the Matlab path.
    
if nargin < 1, source = '.'; end
[dirinfo,mfiles] = mfilelist(source);
classes = mfiles(isclassdef(cellfuncell(@(c)c(1:end-2),mfiles)));


end