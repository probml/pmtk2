classdef ParamModel < ProbModel
  
  properties(Abstract = true)
    params;
    prior;
    dof;
  end
  
  
  methods
    
    function S = mkSuffStat(model,D,weights)
      if nargin < 3, weights = ones(size(D,1)); end
      S = bsxfun(@times,D,colvec(weights));
    end
    
    function l = logPrior(model)
      l = 0;
    end
    
  end
  
  methods(Abstract = true)
    fit;
  end
end