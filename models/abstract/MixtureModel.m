classdef MixtureModel < LatentVarModel

    
    properties
       fitEng;
       mixtureComps;
       mixingDist;
       dof;
	   ndimensions;
	   ndimsLatent;  
    end
      
    methods
        
        function model = MixtureModel(varargin)
            if nargin == 0; return; end
            [nmixtures , template , model.mixingDist , model.mixtureComps, model.fitEng] = processArgs(varargin,...
                '-nmixtures'    , 2                  ,...
                '-template'     , []                 ,...
                '-mixingDist'   , []                 ,...
                '-mixtureComps' , {}                 ,...
                '-fitEng'       , MixModelEmFitEng()  );
            
            if isempty(model.mixtureComps)
                model.mixtureComps = copy(template,nmixtures);
            else
                nmixtures = numel(model.mixtureComps);
            end
            if isempty(model.mixingDist)
                model.mixingDist = DiscreteDist(normalize(rand(nmixtures,1))); 
            end
            model = initialize(model);
        end
       
        function model = fit(model,varargin)
           model = fit(model.fitEng,model,varargin{:}); 
           model = initialize(model);
        end
        
        function [ph,LL] = inferLatent(model,D)
        % ph(i,k) = p(H=k | D(i),params) a DiscreteDist
        % This is the posterior responsibility of component k for data i
        % LL(i) = log p(D(i) | params)  is the log normalization constat
            logRik = calcResponsibilities(model, D.X);
            [Rik, LL] = normalizeLogspace(logRik);
            Rik = exp(Rik);
            ph = DiscreteDist('-T',Rik');
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
        
        function L = logPdf(model,D)
        % L(i) = log p(D(i) | params) = log sum_k p(D(i), h=k | params)
            L = logsumexp(calcResponsibilities(model, D.X),2);
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
        function model = initialize(model) % not the same as initEm
            model.dof = model.mixingDist.dof - 1 + numel(model.mixtureComps)*model.mixtureComps{1}.dof;
            model.ndimsLatent = model.mixingDist.ndimensions;
            model.ndimensions = model.mixtureComps{1}.ndimensions;
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
    
    
    properties(Hidden = true)
    % required by super class but unused
        params;
        prior;
    end
    
    
end



