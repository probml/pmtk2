classdef ParamFreeDist < ProbModel
   
    methods(Abstract)
       plotPdf;
       mean;
       var;
       cov;
    end
    
    
end