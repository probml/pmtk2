classdef BayesModel
 
  
    properties(Abstract = true)
       paramDist; 
    end
    
    methods(Abstract = true)
        
        getParamPost;

        
        
    end
    
end

