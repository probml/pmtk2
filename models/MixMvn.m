classdef MixMvn < MixtureModel
	methods
		function model = MixMvn(varargin)
		    [nmixtures , template , model.mixingDist , model.fitEng] = processArgs(varargin,...
                '-nmixtures'  , 2                  ,...
                '-template'   , MvnDist()          ,...
                '-mixingDist' , DiscreteDist()     ,...
                '-fitEng'     , MixMvnEmFitEng()   );
            model.mixtureComps = copy(template,nmixtures);
            initialize(model);
        end
    end
    methods(Access = 'protected')
        function model = initialize(model) % not the same as initEm
            if ~isempty(model.mixtureComps) && ~ isempty(model.mixingDist); 
                model.dof = model.mixingDist.dof - 1 + numel(model.mixtureComps)*model.mixtureComps{1}.dof; 
                model.ndimsLatent = model.mixingDist.ndimensions;
                model.ndimensions = model.mixtureComps{1}.ndimensions;
                model.prior.mixingPrior   = model.mixingDist.prior;
                model.prior.compPrior     = model.mixtureComps{1}.prior;
                model.params.mixingParams = model.mixingDist.params;
                model.params.compParams   = model.mixtureComps{1}.params;
            end
            model.params = struct;
        end
    end
end