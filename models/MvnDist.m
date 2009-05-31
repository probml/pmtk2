classdef MvnDist < MultivarDist
    % Multivariate Normal Distribution
    
    
   
    
    
    
    properties
        dof; 
        ndimensions;
        params;
        prior;
        infEng;
        fitEng;
    end
    
    properties
        covType;
    end
    
    methods
        
        
        
        function model = MvnDist(varargin)
            if nargin == 0; return ;end
            [ model.params.mu , model.params.Sigma        ,...
                model.prior     , model.ndimensions         ,...
                model.infEng    , model.fitEng              ,...
                model.covType   , model.params.domain       ,...
                ] = processArgs(varargin                    ,...
                '-mu'          , []                         ,...
                '-Sigma'       , []                         ,...
                '-prior'       , NoPrior()                  ,...
                '-ndimensions' , []                         ,...
                '-infEng'      , MvnJointGaussInfEng()      ,...
                '-fitEng'      , []                         ,...
                '-covType'     , 'full'                     ,...
                '-domain'      , []                         );
            model = initialize(model); % sets ndimensions, dof, params if nec.
        end
        
        
        function M = infer(model,varargin)
            [Q,D,expand] = processArgs(varargin,'+-query',Query(),'+-data',DataTable(),'-expand',false);
            nc = ncases(D);
            if nc < 2
                M = computeMarginals(enterEvidence(model.infEng,model,D),Q);
            elseif ~expand
                M = cell(nc,1);
                for i=1:nc
                    M{i} = rowvec(computeMarginals(enterEvidence(model.infEng,model,D(i)),Q));
                end
            else  % expand to ncases(D)-by-model.ndimensions
                M = cell(nc,model.ndimensions);
                for i=1:nc
                    eng = enterEvidence(model.infEng,model,D(i));
                    [marg,qryNdx] = computeMarginals(eng,Q);
                    if ~isempty(qryNdx)
                        M(i,unwrapCell(qryNdx)) = marg;
                    end
                end
            end
            M = unwrapCell(M);
        end
        
        function varargout = computeFunPost(model,varargin)
            % Compute a function of the posterior
            [Q , D , funstr , fnArgs , expand , filler] = processArgs(varargin,...
                '+-query'   , Query()     ,...
                '+-data'    , DataTable() ,...
                '-func'     , 'mode'      ,...
                '-fnArgs'   , {}          ,...
                '-expand'   , 'auto'      ,... % if true, expands output to ncases(D)-by-model.ndimensions, (e.g. for imputation)
                '-filler'   , {}          );   % value to fill empty entries with, if expand = true - can use string 'visibleData'
            if ~iscell(expand) && (isempty(expand) || strcmp(expand,'auto'))
                expand = ~isRagged(Q);
            end
            if isempty(filler) && ~iscell(funstr)
                switch funstr
                    case {'mean','mode'}
                        filler = 'visibleData';
                    otherwise
                        filler = 0;
                end
            end
            if iscell(funstr)  % call computeFunPost recursively for each function
                nfuncs = numel(funstr);
                [fnArgs,filler,expand,varargout] = expandCells(nfuncs,fnArgs,filler,expand,{});
                for i=1:nfuncs
                    varargout{i} = computeFunPost(model,Q,D,funstr{i},fnArgs{i},expand{i},filler{i});
                end
                return;
            end
            
            func = str2func(funstr);
            P = infer(model,Q,D,'-expand',boolValue(expand));
            
            if ~iscell(P) % not a batch query
                varargout = cellwrap(func(P,fnArgs{:})); % apply the function to the posterior
            else
                func = protect(curry(func,fnArgs{:}),NaN); % fill in empty entries with NaN so we can easily fill them in later
                M = unwrapCell(cellfunR(func,P));          % recursively apply the function to all posterior objects
                if expand
                    filler = unwrapCell(filler);
                    ndx = isnan(M);
                    if ischar(filler) && strcmpi(filler,'visibleData')
                        X = D.X;
                        M(ndx) = X(ndx);
                    else
                        M(ndx) = filler;
                    end
                end
                varargout = cellwrap(M);
            end
        end
        
        function S = cov(model,varargin)
            S = model.params.Sigma;
        end
        
        function H = entropy(model,varargin)
            H = 0.5*logdet(model.params.Sigma) + (model.ndimensions/2)*(1+log(2*pi));
        end
        
        function SS = mkSuffStat(model,D,weights) %#ok
            % SS.n
            % SS.xbar = 1/n sum_i X(i,:)'
            % SS.XX(j,k) = 1/n sum_i XC(i,j) XC(i,k) - centered around xbar
            % SS.XX2(j,k) = 1/n sum_i X(i,j) X(i,k)  - not mean centered
            if nargin < 3, weights = ones(ncases(D),1); end
            X = D.X;
            SS.n = sum(weights,1);
            SS.xbar = rowvec(sum(bsxfun(@times,X,weights))'/SS.n);  % bishop eq 13.20
            SS.XX2 = bsxfun(@times,X,weights)'*X/SS.n;
            X = bsxfun(@minus,X,SS.xbar);
            SS.XX = bsxfun(@times,X,weights)'*X/SS.n;
            assert(isposdef(SS.XX))
        end
        
        function [model,success,diagn] = fit(model,varargin)
            % Find MLE or MAP estimate of an Mvn
            if ~isempty(model.fitEng)
                [model,success,diagn] = fit(model.fitEng,model,varargin{:});
            else
                [D,SS] = processArgs(varargin,'+-data',DataTable(),'-suffStat',[]);
                switch class(model.prior)
                    case 'NoPrior'
                        if isempty(SS)
                            X = D.X;
                            mu = mean(X,1);
                            Sigma = cov(X);
                        else
                            mu    = SS.xbar;
                            Sigma = SS.XX;
                        end
                    otherwise
                        if isempty(SS),SS = mkSuffStat(model,D);end
                        [mu,Sigma] = fitMap(model,SS);
                end
                switch model.covType
                    case 'diag', Sigma = diag(diag(Sigma)); % store as matrix not vector
                    case 'spherical', error('spherical Mvn not yet supported')
                end
                success = isposdef(model.params.Sigma);
                model.params.mu    = mu;
                model.params.Sigma = Sigma;
                diagn = [];
            end
            % KPM: no longer call initialize since size of model
            % known at construction time
            %model = initialize(model);  % sets dof, ndimensions, etc
        end
        
        function logp = logPdf(model,D)
            logp = computeLogPdf(model.infEng,model,D);
        end
        
        function mu = mean(model,varargin)
            mu = model.params.mu;
        end
        
        function mu = mode(model,varargin)
            mu = mean(model,varargin{:});
        end
        
        function h = plotPdf(model,varargin)
            mu = model.params.mu; Sigma = model.params.Sigma;
            d = model.ndimensions;
            switch d
                case 1,
                    xs = linspace(mu-4*Sigma, mu+4*Sigma, 100);
                    % DataTable must be a column vector, otherwise interpreted as
                    % product
                    h = plot(xs, exp(logPdf(model, DataTable(colvec(xs)))));
                case 2,
                    h = gaussPlot2d(mu, Sigma);
                otherwise
                    error(sprintf('cannot plot in %d dimensions', d))
            end
        end
        
        function S = sample(model,n)
            if nargin < 2, n = 1; end
            S = computeSamples(model.infEng,model,n);
        end
        
        function v = var(model,varargin)
            v = diag(model.params.Sigma);
        end
        
        function [postmu, logevidence] = softCondition(pmu, py, A, y)
            % Bayes rule for MVNs
            Syinv = inv(py.params.Sigma);
            Smuinv = inv(pmu.params.Sigma);
            postSigma = inv(Smuinv + A'*Syinv*A);
            postmu = postSigma*(A'*Syinv*(y-py.params.mu) + Smuinv*pmu.params.mu);
            postmu = MvnDist(postmu, postSigma);
            if nargout > 1
                logevidence = logPdf(MvnDist(A*pmu.params.mu + py.params.mu, py.params.Sigma + A*pmu.params.Sigma*A'), y(:)');
            end
        end
    end
    
    
    
    methods(Access = 'protected')    
        function model = initialize(model)
            % Make random params if none specified.
            % Infer values of other fields.
            % Called from constructor
            if isempty(model.params.mu)
                if isempty(model.ndimensions)
                    model.ndimensions = 1;
                    % must be able to an object of type MvnDist with no params
                    %error('must specify mu or ndimensions')
                end
                % Make rnd params of required size
                d = model.ndimensions;
                model.params.mu = randn(d,1);
                switch model.covType
                    % We currently always store Sigma as a full matrix
                    case 'full', model.params.Sigma = randpd(d);
                    case 'diag', model.params.Sigma = diag(rand(d,1));
                    case 'spherical', model.params.Sigma = rand(1,1)*eye(d);
                end
            else
                model.params.mu = rowvec(model.params.mu);
                d = length(model.params.mu);
                if ~isempty(model.ndimensions)
                    if model.ndimensions ~= d
                        error('inconsistent ndimensions')
                    end
                else
                    model.ndimensions = d;
                end
            end
            switch model.covType
                case 'full', model.dof = d + ((d*(d+1))/2);
                case 'diag', model.dof = d + d;
                case 'spherical', model.dof = d+1;
            end
            if isempty(model.params.domain)
                model.params.domain = 1:model.ndimensions;
            end
        end
        
        
        function [mu,Sigma] = fitMap(model,SS)
           delegate = MvnConjDist('-prior',model.prior,'-ndimensions',model.ndimensions,'-mu',model.params.mu,'-Sigma',model.params.Sigma); 
           delegate = fit(delegate,'-suffStat',SS);
           [mu,Sigma] = getParamPost(delegate,'mode');
        end
        
        
    end
    
    
end

