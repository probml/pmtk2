classdef MixMvnEmFitEng < MixModelEmFitEng
    
    methods
        function eng = MixMvnEmFitEng(varargin)
           eng = eng@MixModelEmFitEng(varargin{:}); 
        end
    end
    
    methods(Access = 'protected')
         function model = initEm(eng,model,data)
            % should do kmeans here instead
            model = initEm@MixModelEmFitEng(eng,model,data);
         end
    end
end

