classdef MhInfEng < McmcInfEng
   
    
    methods(Abstract = true)
        setTargetDist;
        setProposalDist;
    end
    
    
end

