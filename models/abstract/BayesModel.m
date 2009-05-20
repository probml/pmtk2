classdef BayesModel
 
  
    properties(Abstract = true)
       paramDist; 
    end
    
    methods(Abstract = true)
        
        getParamPost;
        logMargLik;
        
        
    end
    
end

