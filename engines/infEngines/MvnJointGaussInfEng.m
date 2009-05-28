classdef MvnJointGaussInfEng < JointGaussInfEng
    
    
    % everything done in JointGaussInfEng
    methods(Access = 'protected')        
        
        function [mu,Sigma,domain] = convertToMvn(eng,model,varargin)   %#ok
            mu     = model.params.mu;
            Sigma  = model.params.Sigma;
            domain = model.params.domain;
            
		end
    end
end

