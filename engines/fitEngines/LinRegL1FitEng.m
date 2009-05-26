classdef LinRegL1FitEng < CondModelFitEng
    
    
    
    properties
        
        diagnostics;
        method;
        verbose;
    end
    
    
    methods
        
        function eng =  LinRegL1FitEng(varargin)
            [eng.method,eng.verbose] = processArgs(varargin,'-method','-shooting','-verbose',true);
        end
        
        
    end
    
    
    methods(Access = 'protected')
        
        function [w,dof] = fitCore(eng,model,XC,yC)
            switch lower(eng.method)
                case 'shooting'
                    w = LassoShooting(XC, yC, model.lambda, 'offsetAdded', false);
                case 'l1_ls'
                    w = l1_ls(XC, yC, model.lambda, 1e-3, true);
                otherwise
                    error('%s is not a supported L1 algorithm', eng.method);
            end
            dof = nnz(w); % number of non-zero elements in w
        end
    end
end

