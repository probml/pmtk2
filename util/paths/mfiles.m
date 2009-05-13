function m = mfiles(source)
% list all mfiles in the specified directory structure.     
    if nargin < 1, source = '.'; end
   [dirinfo,m] = mfilelist(source); 
    
end