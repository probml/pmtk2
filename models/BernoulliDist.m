classdef BernoulliDist < DiscreteDist
	methods
		function model = BernoulliDist(varargin)
            model = model@DiscreteDist(varargin{:});
        end
    end 
    methods(Access = 'protected')
        function model = initialize(model)
           if isvector(model.params.T), model.params.T = colvec(model.params.T); end
           model.dof = 1;
           if isempty(model.support)
               model.support = [0,1];
           end
        end
    end
end