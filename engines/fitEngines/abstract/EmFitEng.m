classdef EmFitEng < FitEng
    
    properties
    end
    
    properties(Access = 'protected', Abstract = true)
       nrestarts;
       convTol;
       maxIter;
    end
    
    methods(Access = 'protected', Abstract = true)
        initEm;
        eStep;
        mStep;
    end
    
    methods
       
        function [eng,success,diag] = fit(eng,varargin)
            notYetImplemented('EmEng.fit');
        end
    end
    
    methods(Access = 'protected')
        
        function [converged,success] = checkConvergence(eng)
           notYetImplemented('EmFitEng.checkConvergence'); 
        end
        
        function displayProgress(eng)
           notYetImplemented('EmFitEng.checkConvergence');
        end
        
        function [eng,cont,success] = handleMstepFailure(prevEng,probEng)
            eng = prevEng;
            cont = true;
            success = true;
        end
        
        function [eng,success] = fitOnce(eng,varargin)
            eng = initEm(eng,varargin);
            [converged,success] = checkConvergence(eng);
            while not(converged)
                [eng,ess] = eStep(eng);
                [tmpEng,mSuccess] = mStep(eng,ess);
                if mSuccess
                    eng = tmpEng;
                else
                    [eng,cont,success] = handleMstepFailure(eng,tmpEng);
                    if ~cont, break; end
                end
                if verbose, eng.displayProgress; end
                [converged,success] = checkConvergence(eng);
            end
        end
        
    end
end

