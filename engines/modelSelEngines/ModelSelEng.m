classdef ModelSelEng
    % Model Selection Engine
    
    properties
        models;
        scores;
        bestNdx;
        bestModel;
        costMean;
        costSe;
        loglik;
        penloglik;
    end
    
    properties
        selMethod;
        nfolds;
        verbose;
        CVcostFn;
    end
    
    properties(Access = 'protected')
        values;
        valueName;
        constArgs;
        fitArgs;
    end
    
    methods
        
        
        function eng = ModelSelEng(varargin)
            
            if nargin == 0; return; end
            [eng.selMethod, eng.nfolds, eng.valueName,eng.values,eng.constArgs,eng.CVcostFn, eng.verbose] = processArgs(varargin, ...
                '-selMethod'    , 'bic'                   ,...
                '-nfolds'       , 5                       ,...
                '-valueName'    , ''                      ,...
                '-values'       , {}                      ,...
                '-constArgs'    , {}                      ,...
                '-costFnForCV'  , (@(M,D) -logPdf(M,D))   ,...
                '-verbose'      , false                   );
            
            eng.valueName = ['-',eng.valueName];
            if ~iscell(eng.values), eng.values = num2cell(eng.values); end
        end
        
        
        
        function [model,success,eng] = fit(eng,baseModel,D,varargin)
            if isequal(D,'-data'),D = varargin{1}; varargin(1) = []; end
            values = eng.values;
            valueName = eng.valueName;
            constArgs = eng.constArgs;
            nvalues = numel(values);
            models = cell(nvalues,1);
            for i=1:nvalues
                models{i} = feval(class(baseModel),constArgs{:},valueName,values{i});
            end
            eng.models = models;
            eng.fitArgs = varargin;
            %[eng,success] = fitManyModels(eng,D);
            [model,success,eng] = selectModel(eng,D);
        end
        
        
    end
    
    methods(Access = 'protected')
    
        function [eng,success] = fitManyModels(eng,D)
            fitArgs = eng.fitArgs;
            if isempty(fitArgs),fitArgs = {}; end % make sure its a cell
            models = eng.models;
            Nm = length(models);
            successArray = false(Nm,1);
            for m=1:Nm
                [models{m},successArray(m)] = fit(models{m}, D,fitArgs{:});
            end
            eng.models = models;
           
            success = all(successArray);
        end
        
        function [model,success,eng] = selectModel(eng,D)
            d = ncases(D);%#ok
            switch lower(eng.selMethod)
                case 'cv', [eng, eng.bestNdx, eng.costMean, eng.costSe,success] = selectCV(eng, D);
                    
                case {'bic','aic','loglik'}
                    switch lower(eng.selMethod)
                        case 'bic'    , cp = log(d)/2;
                        case 'aic '   , cp = 1;
                        case 'loglik' , cp = 0;
                    end
                    [eng, eng.bestNdx, eng.loglik, eng.penloglik,success] = selectPenLoglik(eng, D, cp);
            end
            model = eng.models{eng.bestNdx};
        end
        
        
        
        
        function [eng, bestNdx,  NLLmean, NLLse,success] = selectCV(eng, D)
           
            Nfolds = eng.nfolds;
            Nx = ncases(D); %#ok
            randomizeOrder = true;
            [trainfolds, testfolds] = Kfold(Nx, Nfolds, randomizeOrder);
            NLL = [];
            complexity = [];
            for f=1:Nfolds % for every fold
                if eng.verbose, fprintf('starting fold %d of %d\n', f, Nfolds); end
                Dtrain = D(trainfolds{f});
                Dtest = D(testfolds{f});
                eng = fitManyModels(eng, Dtrain);
                models = eng.models;
                Nm = length(models);
                for m=1:Nm
                    complexity(m) = models{m}.dof; %#ok
                    nll = eng.costFnForCV(models{m}, Dtest); %logPdf(models{m}, Dtest);
                    NLL(testfolds{f},m) = nll; %#ok
                end
            end % f
            NLLmean = mean(NLL,1);
            NLLse = std(NLL,0,1)/sqrt(Nx);
            bestNdx = oneStdErrorRule(NLLmean, NLLse, complexity);
            %bestNdx = argmax(LLmean);
            % Now refit all models to all the data.
            % Typically we just refit the chosen model
            % but the extra cost of fitting all again is negligible since we've already fit
            % all models many times...
            [eng,success] = fitManyModels(eng, D);
            %bestModel = models{bestNdx};
        end
        
        
        function [eng, bestNdx, loglik, penLL,success] = selectPenLoglik(eng,D, penalty)
            [eng,success] = fitManyModels(eng,D);
            models = eng.models;
            Nm = length(models);
            penLL = zeros(1, Nm);
            loglik = zeros(1, Nm);
            for m=1:Nm % for every model
                loglik(m) = sum(logPdf(models{m}, D),1);
                if penalty==0
                    penLL(m) = loglik(m); % for marginal likleihood, dof not defined
                else
                    penLL(m) = loglik(m) - penalty*models{m}.dof;
                end
            end
            bestNdx = argmax(penLL);
        end
        
    end
end