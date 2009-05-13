classdef ProbDist
%PROBDIST Abstract Probability Distribution

 
    methods(Abstract = true)
    % ProbDists are stateless w.r.t. evidence, all methods optionally take
    % evidence and queries. 
        entropy;           
        mean;        
        mode;
        var;
        marginal;
        ndimensions;
    end
    
    methods
        function cellArray = copy(dist,n)
        % Copy the model n times and return copies in a cell array    
           cellArray = num2cell(repmat(dist,n,1)); 
        end 
    end
    
end

