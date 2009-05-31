classdef BayesModel
% Abstract Bayesian Model  
  
    properties(Abstract = true)
       paramDist; 
    end
    
    methods(Abstract = true)
        
        getParamPost;

        
        
    end
    
end

