classdef MultiStudentDist < MultivarDist
    
%#TODO - conditional and marginal methods are at the bottom - protected. 
% these should be added to an infEng and infer and computeFunPost methods
% should be added to this class. 
    
    properties
        
        ndimensions;
        params;
        prior;
        
    end
    
    
    methods
        
        function model = MultiStudentDist(varargin)
            [model.params.dof,model.params.mu,model.params.Sigma] = processArgs(varargin,'-dof',[],'-mu',[],'-Sigma',[]);
            model.ndimensions = length(model.mu);
        end
        
        
        function scalarModel = convertToScalarDist(model)
            if model.ndimensions ~= 1, error('cannot convert to scalarDst'); end
            scalarModel = StudentDist(model.params.dof, model.params.mu, model.params.Sigma);
        end
        
        
        
        
        function C = cov(model)
            dof = model.params.dof;
            C = (dof/(dof-2))*model.params.Sigma;
        end
        
        
        function entropy(model,varargin)
            %
            notYetImplemented('MultiStudentDist.entropy()');
        end
        
        
        function fit(model,varargin)
            %
            notYetImplemented('MultiStudentDist.fit()');
        end
        
        
        function L = logPdf(model, D)
            % L(i) = log p(X(i,:) | params)
            X = D.X;
            mu = rowvec(model.params.mu); % ensure row vector
            if length(mu)==1
                X = colvec(X); % ensure column vector
            end
            [N d] = size(X);
            if length(mu) ~= d
                error('X should be N x d')
            end
            
            M = repmat(mu, N, 1); % replicate the mean across rows
            if isnan(model.params.Sigma) || model.params.Sigma==0
                L = repmat(NaN, N, 1);
            else
                mahal = sum(((X-M)*inv(model.params.Sigma)).*(X-M),2);
                v = model.params.dof;
                L = -0.5*(v+d)*log(1+(1/v)*mahal) - lognormconst(model);
            end
        end
        
        
       
        
        
        function m = mean(model)
            m = model.params.mu;
        end
        
        
        function m =  mode(model)
            m = model.params.mu;
        end
        
        
        function plotPdf(model,varargin)
            %
            notYetImplemented('MultiStudentDist.plotPdf()');
        end
        
        
        function X = sample(model,n)
            % X(i,:) = sample for i=1:n
            if statstoolboxInstalled
                X = mvtrnd(model.params.Sigma, model.params.dof, n) + repmat(model.params.mu,n,1);
            else
                R = chol(model.params.Sigma);
                X = repmat(mean(model)', n, 1) + (R'*trnd(model.params.dof, d, n))';
            end
        end
        
        
        function v = var(model)
            v = diag(model.params.Sigma);
        end
        
        
    end
    
    
    
    methods(Access = 'protected')
        
        function logZ = lognormconst(model)
            d = model.ndimensions;
            v = model.params.dof;
            logZ = -gammaln(v/2 + d/2) + gammaln(v/2) + 0.5*logdet(model.params.Sigma) ...
                + (d/2)*log(v) + (d/2)*log(pi);
        end
        
        
        % These should really be added to an inference engine
         
        function mm = marginal(model, queryVars)
            % p(Q)
           
            d = model.ndimensions;
            if d == 1, error('cannot compute marginal of a 1d rv'); end
            mu = mean(model); C = cov(model);
            dims = queryVars;
            mm = MvtDist(model.params.dof, mu(dims), C(dims,dims));
            if length(dims)==1
                mm = convertToScalarDist(mm);
            end
        end
        
        function mm = conditional(m, visVars, visValues)
            % p(Xh|Xvis=vis)
           
            d = model.ndimensions;
            if d == 1, error('cannot compute conditional of a 1d rv'); end
            % p(Xa|Xb=b)
            b = visVars; a = setdiff(1:d, b);
            dA = length(a); dB = length(b);
            if isempty(a)
                muAgivenB = []; SigmaAgivenB  = [];
            else
                mu = m.params.mu(:);
                xb = visValues;
                SAA = Sigma(a,a); SAB = Sigma(a,b); SBB = Sigma(b,b);
                SBBinv = inv(SBB);
                muAgivenB = mu(a) + SAB*SBBinv*(xb-mu(b));
                h = 1/(m.params.dof+dB) * (m.params.dof + (xb-muB)'*SBBinv*(xb-mu(b)));
                SigmaAgivenB = h*(SAA - SAB*SBBinv*SAB');
            end
            mm = MvtDist(m.params.dof + dA, muAgivenB, SigmaAgivenB);
        end
        
        
        
        
        
        
        
        
        
        
    end
    
    
    
    
    
    properties(Hidden = true)
        dof; % required by super class, but confusing not to use model.param.dof version
    end
    
    
    
    
    
end

