classdef ProductDist < JointDist
%PRODUCTDIST  A product of probability distributions


    methods(Abstract = true)
        logprob; % changes semantics of logprob to p(i,j) = log(p(D(i,:) | params(j));
    end

end

