classdef JointDist < ProbDist
%JOINTDIST Abstract Joint Probability Distribution
    
    methods
        function model = enterEvidence(model,varargin)
        % condition the model on evidence
        
        end
        
        function marg = marginal(model,varargin)
         % return a marginal distribution   
        end
        
        function D = impute(model,varargin)
        % fill in missing data    
        end
        
        function Q = query(model,varargin)
        % efficient version of marginal(enterEvidence(model,visVars,visVals))
        end
        
    end
    
end

