classdef FitEng
  
    properties(Abstract = true)
        diagnostics;
        verbose;
    end
     
    methods(Abstract = true)
        fit;
    end
    
end

