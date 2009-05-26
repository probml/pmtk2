classdef LogRegL2FitEng < LogRegFitEng
      
    properties
        verbose;
    end
    
    methods
        
        function eng = LogRegL2FitEng(varargin)
            [eng.verbose,eng.optMethod] = processArgs(varargin,'-verbose',true,'-optMethod','lbfgs');
        end
    end
    
    methods(Access = 'protected')
        
        function [w, dof, output] = fitCore(eng, model, X, Y1, winit)
            objective = @(w,varargin)LogRegFitEng.multinomLogregNLLGradHessL2(w, X, Y1, model.lambda, model.addOffset);
            options.Method = eng.optMethod;
            options.Display = eng.verbose;
            [w, f, exitflag, output] = minFunc(objective, winit, options);
            dof = []; 
        end
        
        
    end
end


