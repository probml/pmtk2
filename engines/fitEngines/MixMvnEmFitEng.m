classdef MixMvnEmFitEng < MixModelEmFitEng
    
    methods
        function eng = MixMvnEmFitEng(varargin)
           eng = eng@MixModelEmFitEng(varargin{:}); 
        end
    end
    
    methods(Access = 'protected')
         function model = initEm(eng,model,data)
            nmixtures = numel(model.mixtureComps);
            C = trainAndApply(KmeansTransformer(nmixtures),data);
            model.mixingDist = fit(model.mixingDist,DataTable(C));
            for i=1:nmixtures
               compData = data(C==i,:);
               SS.n    = size(compData,1);
               SS.xbar = mean(compData,1);
               XX   = cov(compData) + 0.01*eye(length(SS.xbar));
               if ~isposdef(XX)
                   XX = randpd(nmixtures);
               end
               SS.XX = XX;
               model.mixtureComps{i} = fit(model.mixtureComps{i},'-suffStat',SS);
            end
         end
    end
end

