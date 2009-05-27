classdef HmmEmFitEng < EmFitEng
    
    
    
    
    
    methods(Access = 'protected')
        
        
        function ess = eStep(eng,model,data) %#ok
            
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
                eStats{k} = mkSuffStat(eDists{k},stackedData,weights(:,k));
            end
            ess.pi.counts    = pi;
            ess.trans.counts = trans;
            ess.obs          = emissionStats;
        end
        
        
        function [model,success] = mStep(eng,model,ess) %#ok
            [model.prior            , ps] = fit(model.prior            ,'-suffStat' ,ess.pi    );
            [model.params.transDist , ts] = fit(model.params.transDist ,'-suffStat' ,ess.trans );
            eDists = model.params.emissionDists;
            eStats = ess.obs;
            eSuccess = false(nstates,1);
            for k=1:model.nstates
                [eDists{k},eSuccess(k)] = fit(eDists{k},'-suffStat',eStats{k});
            end
            model.params.emissionDists = eDists;
            success = ps && ts && all(eSuccess);
        end
        
        
        
    end
    
    
end

