function [local,implemented] = localMethods(classname,allowAbstract)
%LOCALMETHODS Return the local methods of a class - see islocal() for a
%description of what 'local' means.

    if nargin < 2, allowAbstract = false; end
    m = methods(classname);
    [localBool,implementedBool] = islocal(m,classname,allowAbstract);
    local = m(localBool);
    if nargout ~= 1
        implemented = m(implementedBool);
    end



    
    
end