classdef ParamModel < ProbModel
    
    properties(Abstract = true)
        params;
        prior;
        dof;
    end
    
    
    methods
        
        function S = mkSuffStat(model,D,weights)
           
        end
        
        
    end
    
    methods(Abstract = true)
         fit;     
        
    end
end