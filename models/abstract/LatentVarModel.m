classdef LatentVarModel < ParamModel
%LATENTVARMODEL
    
    properties(Abstract = true)
       ndimsLatent; 
    end

    
    

    methods(Abstract = true)
        
        inferLatent;
        computeMapLatent;
        
        
    end
end

