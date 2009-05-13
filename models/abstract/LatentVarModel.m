classdef LatentVarModel < ProbModel
%LATENTVARMODEL 
   
    methods
        function  R = inferLatent(model,varargin)
            R = marginal(model,varargin{:});
        end
    end
end

