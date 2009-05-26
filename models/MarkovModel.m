classdef MarkovModel < ChainModel
    
    properties
        
        dof;
        ndimensions;
        params;    % stores transitionDist
        prior;     % starting distribution
        
        
    end
    
    
    methods
        
        function model = MarkovDist(varargin) %startDist,transitionDist,support)
            [model.prior,model.params.transDist,model.support] = processArgs(varargin,'-startDist',DiscreteDist(),'-transitionDist',DiscreteDist());
        end
        
        function model = fit(model,varargin)
            D = processArgs(varargin,'-data',DataTable()); % could be DataSequence as well
            X = D.X;
            
            if isempty(model.params.transDist.support)
               model.params.transDist.support = unique(cellValues(X));
            end
            map = @(x)canonizeLabels(x,model.params.transDist.support);
            if iscell(X), model.prior = fit(model.prior,'-data',cellfun(@(c)c(1),X));
            else          model.prior = fit(model.prior,'-data',X(:,1)); end
            T = zeros(numel(support));
            if iscell(X)
                for i=1:numel(X)
                    Xi = map(X{i});
                    for j=1:length(Xi)-1
                        T(Xi(j),Xi(j+1)) = T(Xi(j),Xi(j+1)) + 1;
                    end
                end
            else
                X = map(X);
                for i=1:size(X,1);
                    Xi = X(i,:);
                    for j=1:length(Xi)-1
                        T(Xi(j),Xi(j+1)) = T(Xi(j),Xi(j+1)) + 1;
                    end
                end
            end
            SS.counts = T';
            model.transitionDist = fit(model.transitionDist,'-suffStat',SS);
        end
        
       
        
        function logp = logPdf(model,X)
            % logp(i) = log(p(X(i,:) | params)) or log(p(X{i} | params)
            map = @(x)canonizeLabels(x,model.params.transDist.support);
            if iscell(X), X = cellfun(@(c)map(c),X);
            else          X = map(X); end
            N = size(X,1);
            logp = zeros(N,1);
            logPi = log(pmf(model.prior)+eps);
            logT  = log(pmf(model.params.transDist)'+eps);
            for i=1:N
                if iscell(X),  Xi = X{i};
                else           Xi = X(i,:);   end
                nstates = numel(model.params.transDist.support);
                Njk = zeros(nstates);
                for j=1:nstates-1
                    Njk(Xi(j),Xi(j+1)) =  Njk(Xi(j),Xi(j+1)) + 1;
                end
                logp(i) = logPi(Xi(1)) + sumv(Njk.*logT,[1,2]);
            end
        end
        
        function X = sample(model,len,n)
            if nargin < 3, n = 1; end
            X = model.params.transDist.support(mc_sample(pmf(model.prior)',pmf(model.params.transDist)',len,n));
        end
        
        function pi = stationaryDistribution(model)
            K = numel(model.prior);
            T = pmf(model.params.transDist)';
            pi = DiscreteDist((ones(1,K) / (eye(K)-T+ones(K)))');
        end
        
        
    end
    
    
end

