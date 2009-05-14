classdef GraphicalModel < ParamModel
%GRAPHICALMODEL 
    
    properties(Abstract = true)
        stateInfEng;
    end
   
    methods(Abstract = true)
       fitStructure; 
    end
    
end

