classdef CondScalarDist < ProbModel
   
    methods
        function M = predict(model,varargin)
           M = marginal(model,varargin{:}); 
        end
        
        function Y = predictResponse(model, D)
            Y = mode(model, Query('output'), D);
        end
        
    end
end

