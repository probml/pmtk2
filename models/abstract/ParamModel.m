classdef ParamModel < ProbModel
    
    properties(Abstract = true)
        params;
    end
    
    
    methods(Abstract = true)
        
        dof;
    end
    
    
    methods
        
        function lp = logprior(model)
            lp = 0;
        end
        
        function J = penNLL(model,D)
            J = -sum(logpdf(model,D)) - logprior(model);
        end
        
        
        
    end
end