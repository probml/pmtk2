classdef ScalarCondDist < ParamModel
    
    methods
        function [yhat, py] = predictOutput(m, D)
            yhat = mode(m, 'output', D); % for CRFs, this is Viterbi; for logreg, it is classifcation
            if nargout >=2
                py = marginal(m, 'output', D); % for CRFs, this is one-slice marginals
            end
        end
        
    end
end

