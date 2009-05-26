classdef LinRegL2FitEng < LinRegFitEng
    
    
    
    properties
        
        diagnostics;
        verbose = true;
    end
    
    
    methods(Access = 'protected')
        
        function [w,dof] = fitCore(eng,model,XC,yC) 
            d = size(XC,2);
            XX  = [XC; sqrt(model.lambda)*eye(d)];
            yy = [yC; zeros(d,1)];
            w  = XX \ yy; % QR
            dof = dofRidge(eng,XC,model.lambda);
        end
    end
end












