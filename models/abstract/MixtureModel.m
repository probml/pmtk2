classdef MixtureModel < LatentVarModel

    
    properties
       fitEng;
       mixtureComps;
       mixingDist;
       dof;
	   ndimensions;
	   ndimsLatent;
       params;
       prior;
    end
    
    
    
    methods
       
        function model = fit(model,varargin)
           model = fit(model.fitEng,model,varargin{:}); 
           model = initialize(model);
        end
        
        function [L,logz] = inferLatent(model,D) 
            [r,logz] = logPdf(model,D);
            L = DiscreteDist(r');
        end
        
        function C = computeMapLatent(model,D) 
            C = mode(inferLatent(model,D));
        end
       
        function L = logPrior(model)
             L = 0;
            for k=1:numel(model.mixtureComps);
                L = L + sum(logPrior(model.mixtureComps{k}));
            end
            L = L + logPrior(model.mixingDist);
        end
        
		function [L,logZ] = logPdf(model,D)
            [L,logZ] = normalizeLogspace(logsumexp(calcResponsibilities(model, D.X),2));
		end

        function [Y, H] = sample(model,nsamples)
        % Y(i,:) = i'th sample of observed nodes
        % H(i) = i'th sample of hidden node
            if nargin < 2, nsamples = 1; end
            H = sample(model.mixingDist, nsamples);
            d = model.ndimensions;
            Hcanon = canonizeLabels(H,model.mixingDist.support);
            Y = zeros(nsamples, d);
            for i=1:nsamples
                Y(i,:) = rowvec(sample(model.mixtureComps{Hcanon(i)}));
            end
        end
        
        function SS = mkSuffStat(model,data,weights)
            if(nargin < 2), weights = ones(size(data,1)); end
            logRik = calcResponsibilities(model,data);
            gamma2 = exp(normalizeLogspace(bsxfun(@plus,logRik,log(weights+eps)))); % combine alpha,beta,local evidence - see qe 13.109 in pml24nov08.pdf
            nmixtures = numel(model.mixtureComps);
            ess = cell(nmixtures,1);
            for k=1:nmixtures
                ess{k} = model.mixtureComps{k}.mkSuffStat(DataTable(data),gamma2(:,k));
            end
            SS.ess = ess;
            SS.weights = gamma2;
        end
   
    end
    
    methods(Access = 'protected')
        function model = initialize(model)
        % override in subclass (not the same as initEm!)    
        end
        
        function logRik = calcResponsibilities(model,data)
        % logRik(i,k) propto log p(data(i,:), hi=k | params)
            n = size(data,1); nmixtures = numel(model.mixtureComps);
            logRik = zeros(n,nmixtures);
            mixWeights = pmf(model.mixingDist);
            for k=1:nmixtures
                logRik(:,k) = log(mixWeights(k)+eps) + logPdf(model.mixtureComps{k},DataTable(data));
            end 
        end
    end
end

