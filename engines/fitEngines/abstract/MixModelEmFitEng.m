classdef MixModelEmFitEng < EmFitEng
    
    methods(Access = 'protected')
        function model = initEm(eng,model,data) %#ok
         % override to do something more intelligent, i.e. kmeans for a GMM etc.  
         % Here we just fit each mixture component on a random partition of
         % the data. 
            K = length(model.mixtureComps);
            n = size(data,1);
            ss.counts = rand(1,K);
            model.mixingDist = fit(model.mixingDist,'-suffStat',ss);
            perm = randperm(n);
            batchSize = max(1,floor(n/K));
            for k=1:K
                start = (k-1)*batchSize+1;
                initdata = data(perm(start:start+batchSize-1),:);
                model.mixtureComps{k} = fit(model.mixtureComps{k},'-data',DataTable(initdata));
            end 
        end
        
        function ess = eStep(eng,model,data) %#ok
            data = DataTable(data);
            Rik  = pmf(inferLatent(model, data));
            K = length(model.mixtureComps);
            compSS = cell(1,K);
            for k=1:K
                compSS{k} = mkSuffStat(model.mixtureComps{k},data,Rik(:,k));
            end
            ess.compSS = compSS;
            ess.counts = colvec(normalize(sum(Rik,1)));
        end
        
        function  [model,success] = mStep(eng,model,ess) %#ok
            K = numel(model.mixtureComps);
            successArray = false(K,1);
            for i=1:K
                [model.mixtureComps{i},successArray(i)] = fit(model.mixtureComps{i},'-suffStat',ess.compSS{i}); 
            end
            mixSS.counts = ess.counts;
            [model.mixingDist,mixSuccess] = fit(model.mixingDist,'-suffStat',mixSS);
            success = all(successArray) && mixSuccess;
        end
    end
end

