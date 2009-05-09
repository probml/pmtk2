classdef LatentVarModel < ProbDist
%LATENTVARMODEL 
    
    properties(Abstract = true)
        latentNames;
    end
    
    methods(Abstract = true)
        inferLatents;
    end
    
end

