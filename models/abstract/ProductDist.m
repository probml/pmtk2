classdef ProductDist < ProbModel
%PRODUCTDIST  A product of probability distributions
    

    methods(Abstract = true)
        ndists;  % returns the number of distributions participating in the product. 
    end

end

