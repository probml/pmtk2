function [local,implemented] = localMethods(classname)
%LOCALMETHODS Return the local methods of a class - see islocal() for a
%description of what 'local' means.

    m = methods(classname);
    [localBool,implementedBool] = islocal(m,classname);
    local = m(localBool);
    if nargout ~= 1
        implemented = m(implementedBool);
    end



    
    
end