classdef BernoulliDist < DiscreteDist
	methods
		function model = BernoulliDist(varargin)
            model = model@DiscreteDist(varargin{:});
        end
        
        function L = logPdf(model,D)
        % override to do more efficiently
        
            X = canonizeLabels(D.X)-1; % make sure its in [0,1]
            L0 = bsxfun(@times,log(model.params.T(1,:)+eps),double(~X));
            L1 = bsxfun(@times,log(model.params.T(2,:)+eps),X);
            L = sum(L0+L1,2);
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