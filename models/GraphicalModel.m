classdef GraphicalModel < JointDist
%GRAPHICALMODEL 
    
    properties(Abstract = true)
        domain;
        infEng;
        graph;
    end
    
    methods
        function h = drawGraph(model)
            h = draw(model.graph);
        end
    end
    
end

