classdef MixMvnEmFitEng < MixModelEmFitEng

    properties(Access = 'protected')
       verbose; 
    end
    
	methods

		function eng = MixMvnEmFitEng(varargin)
            eng.verbose = processArgs(varargin,'-verbose',true);
        end
    end
    
    methods(Access = 'protected')
        
        function model = initEm(eng,model,data)
            
            
            
            
            
        end
        
    end


end

