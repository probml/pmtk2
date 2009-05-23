classdef MixDiscreteEmFitEng < MixModelEmFitEng
    methods
        function eng = MixDiscreteEmFitEng(varargin)
            eng = eng@MixModelEmFitEng(varargin{:});
        end
    end
    methods(Access = 'protected')
        function model = initEm(eng,model,data)
        % add a more intelligent initialization here.    
            model = initEm@MixModelEmFitEng(eng,model,data);
        end
    end
end

