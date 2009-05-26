classdef GaussDist < ScalarDist & ParallelizableDist
    %GAUSSDIST
    
    
    properties
        
        dof;
        params;
        prior;
        
    end
    
    
    methods
        
        function model = GaussDist(varargin)
            [model.params.mu, model.params.sigma2, model.prior] = processArgs(varargin, ...
                '-mu', [], '-sigma2', [], '-prior', NoPrior());
        end
        
        
        function entropy(model,varargin)
            %
            notYetImplemented('GaussDist.entropy()');
        end
        
        
        function model = fit(model, varargin)
            % m = fit(model, 'name1', val1, 'name2', val2, ...)
            % Arguments are
            % data - data(i,:) = case i. Fits vector of params, one per column.
            % prior - 'none' or NormInvGammDist
            % clampedMu - set to true to not update the mean
            % clampedSigma - set to true to not update the variance
            [D, prior] = processArgs(varargin, ...
                '-data',DataTable(),'-prior',NoPrior());
            X = D.X;
            switch class(prior)
                case 'NoPrior'
                    model.params.mu = mean(X);
                    model.params.sigma2 = var(X,1);
                case 'NormInvGammaDist' % MAP estimation
                    m = GaussConjDist(prior);
                    [model.params.mu, model.params.sigma2] = mode(fit(m, '-data', D));
                otherwise
                    error('unknown prior ')
            end
        end
        
        function mu = mean(m)
            mu = m.mu;
        end
        
        function mu = mode(m)
            mu = mean(m);
        end
        
        function v = var(m)
            v = m.sigma2;
        end
        
        
        function [l,u] = credibleInterval(model, p)
            if nargin < 2, p = 0.95; end
            alpha = 1-p;
            sigma = sqrt(var(model));
            mu = model.params.mu;
            l = norminv(alpha/2, mu, sigma);
            u = norminv(1-(alpha/2), mu, sigma);
        end
        
        
        function h=plot(model, varargin)
            sf = 2;
            m = mean(model); v = sqrt(var(model));
            xrange = [m-sf*v, m+sf*v];
            [plotArgs, npoints, xrange, useLog] = processArgs(...
                varargin, '-plotArgs' ,{}, '-npoints', 100, ...
                '-xrange', xrange, '-useLog', false);
            xs = linspace(xrange(1), xrange(2), npoints);
            p = logPdf(model, xs(:));
            if ~useLog, p = exp(p); end
            h = plot(colvec(xs), colvec(p), plotArgs{:});
        end
        
        
        function X = sample(model, n)
            % X(i,j) = sample from gauss(m.mu(j), m.sigma(j)) for i=1:n
            if nargin < 2, n  = 1; end
            d = length(model.params.mu);
            X = randn(n,d) .* repmat(sqrt(model.params.sigma2), n, 1) + repmat(model.params.mu, n, 1);
        end
        
        
        
        function [L,Lij] = logPdf(model,D)
            % Return col vector of log probabilities for each row of X
            % If X(i) is a scalar:
            % L(i) = log p(X(i,1) | params)
            % L(i) = log p(X(i,1) | params(i))
            % If X(i,:) is a vector:
            % Lij(i,j) = log p(X(i,j) | params(j))
            % L(i) = sum_j Lij(i,j)   (product distrib)
            X = D.X;
            [nx,nd] = size(X);
            mmu = model.params.mu; s2 = model.params.sigma2;
            d = length(mmu);
            logZ = log(sqrt(2*pi*model.params.sigma2));
            if nd==1 % scalar data
                if d==1 % replicate parameter
                    M = repmat(mmu, nx, 1); S2 = repmat(s2, nx, 1); LZ = repmat(logZ, nx, 1);
                else % one param per case
                    M = mmu(:); S2 = s2(:);  LZ = logZ(:);
                    assert(length(M)==nx);
                end
            else % vector data
                M = repmat(rowvec(mmu), nx, 1);
                S2 = repmat(rowvec(s2), nx, 1);
                LZ = repmat(rowvec(logZ), nx, 1);
            end
            Lij = -0.5*(M-X).^2 ./ S2 - LZ;
            L = sum(Lij,2);
        end
        
        
    end
    
    
end

