classdef MixMvnMc < MixMvn & BayesModel
% Mixture of Multivariate Normal Distributions where the posterior is
% represented in terms of samples.
    
    properties
        paramDist;
    end
    
    methods
        function model = MixMvnMc(varargin)
            args = processArgs(varargin,...
                '-nmixtures'    , 2                  ,...
                '-ndimensions'  , []                 ,...
                '-template'     , []                 ,...
                '-mixingDist'   , []                 ,...
                '-mixtureComps' , {}                 ,...
                '-fitEng'       , MixMvnGibbsFitEng()  );
            [ndimensions,template,remaining] = extractArgs(2:3,args);
            if isempty(template)
               remaining = addArgs(remaining,'-template',MvnConjDist('-ndimensions',ndimensions));
            end
            remaining = addArgs(remaining,'-ndimensions',ndimensions);
            model = model@MixMvn(remaining{:});
        end
        
        function P = getParamPost(model)
            P = model.paramPost;
        end
    
        % note, superclass logPdf and inferLatent work since we
        % override calcResponsibilites
        
        function [Y,H] = sample(model, nsamples)
            assertTrue(~isempty(model.paramDist),'you must fit first');
            H = sample(model.mixingDist,nsamples);
            d = length(model.paramDist.mu{1});
            Y = zeros(n,d);
            mus = model.paramDist.mu;
            Sigmas = model.paramDist.Sigmas;
            Z = randn(d,n);
            for i=1:n                        
                mu = colvec(sample(mus{H(i)}, 1));
                Sigma = sample(Sigmas{H(i)}, 1);
                A = chol(Sigma,'lower');
                Y(i,:) = colvec(bsxfun(@plus,mu(:), A*Z(:,n))');
            end
        end
        
        function [model, latent] = fit(model,X,varargin)
            [model,latent] = fit(model.fitEng,model,unwrap(X));
        end
    end
    
    methods(Access = 'protected')
        
        function logRik = calculateResponsibilities(model,X)
            K = numel(model.mixtureComps);
            S = size(model.paramDist.mu{1}.samples,2);
            n = size(X,1);
            logRikBig = zeros(n,K,S);
            mu = cat(3,model.paramDist.mu{:});
            Sigma = cat(4,model.paramDist.Sigma{:});
            logMixW = log(model.paramDist.mixingWeights.samples);
            for s=1:S
                for k=1:K
                    XC = bsxfun(@minus, X, mu(:,s,k)');
                    logRikBig(:,k,s) = logMixW(k,s) - 1/2*logdet(2*pi*Sigma(:,:,s,k)) - 1/2*sum((XC*inv(Sigma(:,:,s,k))).*XC,2);
                end
            end
            logRik = mean(logRikBig,3);
        end
    end
end

