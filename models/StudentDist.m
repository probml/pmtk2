classdef StudentDist < ScalarDist
    
    
    
    properties
        params;
        prior;
    end
    
    
    methods
        
        function model = StudentDist(varargin)
            [model.params.mu,model.params.Sigma2,model.params.dof] = processArgs(varargin,'-mu',[],'-Sigma2',[],'-dof',[]);
        end
        
        function [l,u] = credibleInterval(model, p)
            if nargin < 2, p = 0.95; end
            alpha = 1-p;
            sigma = sqrt(var(model));
            mu = model.params.mu;
            nu = model.params.dof;
            l = mu + sigma.*tinv(alpha/2, nu);
            u = mu + sigma.*tinv(1-(alpha/2), nu);
        end
        
        
        
        function entropy(model,varargin)
            %
            notYetImplemented('StudentDist.entropy()');
        end
        
        
        function model = fit(model,varargin)
            % Finds the MLE. Needs stats toolbox.
            D = processArgs(varargin,'+-data',DataTable());
            X = D.X;
            assert(statsToolboxInstalled); %#statsToolbox
            P = mle(X, 'distribution', 'tlocationscale');
            model.params.mu = P(1);
            model.params.sigma2 = P(2);
            model.params.dof = P(3);
        end
        
        
        function [L,logZ] = logPdf(model,D)
            X = D.X;
            N = ncases(D);
            v = model.params.dof; mu = model.params.mu; s2 = model.params.sigma2;
            logZ = lognormconst(model);
            M = repmat(rowvec(mu), N, 1);
            S2 = repmat(rowvec(s2), N, 1);
            V = repmat(rowvec(v), N, 1);
            LZ = repmat(rowvec(logZ), N, 1);
            Lij = (-(V+1)/2) .* log(1 + (1./V).*( (X-M).^2 ./ S2 ) ) - LZ;
            L = sum(Lij,2);
        end
        
        
        function m = mean(model)
            m = model.params.mu;
        end
        
        
        function m =  mode(model)
            m = model.params.mu;
        end
        
        function X = sample(model,n)
            % X(i,j) = sample ffrom params(j) i=1:n
            
            assert(statsToolboxInstalled); %#statsToolbox
            X = zeros(n, d);
            for j=1:d
                mu = repmat(model.params.mu(j), n, 1);
                X(:,j) = mu + sqrt(model.params.sigma2(j))*trnd(model.params.dof(j), n, 1);
            end
        end
        
        
        function v = var(model)
            dof = model.params.dof;
            v = (dof./(dof-2)).*model.params.sigma2;
        end
        
        
        function h=plot(model, varargin)
            sf = 2;
            m = mean(model); v = sqrt(var(model));
            xrange = [m-sf*v, m+sf*v];
            [plotArgs, npoints, xrange, useLog] = processArgs(...
                varargin, '-plotArgs' ,{}, '-npoints', 100, ...
                '-xrange', xrange, '-useLog', false);
            xs = linspace(xrange(1), xrange(2), npoints);
            p = logPdf(model, DataTable(xs(:)));
            if ~useLog, p = exp(p); end
            h = plot(colvec(xs), colvec(p), plotArgs{:});
        end
        
    end
    
    methods(Access = 'protected')
        
        function logZ = lognormconst(model)
            v = model.params.dof;
            logZ = -gammaln(v/2 + 1/2) + gammaln(v/2) + 0.5 * log(v .* pi .* model.params.sigma2);
        end
        
    end
    
    
    properties(Hidden = true)
        dof; % required by super class, but confusing not to use model.param.dof version
    end
    
    
end

