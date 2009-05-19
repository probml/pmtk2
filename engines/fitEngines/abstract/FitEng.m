classdef FitEng
  
    properties(Abstract = true)
        model;
        diagnostics;
        verbose;
    end
    
    methods(Abstract = true)
        fit;
    end
    
end

