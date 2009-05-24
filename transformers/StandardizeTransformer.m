classdef StandardizeTransformer < Transformer
    
    properties
        mu; sigma;
        saveParams;
    end
    
    %%  Main methods
    methods
        function obj = StandardizeTransformer(saveParams)
            % if saveParams = true, we standardize the test set using
            % the parameters computed on the training set;
            % otherwise we use the test set params.
            if nargin == 0, saveParams = true; end
            obj.mu=[];
            obj.saveParams = saveParams;
        end
        
        function [Xnew, obj] = trainAndApply(obj, X)
            [Xnew, obj.mu]= center(X);
            [Xnew, obj.sigma] = mkUnitVariance(Xnew);
        end
        
        function [Xnew] = apply(obj, X)
            if obj.saveParams
                [Xnew]= center(X, obj.mu);
                [Xnew] = mkUnitVariance(Xnew, obj.sigma);
            else
                [Xnew]= center(X);
                [Xnew] = mkUnitVariance(Xnew);
            end
        end
        
    end
    
end