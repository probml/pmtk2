classdef InfEng
 
    properties(Abstract = true)
       diagnostics;
    end
    
    methods(Abstract = true)
        
        enterEvidence;
        computeMarginals;
        computeSamples;
        computeLogPdf;
        
        
    end
    
end

