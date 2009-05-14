function m = mfiles(source,topOnly)
% list all mfiles in the specified directory structure.     
    if nargin < 1, source = '.'; end
    if nargin < 2, topOnly = false; end
    if topOnly
        I = what(source);
        m = I.m;
    else
        [dirinfo,m] = mfilelist(source); 
        m = m';
    end
    
end