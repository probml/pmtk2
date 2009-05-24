classdef Transformer
  
    
    properties
    end
    
    methods(Abstract = true)
        
        trainAndApply();
        apply();
        
        
    end
    
    methods
        
        function p = addOffset(T)
            p = false; % subclasses which add an offset term, e.g. a column of ones,
            % must subclass this method and return true;
        end
        
    end
    
end

