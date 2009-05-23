classdef MixMvnEmFitEng < MixModelEmFitEng

    
	methods

		function eng = MixMvnEmFitEng(varargin)
            eng.verbose = processArgs(varargin,'-verbose',true);
        end
    end
    
    methods(Access = 'protected')
        
%         function model = initEm(eng,model,data)
%             
%             % should do kmeans here
%         end
        
    end


end

