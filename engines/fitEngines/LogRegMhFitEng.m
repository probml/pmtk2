classdef LogRegMhFitEng < FitEng
    % Metropolis Hastings using random walk proposal centered at MAP for
    % Binary logistic regression with spherical Gaussian prior
    
    
    
    properties
        nsamples;
        verbose;
    end
    
    
    %% Main methods
    methods
        
        function m = LogregBinaryMhFitEng(varargin)
            % LogregBinaryMhFitEng(nsamples, verbose, scheme)
            [m.nsamples, m.verbose] = ...
                processArgs( varargin ,...
                '-nsamples', 1000, ...
                '-verbose', false);
        end
        
        function [model,output] = fit(eng, model, D)
            % m = fit(eng, m, D) Compute posterior estimate
            % D is DataTable containing:
            % X(i,:) is i'th input; do *not* include a column of 1s
            % y(i) is i'th response
            
            [X, model.transformer] = trainAndApply(model.transformer, D.X);
            if addOffset(model.transformer), error('don''t add column of 1s'); end
            
            y01 = canonizeLables(D.y)-1;
            
            
            % First find mode
            tmp = LogRegL2('-lambda',model.lambda, '-transformer',model.transformer, ...
                '-addOffset', model.addOffset, '-verbose', false, '-fitEng', LogRegL2FitEng('-optMethod','newton'));
            tmp = fit(tmp, D);
            
            % Then find Hessian at mode
            if model.addOffset
                n = size(X,1);
                X = [ones(n,1) X];
                wMAP = [tmp.params.w0; tmp.params.w];
            else
                wMAP = tmp.params.w;
            end
            [nll2, g, H] = LogRegFitEng.logregNLLgradHess(wMAP, X, y01, 0, model.addOffset);
            C = inv(H); %H = hessian of *neg* log lik
            
            % Now construct random walk metropolis
            d = length(wMAP);
            priorMu = zeros(d,1)';
            priorCov = (1/model.lambda)*eye(d);
            if  model.addOffset
                priorCov(1,1) = 1e5; % flat prior for offset
            end
            targetFn = @(w) -LogRegFItEng.logregNLLgradHess(w(:), X, y01, 0, true) + ...
                log(mvnpdf(w(:)',priorMu,priorCov));
            proposalFn = @(w) mvnrnd(w(:)',C);
            %initFn = @() mvnrnd(wMAP', 0.1*C);
            xinit = wMAP;
            
            samples = metrop(targetFn, proposalFn, xinit, eng.nsamples);
            %samples = mhSample('symmetric', true, 'target', targetFn, 'xinit', xinit, ...
            %    'Nsamples', 1000, 'Nburnin', 100, 'proposal',  proposalFn);
            model.paramDist.wsamples = samples';
            model.paramDist.weights = normalize(ones(1, eng.nsamples)); % MH gives unweighted samples
            
            %figure;scatter(samples(:,1), samples(:,2))
            %hold on; plot(wMAP(1), wMAP(2), 'rx');
            output = [];
        end
        
        
    end % methods
    
    
end
