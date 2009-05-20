classdef MvnDist < MultivarDist



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

        
        function M = infer(model,varargin)    
            [Q,D] = processArgs('-query',[],'-data',[]);
            M = computeMarginals(enterEvidence(model.infEng,D),model,Q);
        end
        
        function D = inferMissing(model,D)
         % imputation   
            for i=1:ncases(D)
                D(i) = mean(infer(model,Query('fullJoint'),D(i)));
            end   
        end
        
        function S = cov(model,varargin)
            if nargin == 1
                S = model.params.Sigma;
            else
                [Q,D] = processArgs('-query',[],'-data',[]);
                S = cov(infer(model,Q,D));
            end
		end

		function H = entropy(model,varargin)
            if nargin == 1
                H = 0.5*logdet(model.params.Sigma) + (model.ndimensions/2)*(1+log(2*pi));
            else
                [Q,D] = processArgs('-query',[],'-data',[]);
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
                [D,SS] = processArgs(varargin,'-data',[],'-suffStat',[]);
                if isempty(SS), SS = mkSuffStat(model,D); end
                switch class(model.prior)
                    case 'NoPrior'
                        mu    = SS.xbar;
                        Sigma = SS.XX;
                    otherwise
                        [mu,Sigma] = fitMap(model,SS);
                end
                success = isposdef(model.params.Sigma) && ~any(isnan(model.params.mu));
                model.params.mu    = mu;
                model.params.Sigma = Sigma;
                diag = [];
            else
               [model,success,diag] = fit(model.fitEng,model,varargin{:}); 
            end
            model = initialize(model);
		end


		function logp = logpdf(model,varargin)
            logp = computeLogPdf(model.infEng,varargin{:});
		end

		function mu = mean(model,varargin)
            if nargin == 1
                mu = model.params.mu;
            else
                [Q,D] = processArgs('-query',[],'-data',[]);
                mu = mean(infer(model,Q,D));
            end
		end

		function mu = mode(model,varargin)
            mu = mean(model,varargin{:});
		end

		function plotPdf(model,varargin)
		%
			notYetImplemented('MvnDist.plotPdf()');
		end


		function S = sample(model,varargin)
            S = computeSamples(model.infEng,varargin{:});
        end
        
		function v = var(model,varargin)
             if nargin == 1
                v = diag(model.params.Sigma);
            else
                [Q,D] = processArgs('-query',[],'-data',[]);
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

