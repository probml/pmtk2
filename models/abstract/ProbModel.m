classdef ProbModel
% An abstract probability model
    
    methods(Abstract = true)
        sample;
        logpdf;
        fit;
        dof;
        entropy;           
        mean;        
        mode;
        var;
        cov;
        marginal;
        ndimensions;
    end
    
    
    methods
        
        function D = impute(model,D,Q)
          notYetImplemented('ProbModel.impute()');
        end
        
        function lp = logprior(model)
           lp = 0; 
        end
        
        function J = penNLL(model,D)
            J = -sum(logpdf(model,D)) - logprior(model);
        end
        
        function display(model,varargin)
           if nargin < 2
              disp(model); 
           end
        end
        
        function cellArray = copy(dist,n)
            % Copy the model n times and return copies in a cell array
            cellArray = num2cell(repmat(dist,n,1));
        end
        
    end
    
end

