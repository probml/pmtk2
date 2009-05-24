classdef LogRegL2FitEng < LogRegFitEng
      
    properties(Access = 'protected')
        verbose;
    end
    
    methods
        
        function eng = LogRegL2FitEng(varargin)
            [eng.verbose,eng.optMethod] = processArgs(varargin,'-verbose',true,'-optMethod','lbfgs');
        end
    end
    
    methods(Access = 'protected')
        
        function [w, output, model] = fitCore(eng, model, X, Y1, winit)
            objective = @(w,varargin)multinomLogregNLLGradHessL2(w, X, Y1, model.lambda, model.addOffset);
            options.Method = eng.optMethod;
            options.Display = eng.verbose;
            [w, f, exitflag, output] = minFunc(objective, winit, options);
        end
        
        
    end
end


