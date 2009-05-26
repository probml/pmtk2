classdef LogRegMc < LogReg & BayesModel
    
    
    properties
        
        paramDist;
        
    end
    
    
    methods
        
        function model = LogRegMc(varargin)
            % LogregBinaryMc(transformer, fitEng, addOffset)
            [m.lambda, m.transformer, m.fitEng,  m.addOffset] = ...
                processArgs( varargin ,...
                '-lambda', [], ...
                '-transformer', NoOpTransformer(), ...
                '-fitEng', LogRegMhFitEng(),...
                '-addOffset', true);
        end
        
        
        function [yHat,pY] = inferOutput(model,D)
            % yhat(i) = most probable label for X(i,:)
            % pred(i,s) = p(y|X(i,:), beta(s)) a SampleDist
            
            X = apply(model.transformer, D.X);
            if model.addOffset
                n = size(X,1);
                X = [ones(n,1) X];
            end
            wsamples = model.paramDist.wsamples; % wsamples(j,s), j=1 for w0
            psamples = sigmoid(X*wsamples);
            pY = SampleDist(psamples, model.paramDist.weights);
            p = mean(pred);
            yHat = zeros(n,1);
            ndx2 = (p > 0.5);
            yHat(ndx2) = 1;
            %yhat = convertLabelsToUserFormat(D, yhat, '01'); Why do we need to do
            %this in this case?  It is already '01'
        end
        
        function P = getParamPost(model)
            P = model.paramDist;
        end
        
        function p = logPdf(model,varargin)
            [D,method] = processArgs(varargin,'-data',D,'-method',1);
            % p(i) = log sum_s p(y(i) | D.X(i,:), beta(s)) w(s)
            % where w(s) is weight for sample s
            
            X = D.X; y = canonizeLables(X)-1;
            n = size(X,1);
            [yhat, pred] = inferOutput(model,D); % pred is n*S
            p1 = pred.samples;
            p0 = 1-p1;
            nS = size(p1,2);
            W = repmat(pred.weights, n, 1);
            mask1 = repmat((y==1), 1, nS);
            mask0 = repmat((y==0), 1, nS);
            pp = (mask1 .* p1 + mask0 .* p0) .* W;
            p1 = log(sum(pp,2));
            
            %plug in posterior mean
            mu1 = mean(pred);
            Y = oneOfK(y, 2);
            P = [1-mu1(:) mu1(:)];
            p2 =  sum(Y.*log(P), 2);
            
            if method==1
                p = p1;
            else
                p = p2;
            end
            
        end
        
        
        
        
    end
    
    
end

