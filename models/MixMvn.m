classdef MixMvn < MixtureModel
	methods
		function model = MixMvn(varargin)
		    [nmixtures , ndimensions, template , model.mixingDist , model.fitEng] = processArgs(varargin,...
                '-nmixtures'   , 2                 ,...
                '-ndimensions' , 2                 ,...
                '-template'   , []                 ,...
                '-mixingDist' , []                 ,...
                '-fitEng'     , MixMvnEmFitEng()   );
            if isempty(template),template = MvnDist(zeros(1,ndimensions),eye(ndimensions)); end
            model.mixtureComps = copy(template,nmixtures);
            if isempty(model.mixingDist),model.mixingDist = DiscreteDist(normalize(rand(nmixtures,1))); end
            model = initialize(model);
        end
    end
    methods(Access = 'protected')
        function model = initialize(model) % not the same as initEm
            
                model.dof = model.mixingDist.dof - 1 + numel(model.mixtureComps)*model.mixtureComps{1}.dof; 
                model.ndimsLatent = model.mixingDist.ndimensions;
                model.ndimensions = model.mixtureComps{1}.ndimensions;
                model.prior.mixingPrior   = model.mixingDist.prior;
                model.prior.compPrior     = model.mixtureComps{1}.prior;
                model.params.mixingParams = model.mixingDist.params;
                model.params.compParams   = model.mixtureComps{1}.params;
            
            model.params = struct;
        end
    end
end