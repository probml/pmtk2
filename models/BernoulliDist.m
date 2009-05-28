classdef BernoulliDist < DiscreteDist
	methods
		function model = BernoulliDist(varargin)
            model = model@DiscreteDist(varargin{:});
        end
        
        function L = logPdf(model,D)
        
        % Override to do more efficiently than DiscreteDist, since we can 
        % transform the data to [0,1] and use it like a mask against T
        % rather than indexing into T. 
        
          
            X = canonizeLabels(unwrap(D))-1; % make sure its in [0,1]
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