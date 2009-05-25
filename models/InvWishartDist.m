classdef InvWishartDist < MultivarDist



	properties

		
		ndimensions;
		params;
		prior;

	end


	methods

		function model = InvWishartDist(varargin)
            [model.params.dof,model.params.Sigma] = processArgs(varargin,'-dof',[],'-Sigma',[]);
            model = initialize(model);
		end


		function cov(model,varargin)
		%
			notYetImplemented('InvWishartDist.cov()');
		end


		function entropy(model,varargin)
		%
			notYetImplemented('InvWishartDist.entropy()');
		end


		function fit(model,varargin)
		%
			notYetImplemented('InvWishartDist.fit()');
        end

        
        function mm = marginal(model,Q)
            
            % If M ~ IW(dof,S), then M(q,q) ~ IW(dof-2d+2q, S(q,q))
            % Press (2005) p118
            query = Q.variables; if iscell(query), error('does not support batch queries'); end
            q = length(query); d = model.ndimensions; v = model.params.dof;
            mm = InvWishartDist(v-2*d+2*q, model.params.Sigma(query,query));
            
            
        end

		function [L,logZ] = logPdf(model,D)
            X = D.X;
            d = model.ndimensions;
           
            if d==1
                n = length(X);
                X(X==0) = eps;
                X = reshape(X,[1 1 n]);
            else
                n = size(X,3);
            end
            
            v = model.params.dof;
            S = model.param.Sigma;
            logZ = (v*d/2)*log(2) + mvtGammaln(d,v/2) -(v/2)*logdet(S);
            L = zeros(n,1);
            for i=1:n
                L(i) = -(v+d+1)/2*logdet(X(:,:,i)) -0.5*trace(obj.Sigma*inv(X(:,:,i))) - logZ;
            end
            L = L(:);
		end


		function m = mean(model)
            m = model.params.Sigma / (model.params.dofParam - model.ndimensions(model) - 1);
		end


        function m =  mode(model)
		  m = model.params.Sigma / (model.params.dof + model.ndimensions + 1);
        end


        function [h,p] = plotPdf(model, varargin)
            if mode.ndimensions==1
                objS = convertToScalarDist(model);
                [h,p] = plotPdf(objS, varargin{:});
            else
                error('can only plot 1d')
            end
        end
        
        
        function sample(model,n)
        % X(:,:,i) is a random matrix drawn from IW() for i=1:n
            d = model.ndimensions;
            if nargin < 2, n = 1; end
            X  = zeros(d,d,n);
            [X(:,:,1), DI] = iwishrnd(model.params.Sigma, model.params.dof);
            for i=2:n
                X(:,:,i) = iwishrnd(model.params.Sigma, model.params.dof, DI);
            end
        end
        
        function plotMarginals(model)
            figure;
            d = model.ndimensions;
            nr = d; nc = d;
            for i=1:d
                subplot2(nr,nc,i,i);
                m = marginal(model, i);
                plot(m, 'plotArgs', {'linewidth',2});
                title(sprintf('%s_%d','\sigma^2', i));
            end
            n = 1000;
            Sigmas = sample(model, n);
            for s=1:n
                R(:,:,s) = cov2cor(Sigmas(:,:,s));
            end
            for i=1:d
                for j=i+1:d
                    subplot2(nr,nc,i,j);
                    [f,xi] = ksdensity(squeeze(R(i,j,:)));
                    plot(xi,f, 'linewidth', 2);
                    title(sprintf('%s(%d,%d)','\rho', i, j))
                end
            end
        end
        
        
        
        function h = plotSamples2d(model, n)
            % eg plotSamples2d(invWishartDist(5, randpd(2)), 4)
            figure;
            if model.ndimensions ~= 2
                error('only works for 2d')
            end
            [nr, nc] = nsubplots(n);
            Sigmas = sample(model, n);
            for i=1:n
                pgauss = MvnDist([0 0], Sigmas(:,:,i));
                subplot(nr, nc,i)
                h=gaussPlot2d(pgauss.mu, pgauss.Sigma);
                %grid on
            end
        end

         function objS = convertToScalarDist(model)
            if model.ndimensions ~= 1, error('cannot convert to scalarDst'); end
            objS = InvGammaDist(model.params.dof/2, model.params.Sigma/2);
        end
       
		function var(model,varargin)
		%
			notYetImplemented('InvWishartDist.var()');
		end


    end
    
    
    methods(Access = 'protected')
        function model = initialize(model)
            
        end
    end
    
    
    properties(Hidden = true)
        dof; % required by super class, but confusing not to use model.param.dof version
    end
        


end

