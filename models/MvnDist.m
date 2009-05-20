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
           
            [ model.params.mu , model.params.Sigma        ,...
              model.prior     , model.ndimensions         ,...
              model.infEng    , model.fitEng              ,...
              model.covType   , model.params.domain       ,...
            ] = processArgs(varargin                      ,...
              '-mu'          , []                         ,...
              '-Sigma'       , []                         ,...
              '-prior'       , NoPrior()                  ,...
              '-ndimensions' , []                         ,...
              '-infEng'      , MvnJointGaussInfEng()      ,...
              '-fitEng'      , []                         ,...
              '-covType'     , 'full'                     ,...
              '-domain'      , []                         );
            model = initialize(model); % sets ndimensions, dof
        end

        
        function [M,eng] = infer(model,varargin)    
            [Q,D] = processArgs(varargin,'+-query',Query(),'+-data',DataTable());
            assertTrue(ncases(D) < 2,'infer does not support multiple data cases'); 
            eng = enterEvidence(model.infEng,model,D);
            M = computeMarginals(eng,Q);
        end
        
        function M = computeMap(model,varargin)    
            [Q,D] = processArgs(varargin,'+-query',Query(),'+-data',DataTable());
            M = rowvec(mode(infer(model,Q,D(1))));
            nc = ncases(D);
            if nc > 1
               M = [M,zeros(nc-1,size(M,2))];
               for i=2:nc
                   M(i,:) = rowvec(mode(infer(model,Q,D(i))));
               end
            end
        end
        
        function pDh = inferMissing(model,D)
        % imputation, but returns a distribtuion not a point estimate
            assertTrue(ncases(D)==1,'inferMissing is not vectorized w.r.t. D');
            pDh = infer(model,Query(hidden(D)),D(:,visible(D))); 
        end
        
        function D = computeMapMissing(model,D)
        % imputation
            for i=1:ncases(D)
                hid = hidden(D(i));
                D(i,hid) = mode(infer(model,Query(hid),D(i,visible(D(i)))));    
            end   
        end
        
        function S = cov(model,varargin)
            if nargin == 1
                S = model.params.Sigma;
            else
                [Q,D] = processArgs(varargin,'+-query',Query(),'+-data',DataTable());
                S = cov(infer(model,Q,D));
            end
		end

		function H = entropy(model,varargin)
            if nargin == 1
                H = 0.5*logdet(model.params.Sigma) + (model.ndimensions/2)*(1+log(2*pi));
            else
                [Q,D] = processArgs(varargin,'+-query',Query(),'+-data',DataTable());
                H = entropy(infer(model,Q,D));
            end
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
        end

		function [model,success,diag] = fit(model,varargin)
		
            if isempty(model.fitEng)
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
                        [mu,Sigma] = fitMap(model,varargin);
                end
                success = isposdef(model.params.Sigma) && ~any(isnan(model.params.mu));
                model.params.mu    = mu;
                model.params.Sigma = Sigma;
                diag = [];
            else
               [model,success,diag] = fit(model.fitEng,model,varargin{:}); 
            end
            model = initialize(model);  % sets dof, ndimensions, etc
		end

		function logp = logPdf(model,D,varargin)
            [Q,Dvis] = processArgs(varargin,'+-query',Query(),'+-visData',DataTable()); 
            M = infer(model,Q,Dvis);
            logp = computeLogPdf(model.infEng,M,D);
		end

		function mu = mean(model,varargin)
            if nargin == 1
                mu = model.params.mu;
            else
                [Q,D] = processArgs(varargin,'+-query',Query(),'+-data',DataTable);
                mu = mean(infer(model,Q,D));
            end
		end

		function mu = mode(model,varargin)
            mu = mean(model,varargin{:});
		end

		function h = plotPdf(model,varargin)
            if model.ndimensions == 2
                h = gaussPlot2d(model.params.mu,model.params.Sigma);
            else
               notYetImplemented('Only 2D plotting currently supported'); 
            end
		end

		function S = sample(model,varargin)
            [n,Q,D] = processArgs(varargin,'-n',1,'+-query',Query(),'+-data',DataTable());
            M = infer(model,Q,D);
            S = computeSamples(model.infEng,M,n);
        end
        
		function v = var(model,varargin)
             if nargin == 1
                v = diag(model.params.Sigma);
            else
                [Q,D] = processArgs(varargin,'+-query',Query(),'+-data',DataTable);
                v = var(infer(model,Q,D));
            end
        end
    end
    
    
    
    
    
    
    methods(Access = 'protected')
       
        function model = initialize(model)
        % Called from constructor and fit    
            model.params.mu = rowvec(model.params.mu);
            d = length(model.params.mu);
            if isempty(model.ndimensions)
                model.ndimensions = d;
            end
            model.dof = d + ((d*(d+1))/2);   % Not d^2 since Sigma is symmetric 
            if isempty(model.params.domain)
               model.params.domain = 1:length(model.params.mu); 
            end
        end
        
        
        function [mu,Sigma] = fitMap(model,SS)
            notYetImplemented('MVN Map Estimation');
        end
        
        
    end


end

