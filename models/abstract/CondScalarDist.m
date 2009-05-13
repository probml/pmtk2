classdef CondScalarDist < ProbModel
   
    methods
        function M = predict(model,varargin)
           M = marginal(model,varargin{:}); 
        end
        
    end
end

