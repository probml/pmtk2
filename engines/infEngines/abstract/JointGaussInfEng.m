classdef JointGaussInfEng < InfEng
   
    properties
		diagnostics;
    end
    
    properties(Access = 'protected')
       mu;            % let d = numel(domain) mu,Sigma are always of sizes [1,d] and [d,d] respectively - 
       Sigma;         % vis values are plugged into mu, and Sigma entries set to 0 after calls to enterEvidence
       domain;        % not necessarily 1:d
       visVars;       % always a subset of domain, not necessarily in 1:d
       visVals;
       hidVars;       % always a subset of domain, and always = setdiff(domain,visVars)
       missingVars;   % vars corresponding to missing values in the conditioning data, (subset of hidVars)         
       
    end
    
    methods(Access = 'protected',Abstract = true)
       convertToMvn; 
    end
    
    methods
        
        function eng = enterEvidence(eng,model,D)
            [eng.mu,eng.Sigma,eng.domain] = convertToMvn(eng,model);
            if nargin > 2 && ~isempty(D)
                [visVars,visVals] = visible(D);
                visVarsCanon = canonizeLabels(visVars,eng.domain);
                [smallMu,smallSigma] = gaussianConditioning(colvec(eng.mu),eng.Sigma,visVarsCanon,colvec(visVals));
                hidVars = setdiff(eng.domain,visVars);
                hidVarsCanon = canonizeLabels(hidVars,eng.domain);
                eng.mu(hidVarsCanon) = rowvec(smallMu);
                eng.Sigma(hidVarsCanon,hidVarsCanon) = smallSigma;
                
                eng.mu(visVarsCanon) = visVals;
                eng.Sigma(visVarsCanon,visVarsCanon) = 0;
                eng.visVars = visVars;
                eng.visVals = visVals;
                eng.hidVars = hidVars;
                eng.missingVars = hidden(D);
            else
               eng.visVars = eng.domain;
            end
        end
        
        function [M,qryNdx] = computeMarginals(eng,Q)
            
            assertTrue(~isempty(eng.mu),'You must call enterEvidence before calling computeMarinals');
            if nargin < 2 || isempty(Q), M = {};qryNdx = {}; return;  end
            qry = Q.variables;
            if ischar(qry)     % named queries
                Q = convertStringQuery(eng,qry);
                [M,qryNdx] = computeMarginals(eng,Q);
            elseif iscell(qry) % batch queries
                [M,qryNdx] = cellfun(@(c)computeMarginals(eng,Query(c)),qry,'UniformOutput',false); %can't use cellfuncell because of multiple outputs
            else               % numeric / base case
               qryNdx = canonizeLabels(qry,eng.domain); 
               M = MvnDist(eng.mu(qryNdx),eng.Sigma(qryNdx,qryNdx),'-domain',qry);
            end 
            
        end
                
        %% Always unconditional
        function L = computeLogPdf(eng,model,D)
            [mu,Sigma] = convertToMvn(eng,model);
            X = unwrap(D);
            [nrows,ncols] = size(X);
            if ncols ~= model.ndimensions && nrows == model.ndimensions
                X = X';
            end
                
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
    
    methods(Access = 'protected')
        
        function stdQry = convertStringQuery(eng,qry)
            
           switch lower(qry)
               % joint = 1:d
               % missingJoint = joint of elements in D = NaN
               % singles = {1,2,3,...d}
               % missingSingles =
               % pairs
               % families
               case 'joint'
                   stdQry = Query(eng.domain);
               case 'missingjoint'
                   stdQry = Query(eng.missingVars);
               case 'singles'
                   stdQry = Query(num2cell(eng.domain));
               case 'missingsingles'
                   stdQry = Query(num2cell(eng.missingVars));
               case 'pairs'
                   stdQry = Query(zipmats(eng.domain(1:end-1),eng.domain(2:end)));
               case 'families'
                   error('Please specify the families manually');
               otherwise
                   error('%s is not a valid string query',qry);
           end
        end
    end
end