classdef FitEng
  
    properties(Abstract = true)
        diagnostics;
    end
    
    properties(Access = 'protected',Abstract = true)
       verbose; 
    end
    
    methods(Abstract = true)
        fit;
    end
    
end

