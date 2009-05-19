classdef FitEng
  
    properties
        model;
        diagnostics;
        fitOptions;
        verbose;
    end
    
    methods(Abstract = true)
        fit;
    end
    
end

