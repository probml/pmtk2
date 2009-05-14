classdef GraphicalModel < ParamModel
%GRAPHICALMODEL 
    
    properties(Abstract = true)
        domain;
        graph;
        stateEstEng;
    end
   
    methods(Abstract = true)
       fitStructure; 
    end
    
end

