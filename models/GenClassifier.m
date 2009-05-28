classdef GenClassifier < CondModel

	properties

		dof;
		ndimensions;
		params;
		prior;
        transformer;

	end


	methods

		function model = GenClassifier(varargin)
            [model.params.classConditionals,model.prior,template,nclasses,model.transformer] = processArgs(varargin,...
                '-classConditionals',{},'-classPrior',DiscreteDist(),...
                '-template',[],'-nclasses',[],'-transformer',NoOpTransformer());
            if ~isempty(template) && ~isempty(nclasses), model.params.classConditionals = copy(template,nclasses); end
            model = initialize(model);
		end


		function model = fit(model,varargin)
            D = processArgs(varargin,'+-data',DataTableXY());
            X = D.X; y = D.y;
            [X,model.transformer] = trainAndApply(model.transformer,X);
            model.prior = fit(model.prior, '-data',  colvec(y));
            classConds = model.params.classConditionals;
            support = model.prior.support;
            for c=1:numel(classConds)
              classConds{c} = fit(classConds{c},'-data',X(y==support(c),:));
            end
            model.params.classConditionals = classConds;
            model = initialize(model);
		end


        function [yHat,pY] = inferOutput(model,D)
            X = D.X;
            X = apply(model.transformer,X);
            logpy = log(pmf(model.prior));
            n = ncases(D);
            classConds = model.params.classConditionals;
            C = numel(classConds);
            L = zeros(n,C);
            for c=1:C
                L(:,c) = logPdf(classConds{c},X) + logpy(c);
            end;
            post = exp(normalizeLogspace(L));
            yHat = model.prior.support(maxidx(post,[],2))';
            if nargout > 2
                pY = DiscreteDist(post', '-support', model.prior.support);
            end
        end


		function logPdf(model,varargin)
		%
			notYetImplemented('GenClassifier.logpdf()');
		end


		function sample(model,varargin)
		%
			notYetImplemented('GenClassifier.sample()');
		end


    end
    
    methods(Access = 'protected')
        function model = initialize(model)
            dof= model.prior.dof;
            classConds = model.params.classConditionals;
            for i=1:numel(classConds)
                dof = dof + classConds{i}.dof;
            end
            model.dof = dof;
        end
        
    end


end

