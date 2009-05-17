classdef InfEng
 
    properties(Abstract = true)
       model; 
       diagnostics;
    end
    
    methods(Abstract = true)
        
        enterEvidence;
        computeMarginals;
        computeSamples;
        computeLogPdf;
        
        
    end
    
end

