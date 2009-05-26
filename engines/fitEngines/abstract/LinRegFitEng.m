classdef LinRegFitEng < CondModelFitEng
    
    
    
    methods
        
        
        function model = fit(eng,model,D)
            [X, model.transformer] = trainAndApply(model.transformer, D.X);
            y = D.y;
            d = size(X,2);
            n = length(y);
            if d==0 % no inputs
                w0 = mean(y);
                w = [];
            else
                [XC, xbar] = center(X);
                [yC, ybar] = center(y);
                w = fitCore(eng,model, XC, yC);
                w0 = ybar - xbar*w;
            end
            model.params.w = w; model.params.w0 = w0;
            if model.addOffset
                ww = [w0; w(:)];
                X = [ones(n,1) X];
            else
                ww = w(:);
            end
            yhat = X*ww;
            model.params.sigma2 = mean((yhat-y).^2);
        end
    end
    
    
    
    methods(Access = 'protected',Abstract = true)
        
        fitCore;
        
        
    end
    
    
    methods(Access = 'protected')
        
        function df = dofRidge(eng,X, lambdas)
            % Compute the degrees of freedom for a given lambda value
            % Elements1e p63
            [n,d] = size(X);
            if d==0, df = 0; return; end
            XC  = center(X);
            D22 = eig(XC'*XC); % evals of X'X = svals^2 of X
            D22 = sort(D22, 'descend');
            D22 = D22(1:min(n,d));
            %[U,D,V] = svd(XC,'econ');                                           %#ok
            %D2 = diag(D.^2);
            %assert(approxeq(D2,D22))
            D2 = D22;
            nlambdas = length(lambdas);
            df = zeros(nlambdas,1);
            for i=1:nlambdas
                df(i) = sum(D2./(D2+lambdas(i)));
            end
        end
        
    end
    
    
    
    
    
    
    
    
    
    
end