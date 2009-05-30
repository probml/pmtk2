classdef EmFitEng < FitEng
% Abstract EM Fitting Engine
    
    properties
        diagnostics;
        verbose = true;
    end
    
    properties(Access = 'protected')
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
        
        function [model,success,eng] = fit(eng,model,varargin)
            % Generic fit function, just specify initEm,eStep,mStep in subclass.
            [data,eng.nrestarts,eng.convTol,eng.maxIter] = processArgs(varargin,'*-data',DataTable(),'-nrestarts',3,'-convTol',0.01,'-maxIter',30);
            X = unwrap(data);
            models = cell(eng.nrestarts,1);
            successArray = false(eng.nrestarts,1);
            diagnArray = cell(eng.nrestarts,1);
            for i=1:eng.nrestarts
                if eng.verbose,fprintf('random restart\n');end
                [models{i},successArray(i),diagnArray{i}] = fitOnce(eng,model,X);
            end
            [model,idx] = selectModel(eng,models,successArray,diagnArray);
            success = successArray(idx);
            eng.diagnostics = diagnArray{idx};
        end
    end
    
    methods(Access = 'protected')
        
        function [model,success,diagn] = fitOnce(eng,model,data)
            model = initEm(eng,model,data);
            prevLL = -realmax; converged = false;
            diagn.LL = prevLL;
            iter = 1;
            while not(converged) && iter < eng.maxIter
                ess = eStep(eng,model,data);
                [tmpModel,success] = mStep(eng,model,ess); 
                [converged,diagn,convSuccess] = checkConvergence(eng,model,data,diagn);
                if success && convSuccess
                    model = tmpModel;
                else
                    [model,cont,success] = handleMstepFailure(eng,model,tmpModel);
                    if ~cont, break; end
                end
                displayProgress(eng,success,diagn);
            end
            if iter >=eng.maxIter && eng.verbose, fprintf('Maximum number of iterations reached\n'); end
            diagn.converged = converged;
            diagn.niter = iter;
        end
        
        function [model,cont,success] = handleMstepFailure(eng,prevModel,probModel) %#ok
            % By default, just return the previous model and stop. Override,
            % to do something more involved.
            model = prevModel; cont = false; success = false;
            if eng.verbose
               warning('EMfitEng:fitFailure','Fitting one of the mixture components failed, reverting to previous component\n'); 
            end
        end
        
        function  [converged,diagn,success] = checkConvergence(eng,model,data,diagn)
            % Override for more involved convergence testing, if desired.
            prevLL = diagn.LL(end);
            try
                currentLL = sum(logPdf(model,wrapData(data))) + logPrior(model);
                success = true;
            catch %#ok
                success = false; 
                converged = false;
                return;
            end
            diagn.LL = [diagn.LL;currentLL];
            converged = convergenceTest(prevLL,currentLL,eng.convTol);
            if currentLL < prevLL && abs(currentLL-prevLL)/abs(currentLL) > 1e-3
                warning('EmFitEng:LLdecrease','The log likelihood has decreased from %g to %g',prevLL,currentLL);
            end
        end
        
        function displayProgress(eng,success,diagn) %#ok
            % Override to display more info
            if eng.verbose
                fprintf('LL = %g\n',diagn.LL(end));
            end
        end
        
        function [model,idx] = selectModel(eng,models,successArray,diagnArray) %#ok
            % by default, just select the model with the highest LL
            idx = sub(sortidx(cellfun(@(c)c.LL(end),diagnArray),'descend'),1);
            model = models{idx};
        end
    end
end