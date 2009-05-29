classdef MvnInvWishartDist < MultivarDist
    
    
    
    properties
        
        ndimensions;
        params;
        prior = NoPrior();
        
    end
    
    
    methods
        
        function model = MvnInvWishartDist(varargin)
            [model.params.mu, model.params.Sigma, model.params.dof, model.params.k,model.ndimensions]...
                = processArgs(varargin,'-mu',[],'-Sigma',[],'-dof',[],'-k',[],'-ndimensions',[]);
            model = initialize(model);
        end
        
        function L = logPdf(model,mu,Sigma)
            if(nargin == 2) % as in logprob(obj,X) used by plot % vectorized w.r.t. both mu and Sigma
                X = mu;
                mu = X(:,1);
                if(size(X,2) ~= 2)
                    error('MvnInvWishartDist.logprob(obj,X) syntax only supported when X(:,1) = mu and X(:,2) = Sigma. Use logprob(obj,mu,Sigma) instead.');
                end
                piw = InvWishartDist(model.params.dof, model.params.Sigma);
                N = size(X,1);
                L = zeros(N,1);
                pgauss = MvnDist(model.params.mu,[]);  % faster not to recreate the object each iteration
                k = obj.k;
                for i=1:N
                    Sigma = X(i,2);
                    pgauss.params.Sigma = Sigma/k; % invalid - X may be negative
                    L(i) = logPdf(pgauss,mu(i)) + logPdf(piw,Sigma);
                end
            else
                pgauss = MvnDist(model.params.mu, Sigma/model.params.k);
                piw = InvWishartDist(model.params.dof, model.params.Sigma);
                L = logPdf(pgauss, mu(:)') + logPDf(piw, Sigma);
            end
        end
        
        function [m,S] = sample(model,n)
            if (nargin < 2), n = 1; end;
            mu = model.params.mu; k = model.params.k;
            d = length(mu);
            m = zeros(n,d);
            SigmaDist = InvWishartDist(model.params.dof, model.params.Sigma);
            S = sample(SigmaDist,n);
            for s=1:n
                m(s,:) = sample(MvnDist(mu, S(:,:,s) / k),1);
            end
        end
       
        function [mu,Sigma] = mode(model)
            d = size(obj.Sigma,1);
            mu = model.params.mu;
            Sigma = model.params.Sigma / (model.params.dof + d + 2);
        end
        
        function mm = marginal(model, Q)
            queryVar = Q.variables; assert(ischar(queryVar));
            switch lower(queryVar)
                case 'sigma'
                    d = size(model.params.Sigma,1);
                    if d==1
                        mm = InvGammaDist(model.params.dof/2, model.params.Sigma/2);
                    else
                        mm = InvWishartDist(model.params.dof, model.params.Sigma);
                    end
                case 'mu'
                    d = length(model.params.mu);
                    v = model.params.dof;
                    if d==1
                        mm = StudentDist(v, model.params.mu, model.params.Sigma/(model.params.k*v));
                    else
                        mm = MultiStudentDist(v-d+1, model.params.mu, model.params.Sigma/(model.params.k*(v-d+1)));
                    end
                otherwise
                    error(['unrecognized variable ' queryVar])
            end
        end
            
        function cov(model,varargin)
            %
            notYetImplemented('MvnInvWishartDist.cov()');
        end
        
        function mean(model,varargin)
            %
            notYetImplemented('MvnInvWishartDist.mean()');
        end
         
        function plotPdf(model,varargin)
            %
            notYetImplemented('MvnInvWishartDist.plotPdf()');
        end
           
        function var(model,varargin)
            %
            notYetImplemented('MvnInvWishartDist.var()');
        end
        
        function fit(model,varargin)
           notYetImplemented('MvnInvWishartDist.fit()'); 
        end
        
        function entropy(model,varargin)
            notYetImplemented('MvnInvWishartDist.entropy()');
        end
    end
    
    methods(Access = 'protected')
        
        function model = initialize(model)
            if isempty(model.ndimensions)
                model.ndimensions = length(model.params.mu);
            end
            if isempty(model.params.k)
                model.params.k = model.ndimensions;
            end
            if isempty(model.params.mu)
                model.params.mu = zeros(1,model.ndimensions);
            end
            if isempty(model.params.Sigma)
               model.params.Sigma = eye(model.ndimensions); 
            end
            if isempty(model.params.dof)
                model.params.dof = model.params.k + 1;
            end
        end
        
    end
    
    properties(Hidden = true)
        dof; % required by super class, but confusing not to use model.params.dof field
    end
    
end

