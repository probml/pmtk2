classdef MhInfEng < McmcInfEng
   
    
    methods(Access = 'protected',Abstract = true)
        setTargetDist;
        setProposalDist;
    end
    
    
end

