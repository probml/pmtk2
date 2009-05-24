classdef PcaTransformer < Transformer
    
    
    properties
        k;                  % the dimensionality of the principle components
        basisVectors;
        evals;
        mu;                 % mean(Xtrain)
        method = 'default'; % one of {'default', 'eigCov', 'eigGram', 'svd'}
    end
    
    
    methods
        
        function obj = PcaTransformer(varargin)
            if nargin ==0; return; end
            [obj.k, obj.method] = processArgs(varargin, '-k', [], '-method', 'default');
        end
        
        function [Xlow,obj] = trainAndApply(obj,X)
            if(isempty(obj.k))
                obj.k = min(size(x));
            end
            obj.mu = mean(X);
            X = bsxfun(@minus,X,obj.mu);
            [obj.basisVectors, Xlow, obj.evals] = pcaPmtk(X, obj.k, obj.method, false);
        end
        
        function Xnew = apply(obj,X)
            X = bsxfun(@minus,X,obj.mu);
            Xnew = X*obj.basisVectors;
        end
        
    end
    
    
    
    
end