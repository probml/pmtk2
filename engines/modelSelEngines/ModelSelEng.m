classdef ModelSelEng
    
    
    properties
        fittedModels;
        modelScores;
    end
    
    
    methods
        
        function eng = fitManyModels(eng,baseModel,D)
            
        end
        
        function model = selectModel(eng)
            
        end
        
        
    end
    
    
    
    methods(Access = 'protected')
        
        function [models, bestNdx,  NLLmean, NLLse] = selectCV(ML, D)
            Nfolds = ML.nfolds;
            Nx = ncases(D);
            randomizeOrder = true;
            [trainfolds, testfolds] = Kfold(Nx, Nfolds, randomizeOrder);
            NLL = [];
            complexity = [];
            for f=1:Nfolds % for every fold
                if ML.verbose, fprintf('starting fold %d of %d\n', f, Nfolds); end
                Dtrain = D(trainfolds{f});
                Dtest = D(testfolds{f});
                models = fitManyModels(ML, Dtrain);
                Nm = length(models);
                for m=1:Nm
                    complexity(m) = dof(models{m}); %#ok
                    nll = ML.costFnForCV(models{m}, Dtest); %logprob(models{m}, Dtest);
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
            ML.models = models;
            models = fitManyModels(ML, D);
            %bestModel = models{bestNdx};
        end
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    end
    
    
    
end