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
        
        
        
        
        
%         function mat = computeFunPostMissing(model,D)
%             
%         end
%         
        
%         function M = computeMap(model,varargin)    
%             [Q,D] = processArgs(varargin,'+-query',Query(),'+-data',DataTable());
%             M = rowvec(mode(infer(model,Q,D(1))));
%             nc = ncases(D);
%             if nc > 1
%                M = [M,zeros(nc-1,size(M,2))];
%                for i=2:nc
%                    M(i,:) = rowvec(mode(infer(model,Q,D(i))));
%                end
%             end
%         end
        
%         function D = computeMapMissing(model,D)
%         % imputation
%             for i=1:ncases(D)
%                 hid = hidden(D(i));
%                 D(i,hid) = mode(infer(model,Query(hid),D(i,visible(D(i)))));    
%             end   
%         end
        
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
            assert(isposdef(SS.XX));
        end

		function [model,success,diagn] = fit(model,varargin)
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
                success = isposdef(model.params.Sigma);
                model.params.mu    = mu;
                model.params.Sigma = Sigma;
                diagn = [];
            else
               [model,success,diagn] = fit(model.fitEng,model,varargin{:}); 
            end
            model = initialize(model);  % sets dof, ndimensions, etc
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
            if model.ndimensions == 2
                h = gaussPlot2d(model.params.mu,model.params.Sigma);
            else
               notYetImplemented('Only 2D plotting currently supported'); 
            end
		end

		function S = sample(model,n)
            if nargin < 2, n = 1; end
            S = computeSamples(model.infEng,model,n);
        end
        
		function v = var(model,varargin)
            v = diag(model.params.Sigma);
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

