function [local,implemented] = islocal(methodname,classname,allowAbstract)
% ISLOCAL Test if a method is defined locally in a class. 
% Return false if methodname is not a method of the class, or if it is 
% inherited, (but not overridden), abstract, hidden, private,
% protected, or the class constructor. You can remove the restriction that
% the method be abstract by specifying allowAbstract as true. 
%
% The second output is true, iff the method is publically implemented 
% somewhere, (could be static or a class constructor, but not hidden or 
% abstract, - allowAbstract ignored here)
%
% Vectorized w.r.t methodname, (i.e. methodname can be a cell array of strings)
%
% See also, localMethods
        
        if nargin < 3, allowAbstract = false; end
        
        if strcmp(classname(end-1:end),'.m')
            classname = classname(1:end-2);
        end
        implemented = {}; local = {};
        
        if iscellstr(methodname)
           local = false(numel(methodname),1);  implemented = false(numel(methodname),1); 
           for i=1:numel(methodname)
              [local(i),implemented(i)] = islocal(methodname{i},classname); 
           end
           return;
        end
        
        metaClass = meta.class.fromName(classname);
        if isempty(metaClass), error('Could not find the class %s',classname); end
        meths = metaClass.Methods;
        
        found = false;
        for i=1:numel(meths)
            m = meths{i};
            if strcmpi(methodname,m.Name), found = true; break; end
        end
        if ~found, local = false; return; end
        implemented = strcmp(m.Access,'public') && ~m.Abstract && ~m.Hidden;
        if allowAbstract,
            local = implemented && strcmp(m.DefiningClass.Name,classname) && ~strcmp(m.Name,classname);   
        else
            local = strcmp(m.Access,'public') && ~m.Hidden && strcmp(m.DefiningClass.Name,classname) && ~strcmp(m.Name,classname);   
        end
end