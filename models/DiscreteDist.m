classdef DiscreteDist < ScalarDist & ParallelizableDist

	properties

		dof;
		params;              % params.T stored as nstates-by-ndistributions
		prior; 
        support;

	end

	methods

		function model = DiscreteDist(varargin)
		    [model.params.T , model.support , model.prior] = processArgs(varargin,...
                '-T',[],'-support',[],'-prior',NoPrior());
            model = initialize(model);
        end

        function M = pmf(model)
           M = model.params.T'; 
        end

        function [model,success] = fit(model,varargin)
            [X, SS] = processArgs(varargin,'-data', [],'-suffStat', []);
            if isempty(SS), SS = mkSuffStat(model, X); end
            d = size(SS.counts,2);
            switch class(model.prior)
                case 'NoPrior'
                    model.params.T = normalize(SS.counts,1);
                case 'DirichletDist'
                    pseudoCounts = repmat(model.prior.params.alpha(:),1,d);
                    model.params.T = normalize(SS.counts + pseudoCounts -1, 1);
                otherwise
                    error('unknown prior ')
            end
            if nargout == 2
                T = model.params.T;
               success = approxeq(sum(T,1),ones(1,size(T,2))) ;
            end
            model = initialize(model);
        end

        function [L,LL] = logPdf(model,D)
            X = canonizeLabels(D.X,model.support);
            LL = log(model.params.T(X,:));
            L = sum(LL,2);
        end
            
        function L = logPrior(model)
            switch class(model.prior)
                case 'NoPrior'
                   L = 0;
                otherwise
                   L = logPdf(model.prior, model.T);    
            end            
        end
        
        function H = entropy(model)
			 T = model.params.T;
             safeT = T; safeT(T==0)=1;
             H = -sum(T .* log(safeT),1);
        end
        
        function SS = mkSuffStat(model, D,weights)
            X = D.X;
            K = numel(model.support);
            d = size(X,2);
            counts = zeros(K, d);
            if(nargin < 3)
                for j=1:d
                    counts(:,j) = colvec(histc(X(:,j), model.support));
                end
            else
                if size(weights,2) == 1
                    weights = repmat(weights,1,d);
                end
                for j=1:d
                    for s=1:K 
                        counts(s,j) = sum(weights(X(:,j) == model.support(s),j));
                    end
                end
            end
            SS.counts = counts;
        end
        
		function y = mode(model)
             y = colvec(obj.support(maxidx(model.params.T,[],1)));
        end

        function h = plotPdf(model,varargin)
            d = size(model.params.T,2);
            h = zeros(d,1);
            for i=1:d
                h(i) = bar(model.params.T(:,i),varargin{:});
                set(gca,'xticklabel',obj.support);
            end
        end

        function S = sample(model,n)
            if nargin < 2, n = 1; end
            d = size(model.params.T,2);
            S = zeros(n, d);
            for j=1:d
                p = model.params.T(:,j);
                cdf = cumsum(p);
                [dum, y] = histc(rand(n,1),[0 ;cdf]);
                S(:,j) = model.support(y);
            end
        end
        
		function v = var(model)
            T = model.params.T;
            v = T.*(1-T);
        end
 
        function m = mean(model)
            % E(X) = sum_i(x_i*p(x_i)) 
            % If we used a one-of-k encoding for X, E(X) would just be T,
            % but in this model, X takes on values in model.support. For
            % the Bernoulli subclass with support [0,1], the two
            % representations are equivalent.
            m = sum(bsxfun(@times,colvec(model.support),model.params.T));
        end

    end
    
    methods(Access = 'protected')
        function model = initialize(model)
            if isvector(model.params.T), model.params.T = colvec(model.params.T); end
            if ~isempty(model.params.T)
               model.dof = size(model.params.T,1) - 1;
               if isempty(model.support)
                    model.support = 1:size(model.params.T,1);
               end
           end  
        end 
    end
end

