classdef ProbDist

    methods(Abstract = true)
        mean;
        mode;
        var;
        cov;
        entropy
        plotPdf;
    end
    
end

