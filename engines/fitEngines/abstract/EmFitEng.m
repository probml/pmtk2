classdef EmFitEng < FitEng
% Abstract EM Fitting Engine
    
    properties
        diagnostics;
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
            [data,eng.nrestarts,eng.convTol,eng.maxIter] = processArgs(varargin,'+*-data',DataTable(),'-nrestarts',3,'-convTol',0.01,'-maxIter',30);
            X = data.X;
            models = cell(eng.nrestarts,1);
            successArray = false(eng.nrestarts,1);
            diagnArray = cell(eng.nrestarts,1);
            for i=1:eng.nrestarts
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
            while not(converged)
                ess = eStep(eng,model,data);
                [tmpModel,mSuccess] = mStep(eng,model,ess);
                if mSuccess, model = tmpModel;
                else
                    [model,cont,success] = handleMstepFailure(eng,model,tmpModel);
                    if ~cont, break; end
                end
                [converged,diagn] = checkConvergence(eng,model,data,prevLL,diagn);
                displayProgress(eng,success,diagn);
            end
            diagn.converged = converged;
        end
        
        function [model,cont,success] = handleMstepFailure(eng,prevModel,probModel) %#ok
            % By default, just return the previous model and stop. Override,
            % to do something more involved.
            model = prevModel; cont = false; success = false;
        end
        
        function  [converged,diagn] = checkConvergence(eng,model,data,prevLL,diagn)
            % Override for more involved convergence testing, if desired.
            currentLL = sum(logPdf(model,data));
            diagn.LL = [diagn.LL;currentLL];
            converged = convergenceTest(prevLL,currentLL,eng.convTol);
        end
        
        function displayProgress(eng,success,diagn) %#ok
            % Override to display more info if desired
            if eng.verbose
                fprintf('LL = %g\n',diagn.LL(end));
            end
        end
        
        function model = selectModel(eng,models,successArray,diagnArray) %#ok
            % by default, just select the model with the highest LL
            model = models{sub(sortidx(cellfun(@(c)c.LL(end),diagnArray),'descend'),1)};
        end
    end
end

