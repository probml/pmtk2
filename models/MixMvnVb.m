classdef MixMvnVb < MixMvn & BayesModel
    % Variational Bayes for a mixture of multivariate normals
    
    properties
        paramDist;
    end
    
    methods
        
        function model = MixMvnVb(varargin)
            args = processArgs(varargin,...
                '-nmixtures'    , 2                  ,...
                '-ndimensions'  , []                 ,...
                '-template'     , []                 ,...
                '-mixingDist'   , []                 ,...
                '-mixtureComps' , {}                 ,...
                '-fitEng'       , MixMvnVbFitEng ()  );
            [nmixtures,ndimensions,template,mixingDist,remaining] = extractArgs(1:4,args);
            if isempty(template)
                remaining = addArgs(remaining,'-template',MvnInvWishartDist('-ndimensions',ndimensions));
            end
            if isempty(mixingDist)
                remaining = addArgs(remaining,'-mixingDist',DirichletDist('-ndimensions',ndimensions));
            end
            remaining = addArgs(remaining,'-ndimensions',ndimensions,'-nmixtures',nmixtures);
            model = model@MixMvn(remaining{:});
        end
        
        function P = getParamPost(model)
            P = model.paramDist;
        end
        
        function model = fit(model, varargin)
            D = processArgs(varargin,'-data',DataTable());
            model = fit(model.fitEng,model,unwrap(D));
        end
        
        function marginalDist = marginalizeOutParams(model)
            distributions = model.mixingComps;
            K = numel(distributions);
            conjugateDist = cell(K,1); marginalDist = cell(K,1);
            for k=1:K
                switch class(distributions{k})
                    case 'MvnInvWishartDist'
                        conjugateDist{k} = MvnConjDist('-prior',distributions{k});
                    case 'MvnInvGammaDist'
                        conjugateDist{k} = MvnConjDist('-prior',distributions{k});
                end
                marginalDist{k} = marginalizeOutParams(conjugateDist{k});
            end
        end
    end
        
    methods(Access = 'protected')
        
        function logRik = calculateResponsibilities(model,X)
            marginalDist = marginalizeOutParams(model);
            mixingDist = model.mixingDist;
            logMixWeights = log(normalize(colvec(mixingDist.alpha))+eps);
            n = size(data,1);
            K = numel(marginalDist);
            logRik = zeros(n,K);
            for k=1:K
                logRik(:,k) = logMixWeights(k) + logPdf(marginalDist{k},X);
            end
        end
    end
end

