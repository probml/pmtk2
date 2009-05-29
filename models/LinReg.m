classdef LinReg < CondModel
    
    properties
        
        dof;
        ndimensions = 1;
        params;
        prior;
        transformer;
        lambda;
        fitEng;
        addOffset;
        modelSelEng;
        
    end
    
    
    methods
        
        function model = LinReg(varargin)
            [model.params.w0,...
                model.params.w,...
                model.params.sigma2,...
                model.prior,...
                model.lambda,...
                model.fitEng,...
                model.addOffset,...
                model.transformer] = processArgs(varargin,...
                '-w0',[],...
                '-w' ,[],...
                '-sigma2',[],...
                '-prior',NoPrior(),...
                '-lambda',0,...
                '-fitEng',LinRegL2FitEng,...
                '-addOffset',true,...
                '-transformer',NoOpTransformer());
            
        end
        
        function model = fit(model,varargin)
            D = processArgs(varargin,'+*-data',DataTableXY());
            model = fit(model.fitEng,model,D);
        end
        
        
        function [yHat,pY] =  inferOutput(model,D)
            %  X(i,:) is i'th input
            % yhat(i) = E[y | X(i,:)]
            % py(i) = p(y|X(i,:)), a GaussDist
            
            X = apply(model.transformer, D.X);
            
            n = ncases(D);
            if model.addOffset
                X = [ones(n,1) X];
                ww = [model.params.w0; model.params.w];
            else
                ww = model.params.w;
            end
            yHat = X*ww;
            if nargout >= 2
                sigma2Hat = model.params.sigma2*ones(n,1); % constant variance!
                pY = GaussDist(yHat, sigma2Hat);
            end
            
            
            
        end
        
        
        function p = logPdf(model,D)
            % D is DataTable containing X(i,:) and y(i)
            % p(i) = log p(y(i) | X(i,:), model params)
            X = D.X; y = D.y;
            yhat = inferOutput(model, DataTable(X));
            s2 = model.params.sigma2;
            p = -1/(2*s2)*(y(:)-yhat(:)).^2 - 0.5*log(2*pi*s2);
            
        end
        
        
        function sample(model,varargin)
            %
            notYetImplemented('LinReg.sample()');
        end
        
        
    end
    
    
end

