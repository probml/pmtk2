classdef LogRegFitEng < CondModelFitEng
    
    properties
        diagnostics;
        optMethod;
    end
   
    methods
       
        function model = fit(eng,model,D)
            
            X = D.X; y = D.Y;
            [X, model.transformer] = trainAndApply(model.transformer, X);
            n = size(X,1);
            if model.addOffset,  X = [ones(n,1) X];  end
            d = size(X,2);
            U = unique(y);
            if isempty(model.labelSpace), model.labelSpace = U; end
            if isempty(model.nclasses), model.nclasses = length(model.labelSpace); end
            C = model.nclasses;
            Y1 = oneOfK(y, C);
            winit = zeros(d*(C-1),1);
            [W,model.dof] = fitCore(eng, model, X, Y1,  winit);
            if model.addOffset
                model.params.w0 = W(1,:);
                model.params.w = W(2:end,:);
            else
                model.params.w = W;
                model.params.w0 = 0;
            end
        end
    end
    
    methods(Access = 'protected', Abstract = true)
       fitCore; 
    end
    
    
    
    
    
    
    
    
    
end