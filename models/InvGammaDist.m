classdef InvGammaDist < ScalarDist
    %INVGAMMADIST
    
    
    properties
        
        dof;
        params;
        prior;
        
    end
    
    
    methods
        
        function model = InvGammaDist(varargin)
            [model.params.a,model.params.b,model.prior] = processArgs(varargin,'-a',1,'-b',1,'-prior',NoPrior());
        end
        
        
        function entropy(model,varargin)
            %
            notYetImplemented('InvGammaDist.entropy()');
        end
        
        
        function fit(model,varargin)
            %
            notYetImplemented('InvGammaDist.fit()');
        end
        
        
        
        function m = mean(model)
            m = model.params.b ./ (model.params.a-1);
        end
        
        function m = mode(model)
            m = model.params.b ./ (model.params.a + 1);
        end
        
        function m = var(model)
            m = (model.params.b.^2) ./ ( (model.params.a-1).^2 .* (model.params.a-2) );
        end
        
        
        function X = sample(model, n)
            % X(i,j) = sample from params(j) for i=1:n
            d = model.ndimensions;
            X = zeros(n, d);
            for j=1:d
                v = 2*model.params.a(j);
                s2 = 2*model.params.b(j)/v;
                X(:,j) = invchi2rnd(v, s2, n, 1);
            end
        end
        
        
        function p = logPdf(model,D)
            % p(i,j) = log p(x(i) | params(j))
            X = D.X;
            d = model.ndimensions;
            x = X(:);
            n = length(x);
            p = zeros(n,d);
            logZ = lognormconst(model);
            for j=1:d
                a = model.params.a(j); b = model.params.b(j);
                p(:,j) = -(a+1) * log(x) - b./x - logZ(j);
            end
        end
        
        
        
        function c = cov(model)
            c = var(model);
        end
        
    end
    
    
    methods(Access = 'protected')
      
        function logZ = lognormconst(model)
            logZ = gammaln(model.params.a) - model.params.a .* log(model.params.b);
        end
       
    end
    
end


function xs = invchi2rnd(v, s2, m, n)
    % Draw an m*n matrix of inverse chi squared RVs, v = dof, s2=scale
    % Gelman p580
    xs = v*s2./chi2rnd(v, m, n);
    
    
end

