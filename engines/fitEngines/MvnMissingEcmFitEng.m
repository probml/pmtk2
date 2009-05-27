classdef MvnMissingEcmFitEng < FitEng
    
    properties
        diagnostics;
        verbose; 
    end
    
    
    methods
        
        function eng = MvnMissingEcmFitEng(varargin)
            eng.verbose = processArgs(varargin,'-verbose',true);
        end
        
        function [model,success,diagn] = fit(eng,model,D)
            [model.params.mu,model.params.Sigma,eng.diagnostics.loglikTrace,success] = fitMvnEcm('-data',D.X,'-prior',model.prior,'-covtype',model.covType);
            diagn = eng.diagnostics;
        end
    end
end







function [mu,Sigma,loglikTrace,success] = fitMvnEcm(varargin)
    % Find MLE/MAP estimate of MVN when X has missing values, using ECM algorithm
    
    % data is an n*d design matrix with NaN values
    % prior is either 'none' or 'NIW' or an MvnInvWishartDist object
    % If prior='NIW', we use vague default hyper-params
    % Written by Cody Severinski and Kevin Murphy
    
    [data,prior,covtype, maxIter, opttol, verbose] = processArgs(varargin,'-data',[],'-prior',NoPrior(),'-covtype','full','-maxIter', 100, '-tol', 1e-4, '-verbose', false);
    
    allMissing = find(all(isnan(data),2));
    if(~isempty(allMissing)),
        warging('MvnMissingEmFitEng:noObservations','%d rows of the data matrix contain no observations.  These will be removed \n');
        data = data(setdiffPMTK(1:rows(data), allMissing),:);
    end
    [n,d] = size(data);
    dataMissing = isnan(data);
    missingRows = any(dataMissing,2);
    missingRows = find(missingRows == 1);
    X = data'; % it will be easier to work with column vectros
    
    % Initialize params
    mu = nanmean(data); mu = mu(:);
    Sigma = diag(nanvar(data));
    
    expVals = zeros(d,n);
    expProd = zeros(d,d,n);
    
    % If there is no missing data, then just plug-in -- ECM not needed
    for i=setdiffPMTK(1:n,missingRows)
        expVals(:,i) = X(:,i);
        expProd(:,:,i) = X(:,i)*X(:,i)';
    end
    
    iter = 1;
    converged = false;
    currentLL = -inf;
    
    % Extract hyper-params for MAP estimation
    prior = mkPrior('-data', data, '-prior',prior, '-covtype', covtype);
    switch class(prior)
        case 'MvnInvWishartDist'
            kappa0 = prior.k; m0 = prior.mu'; nu0 = prior.dof; T0 = prior.Sigma;
        case 'MvnInvGammaDist'
            kappa0 = prior.Sigma; m0 = prior.mu'; nu0 = prior.a; T0 = prior.b;
        case 'NoPrior'
            % Setting hyperparams to zero gives the MLE
            kappa0 = 0; m0 = zeros(d,1); nu0 = 0; T0 = zeros(d,d);
        otherwise
            error(['unknown prior ' classname(prior)])
    end
    
    while(~converged)
        % Expectation step
        for i=missingRows(:)'
            u = dataMissing(i,:); % unobserved entries
            o = ~u; % observed entries
            Sooinv = inv(Sigma(o,o));
            Si = Sigma(u,u) - Sigma(u,o) * Sooinv * Sigma(o,u);
            expVals(u,i) = mu(u) + Sigma(u,o)*Sooinv*(X(o,i)-mu(o));
            % We never did actually update the actual expVals with the values of the observed dimensions
            expVals(o,i) = X(o,i);
            expProd(u,u,i) = expVals(u,i) * expVals(u,i)' + Si;
            expProd(o,o,i) = expVals(o,i) * expVals(o,i)';
            expProd(o,u,i) = expVals(o,i) * expVals(u,i)';
            expProd(u,o,i) = expVals(u,i) * expVals(o,i)';
        end
        
        %  M step
        % we store the old values of mu, Sigma just in case the log likelihood decreased and we need to return the last values before the singularity occurred
        muOld = mu;
        SigmaOld = Sigma;
        
        % MAP estimate for mu -- note this reduces to the MLE if kappa0 = 0
        mu = (sum(expVals,2) + kappa0*m0)/(n + kappa0);
        % Compute ESS = 1/n sum_i E[ (x_i-mu) (x_i-mu)' ] using *new* value of mu
        % ESS = sum(expProd,3) + n*mu*mu' - 2*mu*sum(expVals,2)';
        ESS = sum(expProd,3) - sum(expVals,2)*mu' - mu*sum(expVals,2)' + n*mu*mu';
        
        switch class(prior)
            case 'char'
                switch lower(prior)
                    case 'none'
                        % If no prior, then we have that Sigma = 1/n* E[(x_i - mu)(x_i - mu)'] = ESS / n
                        Sigma = ESS/n;
                    case 'niw'
                        Sigma = (ESS + T0 + kappa0*(mu-m0)*(mu-m0)')/(n+nu0+d+2);
                    otherwise
                        error(['unknown prior ' prior])
                end
            case 'NoPrior'
                Sigma = ESS/n;
            case 'MvnInvWishartDist'
                Sigma = (ESS + T0 + kappa0*(mu-m0)*(mu-m0)')/(n+nu0+d+2);
            case 'MvnInvGammaDist'
                switch lower(covtype)
                    case 'diagonal'
                        Sigma = diag(ESS + T0 + kappa0*(mu-mu0)*(mu-mu0)') / (n + nu0 + 1 + 2);
                    case 'spherical'
                        Sigma = diag(sum(diag(ESS + T0 + kappa0*(mu-mu0)*(mu-mu0)'))) / (n*d + nu0 + d + 2);
                end
            otherwise
                error(['unknown prior ' prior])
        end
        
        if(det(Sigma) <= 0)
            warning('fitMvnEcm:Sigma:nonsingular','Warning: Obtained Nonsingular Sigma.  Exiting with last reasonable parameters \n')
            mu = muOld;
            Sigma = SigmaOld;
            success = false;
            return;
        end
        
        % Convergence check
        prevLL = currentLL;
        %currentLL = -n/2*logdet(2*pi*Sigma) - 0.5*trace(SS.XX*prec);
        % SS.n
        % SS.xbar = 1/n sum_i X(i,:)'
        % SS.XX2(j,k) = 1/n sum_i X(i,j) X(i,k)
        %SS.XX2 = ESS/n; SS.n = n; SS.xbar = mu/n; % I don't think that SS.xbar = mu / n, but rather just mu;  Also, SS.XX2 looks wrong...
        %SS.XX2 = sum(expProd,3)/n; SS.n = n; SS.xbar = mu; % Actually, it looks like SS.xbar actually needs to be sum(expVals,2) / n;
        SS.XX2 = sum(expProd,3)/n; SS.n = n; SS.xbar = sum(expVals,2)/n;
        %currentLL = logprobSS(MvnDist(mu,Sigma), SS);
        currentLL = sum(logPdf(MvnDist(mu, Sigma), DataTable(expVals')));
        
        if ~isa(prior, 'NoPrior')
            currentLL = currentLL + logprob(prior, mu, Sigma);
        end
        loglikTrace(iter) = currentLL; %#ok
        if (currentLL < prevLL)
            warning('fitMvnEcm:loglik:nonincrease','warning: EM did not increase objective.  Exiting with last reasonable parameters \n')
            mu = muOld;
            Sigma = SigmaOld;
        end
        if verbose, fprintf('%d: LL = %5.3f\n', iter, currentLL); end
        iter = iter + 1;
        converged = iter >=maxIter || (abs(currentLL - prevLL) / (abs(currentLL) + abs(prevLL) + eps)/2) < opttol;
    end
    success = true;
end




function priorDist = mkPrior(varargin)
    [data, suff, prior, covtype] = processArgs(varargin, '-data', [], '-suffStat', [], '-prior', NoPrior, '-covtype', 'full');
    %if(isempty(data) && isempty(suff)), return; end;
    % If the user provides sufficient stats, then use these to make the prior
    if(~isempty(suff))
        XX = suff.XX;
        xbar = suff.xbar;
    else
        XX = nancov(data) + 0.1*mean(diag(nancov(data)));
        xbar = nanmean(data);
    end
    d = numel(xbar);
    if(isa(prior, 'char') || isa(prior, 'double'))
        
     table = { 'none'  ,  NoPrior(); ...
                'niw'   , MvnInvWishartDist(); ...
                'nig'   , MvnInvGammaDist()};
      table = cell(table);
      loc = find(strcmpi(prior, table(:,1)));
      prior = table{loc,2}; 
        
        
        
    end
    kappa0 = 0.01; m0 = xbar;
    switch class(prior)
        
        case {'NoPrior', 'double'}
            priorDist = NoPrior();
        case 'MvnInvWishartDist'
            nu0 = d + 1; T0 = diag(diag(XX)) + 0.01*eye(d);
            priorDist = MvnInvWishartDist('mu', m0, 'Sigma', T0, 'dof', nu0, 'k', kappa0);
        case 'MvnInvGammaDist'
            switch lower(covtype)
                case 'diagonal'
                    nu0 = 2*ones(1,d); b0 = rowvec(diag(XX)) + 0.01*ones(1,d);
                    priorDist = MvnInvGammaDist('mu', m0, 'Sigma', kappa0, 'a', nu0, 'b', b0);
                case 'spherical'
                    nu0 = 2; b0 = mean(diag(XX)) + 0.01;
                    priorDist = MvnInvGammaDist('mu', m0, 'Sigma', kappa0, 'a', nu0, 'b', b0);
                otherwise
                    error('MvnMissingEcmFitEng:mkPrior:invalidCombo','Error, invalid combination of prior and covtype');
            end
    end
end





