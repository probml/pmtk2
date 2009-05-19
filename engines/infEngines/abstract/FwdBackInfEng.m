classdef FwdBackInfEng < InfEng
  
    methods(Access = 'protected',Abstract = true)
        
        setStartDist;
        setTransMat;
        setLocalEvidence(); 
        
    end
    
    
end

