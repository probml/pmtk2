classdef LinRegL1L2FitEng < CondModelFitEng
    
    
    
    properties
        
        diagnostics;
        verbose = true;
        method;
    end
    
    
    methods
        
        function eng = LinRegL1L2FitEng(varargin)
            [eng.method,eng.verbose] = processArgs(varargin,'-method','-lars','-verbose',true);
        end
        
    end
    
    methods(Access = 'protected')
        
        function [w,dof] = fitCore(eng,model,XC,yC)
            lambda = model.lambda;
            switch lower(eng.method)
                case 'shooting'
                    w = elasticNet(X,yC,lambda(1),lambda(2),@LassoShooting);
                case 'lars'
                    w = elasticNet(X,yC,lambda(1),lambda(2),@larsLambda);
                otherwise
                    error('%s is not a supported L1, (and hence L1L2) algorithm',algorithm);
            end
            dof = (nnz(w)/numel(w)) * dofRidge(eng,XC,model.lambda);
        end
        
        
        
    end
    
    
end

