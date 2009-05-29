classdef MvnConjDist < MvnDist & BayesModel
% Multivariate Normal Conjugate Distribution    
% Operations mean , mode , var , cov , entropy , logPdf , sample , plotPdf,
% etc are w.r.t. the predictive distribution. If this model hasn't been fit
% to data, they are w.r.t. to the prior predictive. You must specify a
% prior to use this class - currently one of MvnDist, InvWishartDist,
% MvnInvWishartDist, MvnInvGammaDist.
    
    properties
        paramDist; % always stores a distribution, (not a struct or FactoredDist - use getParamPost())
    end
    
    methods
        
        function model = MvnConjDist(varargin)
            if nargin == 0; return; end
            [model.prior,model.covType,model.ndimensions,model.params.domain,model.params.mu,model.params.Sigma] =...
                processArgs(varargin,'-prior',[],'-covType','full','-ndimensions',[],'-domain',[],'-mu',[],'-Sigma',[]);
            if isempty(model.prior)
                model.prior = MvnInvWishartDist('-ndimensions',model.ndimensions);
            end
            if isempty(model.params.domain)
                model.params.domain = 1:model.ndimensions;
            end
            if ischar(model.prior), error('the prior must be an object, not a string. The prior classes, e.g. MvnInvWishartDist should autogenerate uninformative hyper parameters - no need for mkPrior functions that take data!');end
        end
        
        function model = fit(model,varargin)
            [D,SS] = processArgs(varargin,'-data',DataTable(),'-suffStat',[]);
            if isempty(SS),SS = mkSuffStat(model,D); end
            if ~isempty(model.fitEng)
                model = fit(model.fitEng,varargin{:});
            else
                switch class(model.prior)
                    case 'MvnDist'
                        model = fitMVNprior(model,SS);
                    case 'InvWishartDist'
                        model = fitIWprior(model,SS);
                    case 'InvGammaDist'
                        model = fitIGprior(model,SS);
                    case 'MvnInvWishartDist'
                        model = fitMIWprior(model,SS);
                    case {'NoPrior','double'}  % double for []
                        error('you must specify a prior to use this class. If you want to do MLE estimation, use MvnDist instead');
                    otherwise
                        error('%s is not a supported prior',class(model.prior));
                end
            end
        end
        
        function m = marginalizeOutParams(model)
            if isempty(model.paramDist),model.paramDist = model.prior; end   
            % if we have not fit yet, marginalize out w.r.t the prior
            % instead - this is just a programming convenience to set
            % paramDist = prior, we throw the model away after computing
            % m. 
            switch class(model.prior)
                case 'MvnDist'
                    m = marginalMVNprior(model);
                case 'InvWishartDist'
                    m = marginalIWprior(model);
                case 'MvnInvGammaDist'
                    m = marginalMIGprior(model);
                case 'MvnInvWishartDist'
                    m = marginalMIWprior(model);
                case {'NoPrior','double'}  % double for []
                    error('parameters are constant!');
                otherwise
                    error('%s is not a supported prior',class(model.prior));
            end
        end
        
        function varargout = getParamPost(model,funstr)
        % optionally allow for a function of the posterior    
            if nargin < 2
                varargout = {model.paramDist}; % type depends on the prior
            else
               switch funstr
                   case 'mode'
                   varargout = cell(1,2);
                   switch class(model.paramDist)
                       case 'MvnDist'
                           varargout{1} = mode(model.paramDist);
                           varargout{2} = model.params.Sigma;
                       case {'MvnInvWishartDist','MvnInvGammaDist'}
                           varargout{1} = mode(marginal(model.paramDist,Query('mu')));
                           varargout{2} = mode(marginal(model.paramDist,Query('Sigma')));
                       case 'InvWishartDist'
                           varargout{1} = model.params.mu;
                           varargout{2} = mode(model.paramDist);
                   end
                   otherwise
                       notYetImplemented();
               end
            end
        end
        
        function m = mean(model)
           m = mean(marginalizeOutParams(model)); 
        end
        
        function m = mode(model)
           m = mode(marginalizeOutParams(model)); 
        end
        
        function v = var(model)
           v = var(marginalizeOutParams(model)); 
        end
        
        function c = cov(model)
           c = cov(marginalizeOutParams(model)); 
        end
        
        function e = entropy(model)
           e = entropy(marginalizeOutParams(model)); 
        end
        
        function l = logPdf(model,D)
           l = logPdf(marginalizeOutParams(model),D); 
        end
        
        function S = sample(model,n)
           S = sample(marginalizeOutParams(model),n);
        end
        
        function h = plotPdf(model,varargin)
            h = plotPdf(marginalizeOutParams(model),varargin{:});
        end
        
        function  M = infer(model,varargin)
            notYetImplemented();
            if isempty(model.infEng)
                error('The posterior predictive distribution does not support general inference. Either specify an inference engine or consider clamping mu and Sigma to point estimates and performing inference using a plugin approximation.');
            else
                M = infer(model.infEng,varargin{:});
            end
        end
        
        % computeFunPost - super class version will work for this class so
        % long as infer works. 
            
    end
    
    methods(Access = 'protected')
        
     
        %% FIT HELPERS
        function model = fitMVNprior(model,SS)
            hyperParams = model.prior.params;
            mu0 = hyperParams.mu;
            S0  = hyperParams.Sigma;
            S0inv = inv(S0);
            S = model.params.Sigma;                                        if isempty(S), error('you must specify Sigma, the prior is only w.r.t. mu'); end
            Sinv = inv(S);
            n = SS.n;
            Sn = inv(inv(S0) + n*Sinv);
            model.paramDist = MvnDist(Sn*(n*Sinv*SS.xbar + S0inv*mu0), Sn);
        end
        
        function model = fitIWprior(model,SS)
            mu = model.params.mu;                                          if isempty(mu), error('you must specify mu, the prior is only w.r.t. Sigma'); end
            n = SS.n;
            hyperParams = model.prior.params;
            T0 = hyperParams.Sigma;
            v0 = hyperParams.dof;
            vn = v0 + n;
            Tn = T0 + n*SS.XX +  n*(SS.xbar-mu)*(SS.xbar-mu)';
            model.paramDist = InvWishartDist(vn, Tn);
        end
        
        function model = fitMIGprior(model,SS)
            d = model.ndimensions;
            hyperParams = model.prior.params;
            m0 = hyperParams.mu;
            k0 = hyperParams.Sigma;
            a0 = hyperParams.a;
            b0 = hyperParams.b;
            kn = k0 + n;
            mn = (k0*m0 + n*xbar)/kn;
            switch lower(model.covtype)
                case 'spherical'
                    an = a0 + n*d/2;
                    bn = b0 + 1/2*sum(diag( n*SS.XX + (k0*n)/(k0+n)*(SS.xbar-colvec(m0))*(SS.xbar-colvec(m0))' ))*ones(size(b0));
                case 'diagonal'
                    an = a0 + n/2;
                    bn = rowvec(diag( diag(b0) + 1/2*(n*SS.XX + (k0*n)/(k0+n)*(SS.xbar-colvec(m0))*(SS.xbar-colvec(m0))')));
                otherwise
                    error('covtype must be specified as either spherical or diagonal to use this prior');
            end
            model.paramDist = MvnInvGammaDist('-mu', mn, '-Sigma', kn, '-a', an, '-b', bn);
        end
        
        function model = fitMIWprior(model,SS)
            hyperParams = model.prior.params;
            k0 = hyperParams.k;
            m0 = hyperParams.mu;
            S0 = hyperParams.Sigma;
            v0 = hyperParams.dof;
            n = SS.n;
            kn = k0 + n;
            vn = v0 + n;
            Sn = S0 + n*SS.XX + (k0*n)/(k0+n)*(colvec(SS.xbar)-colvec(m0))*(colvec(SS.xbar)-colvec(m0))';
            mn = (k0*colvec(m0) + colvec(n*SS.xbar))/kn;
            model.paramDist = MvnInvWishartDist('-mu', mn, '-Sigma', Sn, '-dof', vn, '-k', kn);
        end
        %% MARGINAL HELPERS
        function m = marginalMVNprior(model)
            % integrate out mu
            hyperParams = model.paramDist.params;
            mu    = hyperParams.mu;
            Sigma = hyperParams.Sigma;
            m = MvnDist(mu , Sigma + model.params.Sigma);
        end
        
        function m = marginalIWprior(model)
            % integrate out Sigma
            hyperParams = model.paramDist.params;
            T   = hyperParams.Sigma;
            dof = hyperParams.dof;
            d = model.ndimensions;
            m = MultiStudentDist(dof - d + 1, model.params.mu, T/(dof-d+1));        % Same as the MVNIW result, except the last term is missing a factor of (k+1)/k
        end
        
        function m = marginalMIGprior(model)
            % integrate out mu & Sigma
            hyperParams = model.paramDist.params;
            a = hyperParams.a;
            b = hyperParams.b;
            m = hyperParams.mu;
            k = hyperParams.Sigma;
            m = FactoredDist(StudentDist(2*a, m, b.*(1+k)./(a*k)),'-ndistributions',model.ndimensions); % MultiStudentDist with diagnonal cov might be a better choice
        end
        
        function m = marginalMIWprior(model)
            % integrate out mu and Sigma
            hyperParams = model.paramDist.params;
            mu  = hyperParams.mu;
            T   = hyperParams.Sigma;
            dof = hyperParams.dof;
            k   = hyperParams.k;
            d   = model.ndimensions;
            m   = MultiStudentDist(dof - d + 1, mu, T*(k+1)/(k*(dof-d+1)));
        end
    end
end