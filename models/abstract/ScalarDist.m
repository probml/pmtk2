classdef ScalarDist < ProbDist
%SCALARDIST Abstract Scalar Probability Distribution that supports mean,
%mode, var, fit
    
    methods(Abstract = true)
        mean;
        mode;
        var;
        fit;
        plot;
    end
    
end

