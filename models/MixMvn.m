classdef MixMvn < MixtureModel
  % Mixture of Multivariate Normal Distributions
  methods
    function model = MixMvn(varargin)
      % sets defaults specific to the model
      args = processArgs(varargin                         ,...
        '-nmixtures'    , 2                             ,...
        '-ndimensions'  , []                            ,...
        '-template'     , []                            ,...
        '-mixingDist'   , []                            ,...
        '-mixtureComps' , {}                            ,...
        '-fitEng'       , MixMvnEmFitEng() );
      
      [ndimensions,template,remaining] = extractArgs(2:3,args);
      if isempty(template) && ~isempty(ndimensions)
        template = MvnDist('-ndimensions',ndimensions);
      end
      if ~isempty(template)
        remaining = addArgs(remaining,'-template',template);
      else
        remaining = addArgs(remaining,'-template',MvnDist('-ndimensions',2));
      end
      model = model@MixtureModel(remaining{:});
    end
  end
end