classdef LatentVarModel < ProbModel
%LATENTVARMODEL 
   
    methods
        function  R = inferLatent(model,varargin)
            R = marginal(model,varargin{:});
        end
        
        function Z = decodeLatent(model,D)
           Z =  mode(model, Query('latent'), D);
        end
        
    end
end

