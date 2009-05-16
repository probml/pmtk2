classdef GraphicalModel < ParamModel
%GRAPHICALMODEL 
    
    properties(Abstract = true)
        stateInfEng;
    end
   
    methods(Abstract = true)
       plotTopology;
       inferMissing;
       infer;
       computeMap;
    end
    
end

