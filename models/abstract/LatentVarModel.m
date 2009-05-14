classdef LatentVarModel < ParamModel
%LATENTVARMODEL
    
    methods
        
        
        function [zhat, pz] = inferLatent(m, D)
            zhat = mode(m, 'latent', D); % for HMM, this is Viterbi; for MixModel, it is hard assignment
            if nargout >=2
                pz = marginal(m, 'latent', D); % may be eg one-slice marginals
            end
        end
        
    end
end

