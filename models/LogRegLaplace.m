classdef LogRegLaplace < LogReg & BayesModel
    % Binary Logistic Regression with a laplace approx to the posterior
    
    properties
        
        paramDist;
        infEng;
        
    end
    
    
    methods
        
        function model = LogRegLaplace(varargin)
            model.nclasses = 2;
            [model.paramDist,model.lambda,model.transformer,model.fitEng,model.addOffset,model.labelSpace] = processArgs('-wDist',[],'-lambda',0,'-transformer',NoOpTransformer(),'-fitEng',LogRegL2FitEng(),'-addOffset',false,'-labelSpace',[1,2]);
        end
        
        function model = fit(model,varargin)
            D = processArgs(varargin,'+*-data',DataTableXY());
            mtmp = fit@LogReg(model,D);
            wMAP = [mtmp.params.w0;colvec(mtmp.params.w)];
            X = D.X; y = D.Y;
            [X, model.transformer] = trainAndApply(model.transformer, X);
            n = ncases(D);
            X = [ones(n,1) X];
            y12 = canonizeLabels(y); %1,2
            y01 = y12-1;
            [nll,g,H] = logregNLLgradHess(wMAP, X, y01, model.lambda, true);
            C = inv(H);  %H = hessian of neg log lik
            model.paramDist = MvnDist(wMAP, C);
        end
        
        function [yHat,pY] = inferOutput(model,D,varargin)
            [method,nsamples] = processArgs('-method','mc','-nsamples',100);
            n = ncases(D);
            X = [ones(n,1) apply(model.transformer, D.X)];
            switch lower(method)
                case 'sigmoidtimesgauss'
                    p = sigmoidTimesGauss(X, model.paramDist.mu(:), model.paramDist.Sigma);
                    pY = DiscreteDist(p');
                case 'mc'
                    wsamples = sample(model.paramDist,nsamples);
                    psamples = zeros(n,ns);
                    for s=1:ns
                        psamples(:,s) = sigmoid(X*wsamples(s,:)');
                    end
                    pY = SampleBasedDist(psamples');
                    p = mean(pred);
            end
            yHat = ones(n,1);
            ndx2 = (p > 0.5);
            yHat(ndx2) = 2;
            yHat = model.labelSpace(yHat);
        end
        
        function P = getParamPost(model)
            P = model.paramDist;
        end
        
    end
    
    
end



function [f,g,H] = logregNLLgradHess(beta, X, y, lambda, offsetAdded)
    % gradient and hessian of negative log likelihood for logistic regression
    % beta should be column vector
    % Rows of X contain data
    % y(i) = 0 or 1
    % lambda is optional strength of L2 regularizer
    % set offsetAdded if 1st column of X is all 1s
    if nargin < 4,lambda = 0; end
    check01(y);
    mu = 1 ./ (1 + exp(-X*beta)); % mu(i) = prob(y(i)=1|X(i,:))
    if offsetAdded, beta(1) = 0; end % don't penalize first element
    f = -sum( (y.*log(mu+eps) + (1-y).*log(1-mu+eps))) + lambda/2*sum(beta.^2);
    %f = f./nexamples;
    g = []; H  = [];
    if nargout > 1
        g = X'*(mu-y) + lambda*beta;
        %g = g./nexamples;
    end
    if nargout > 2
        W = diag(mu .* (1-mu)); %  weight matrix
        H = X'*W*X + lambda*eye(length(beta));
        %H = H./nexamples;
    end
end




function p = sigmoidTimesGauss(X, wMAP, C)
    % Bishop'06 p219
    mu = X*wMAP;
    n = size(X,1);
    if n < 1000
        sigma2 = diag(X * C * X');
    else
        % to save memory, use non-vectorized version
        sigma2 = zeros(1,n);
        for i=1:n
            sigma2(i) = X(i,:)*C*X(i,:)';
        end
    end
    kappa = 1./sqrt(1 + pi.*sigma2./8);
    p = sigmoid(kappa .* reshape(mu,size(kappa)));
end
















