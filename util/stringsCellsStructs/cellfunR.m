function C = cellfunR(fun,C)
% Recursive version of cellfuncell    
    if cellDepth(C) < 2
        C = cellfuncell(fun,C);
    else
        C = cellfuncell(@(cl)cellfunR(fun,cl),C);
    end
    
end