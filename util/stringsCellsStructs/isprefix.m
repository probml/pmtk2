function p = isprefix(short,long)
% ISPREFIX Tests if the first arg is a prefix of the second. 
% The second arg may also be a cell array of strings, in which case, each
% is tested. CASE SENSITIVE!
%
% EXAMPLES:
% 
% isprefix('foo','foobar')
% ans =
%      1
%
%isprefix('test_',{'test_MvnDist','test_DiscreteDist','UnitTest'})
%ans =
%     1     1     0
    error(nargchk(2,2,nargin));
    if ischar(long)
        p = strncmp(long,short,length(short));
    elseif iscellstr(long)
        p = cellfun(@(c)strncmp(c,short,length(short)),long);
    else
       error('The second input must be a string, or a cell array of strings'); 
    end
end