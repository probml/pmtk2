classdef FwdBackInfEng < InfEng
  
    methods(Abstract = true)
        
        setStartDist;
        setTransMat;
        setLocalEvidence(); 
        
    end
    
    
end

