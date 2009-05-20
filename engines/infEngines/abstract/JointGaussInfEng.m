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
            [eng.mu,eng.Sigma,eng.domain] = convertToMvn(eng,model);
            if nargin > 2 && ~isempty(D)
                [eng.visVars,eng.visVals] = visible(D);
                vlabels = canonizeLabels(eng.visVars,eng.domain);
                [smallMu,smallSigma] = gaussianConditioning(colvec(eng.mu),eng.Sigma,vlabels,colvec(eng.visVals));
                hlabels = setdiff(eng.domain,vlabels);
                eng.mu(hlabels) = rowvec(smallMu);
                eng.Sigma(hlabels,hlabels) = smallSigma;
            end
        end
        
        function [M,eng] = computeMarginals(eng,Q)
        
            assertTrue(~isempty(eng.mu),'You must call enterEvidence before calling computeMarinals');
            
            if nargin < 2 || isempty(Q), Q = Query('-subdomain','fullJoint');  end
            
            assertTrue(strcmpi(Q.name,'visible'),'JointGaussInfEng only supports queries with name=''visible''');
            
            qry = Q.subdomain;
            if ischar(qry) % named queries
                switch lower(qry)
                    case 'fulljoint'
                        M = MvnDist(eng.mu,eng.Sigma,'-domain',eng.domain);
                    case 'singletons'
                        M = computeMarginals(eng,num2cell(eng.domain));
                    case 'pairs'
                        M = computeMarginals(eng,zipmats(eng.domain(1:end-1),eng.domain(2:end)));
                    case 'family'
                        error('please manually specify the family');
                    otherwise
                        error('%s is not a valid query',qry);
                end
            elseif iscell(qry) % batch queries
               M = cellfuncell(@(c)computeMarginals(eng,c),qry);
            else % numeric / base case
               M = MvnDist(eng.mu(1,qry),eng.Sigma(qry,qry),'-domain',qry);
            end 
		end
                
        function L = computeLogPdf(eng,model,D)
            [mu,Sigma] = convertToMvn(eng,model);
            X = D.X;
            d = length(mu);
            XC = bsxfun(@minus,X,rowvec(mu));
            L = -0.5*sum((XC*inv(Sigma)).*XC,2);
            logZ = (d/2)*log(2*pi) + 0.5*logdet(Sigma);
            L = L - logZ;
		end

		function S = computeSamples(eng,model,n)
            [mu,Sigma] = convertToMvn(eng,model);
            A = chol(Sigma,'lower'); 
            Z = randn(length(mu),n);
            S = bsxfun(@plus,mu(:), A*Z)'; %#ok
		end
   
    end
    
end