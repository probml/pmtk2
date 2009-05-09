classdef MultivarDist < JointDist
%MULTIVARDIST  A joint distribution that implements mean, mode, cov, var
    
    methods(Abstract = true)
        mean;
        mode;
        cov;
        fit;
    end
    
end

