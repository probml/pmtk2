classdef JointGaussInfEng < InfEng
   
    properties
		diagnostics;
    end
    
    properties(Access = 'protected')
       mu;
       Sigma;
       domain;
       visVars;
       visVals;
       
    end
    
    methods(Access = 'protected',Abstract = true)
       convertToMvn; 
    end
    
    methods
        
        function eng = enterEvidence(eng,model,D)
            [mu,Sigma,eng.domain] = convertToMvn(eng,model);
            [eng.visVars,eng.visVals] = visible(D);
            [eng.mu,eng.Sigma] = gaussianConditioning(mu,Sigma,canonizeLabels(eng.visVars,eng.domain),eng.visVals); 
        end
        
        function [M,eng] = computeMarginals(eng,model,Q)
        % Already been conditioned
            
            assert(strcmpi(Q.name,'visible'));
            qry = Q.subdomain;
            if ischar(qry)
                switch lower(qry)
                    case 'fulljoint'
                        M = MvnDist(eng.mu,eng.Sigma,'-domain',eng.domain);
                    case 'singletons'
                        M = computeMarginals(eng,model,num2cell(eng.domain));
                    case 'pairs'
                        M = computeMarginals(eng,model,zipmats(eng.domain(1:end-1),eng.domain(2:end)));
                    otherwise
                        error('%s is not a valid query',qry);
                end
            elseif iscell(qry)
               M = cellfuncell(@(c)computeMarginals(eng,model,c),qry);
            else % numeric
               M = MvnDist(eng.mu(1,qry),eng.Sigma(qry,qry),'-domain',qry);
            end 
		end
        
        
        function computeLogPdf(eng,model,varargin)
		%
			notYetImplemented('MvnJointGaussInfEng.computeLogPdf()');
		end


		


		function computeSamples(eng,model,varargin)
		%
			notYetImplemented('MvnJointGaussInfEng.computeSamples()');
		end

	
        
        
        
    end
    
    
end

