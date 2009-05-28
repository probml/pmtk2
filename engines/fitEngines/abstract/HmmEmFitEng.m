classdef HmmEmFitEng < EmFitEng
  
    methods(Access = 'protected')
       
        function ess = eStep(eng,model,data) %#ok
            data = DataSequence(data);
            [stackedData , seqndx] = stackData(data);
            nstates = model.nstates;
            pi      = zeros(nstates,1);
            trans   = zeros(nstates,nstates);
            weights = zeros(size(stackedData,1),nstates);
            
            for j=1:ncases(data)
                stats = inferLatent(model,Query({1,'singles','pairs'}),data(j)); 
                [firstSlice,gamma,xi_summed] = deal(stats{:});
                pi = pi + colvec(firstSlice);
                trans = trans + xi_summed;
                ndx = seqndx(j):seqndx(j)+size(gamma,2)-1; 
                weights(ndx,:) = weights(ndx,:) + gamma';  
            end
            
            eDists = model.params.emissionDists;
            eStats = cell(nstates,1);
            for k=1:nstates
                eStats{k} = mkSuffStat(eDists{k},DataTable(stackedData),weights(:,k));
            end
            ess.pi.counts    = pi;
            ess.trans.counts = trans;
            ess.obs          = eStats;
        end
        
        function [model,success] = mStep(eng,model,ess) %#ok
            [model.prior            , ps] = fit(model.prior            ,'-suffStat' ,ess.pi    );
            [model.params.transDist , ts] = fit(model.params.transDist ,'-suffStat' ,ess.trans );
            eDists = model.params.emissionDists;
            eStats = ess.obs;
            eSuccess = false(model.nstates,1);
            for k=1:model.nstates
                [eDists{k},eSuccess(k)] = fit(eDists{k},'-suffStat',eStats{k});
            end
            model.params.emissionDists = eDists;
            success = ps && ts && all(eSuccess);
        end
        
        function  model = initEm(eng,model,data) %#ok
             
            X = stackData(DataSequence(data)); % ignore temporal structure
            n = size(X,1);
            nstates = model.nstates;
            batchSize = floor(n/nstates);
            if(batchSize < 2), batchSize = n;end
            eDists = model.params.emissionDists;
            for i=1:nstates
               eDists{i} =  fit(eDists{i},'-data',DataTable(X(sub(randperm(n),1:batchSize),:)));
            end
            model.params.emissionDists = eDists;
            
            % don't want to hard code distribution types here so we fit on
            % random data instead.
            priorSupport = model.prior.support;
            D = DataTable(colvec(priorSupport(randint(100,1,1:numel(priorSupport)))));
            model.prior = fit(model.prior,D);
            transSupport = model.params.transDist.support;
            D = DataTable(transSupport(randint(100,nstates,[1,numel(transSupport)])));
            model.params.transDist = fit(model.params.transDist,D); 
        end
    end
end

