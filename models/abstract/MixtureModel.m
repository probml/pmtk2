classdef MixtureModel < LatentVarModel

    
    properties(Abstract = true)
       fitEng;
       distributions;
    end
    
    
    methods
       
        function model = fit(model,varargin)
           model = fit(model.fitEng,model,varargin{:}); 
        end
        
        function l = logPrior(model)
            
            
        end
       
        
    end
    
end

