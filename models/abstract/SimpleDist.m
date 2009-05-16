classdef SimpleDist < ParamModel
   
  
    
    methods(Abstract = true)
        mean;        
        mode;
        var;
        entropy;
        plotPdf;
    end
    
end

