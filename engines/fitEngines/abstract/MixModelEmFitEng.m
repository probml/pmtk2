classdef MixModelEmFitEng < EmFitEng
    
    methods(Access = 'protected')
        
        
        function ess = eStep(eng,model,data)
            notYetImplemented('MixModelEmFitEng.eStep');
        end
        
        function  [model,success] = mStep(eng,model,ess)
            notYetImplemented('MixModelEmFitEng.mStep');
        end
        
    end
 
end

