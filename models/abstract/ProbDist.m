classdef ProbDist
%PROBDIST Abstract Probability Distribution
    
    properties(Abstract = true)
        params;   % struct storing the models parameters
    end
    
    methods(Abstract = true)
        logprob;  % p(i) = log(p(D(i)|params)) - semantics altered by ProductDist
        sample;
    end
    
    methods
        function cellArray = copy(model,n)
        % Copy the model n times and return copies in a cell array    
           cellArray = num2cell(repmat(model,n,1)); 
        end
    end
    
end

