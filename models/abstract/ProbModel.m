classdef ProbModel < ProbDist
% ProbModels all have parameters, which is not true of all ProbDists, (e.g.
% SampleDist).
    
    properties(Abstract = true)
        fitEng;
        modelSelEng;
        params;
    end
    
    methods(Abstract = true)
        sample;
        logprob;
        fit;
        dof;
    end
    
    
    methods
        
        function D = impute(model,D,Q)
          notYetImplemented('ProbModel.impute()');
        end
        
        function M = marginal(model,D,Q)
           M = computeMarginal(model.stateEstEng,D,Q); 
        end
        
        function lp = logprior(model)
           lp = 0; 
        end
        
        function J = penNLL(model,D)
            J = -sum(logprob(model,D)) - logprior(model);
        end
        
        
    end
    
end

