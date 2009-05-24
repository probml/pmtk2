classdef LogReg < CondModel

	properties
		dof;
		ndimensions = 1;
        nclasses;
        labelSpace;
		params;         % stores w,w0
		prior;
        lambda;
        fitEng;
        transformer;
        addOffset; 
	end


	methods

		function model = LogReg(varargin)
           [model.nclasses, model.prior, model.fitEng, model.transformer, model.addOffset, model.labelSpace,model.lambda, model.params.w, model.params.w0] = processArgs(varargin,...
               '-nclasses'    , 2                  ,...
               '-prior'       , 'L2'               ,...
               '-fitEng'      , []                 ,... 
               '-transformer' , NoOpTransformer()  ,...
               '-addOffset'   , false              ,...
               '-labelSpace'  , []                 ,...
               '-lambda'      , 0                  ,...
               '-w'           , []                 ,...
               '-w0'          , 0                 );    
               model = initialize(model);
		end

        function [yHat,T] = computeMapOutput(model,D)
            X = D.X;
            X = apply(model.transformer,X);
            if model.addOffset
                X = [ones(n,1) X];
                W = [model.params.w0; model.params.w];
            else
                W = model.params.w;
            end
            T = multiSigmoid(X,W(:));
            yHat = model.labelSpace(maxidx(T,[],2));
		end

		function model = fit(model,varargin)
            model = fit(model.fitEng,model,varargin{:}); % also sets dof
		end

		function [P,T] = inferOutput(model,D)
        % P(i) = p(y|X(i,:), w) a DiscreteDist
            X = D.X;
            X = apply(model.transformer,X);
            if model.addOffset
                X = [ones(n,1) X];
                W = [model.params.w0; model.params.w];
            else
                W = model.params.w;
            end
            T = multiSigmoid(X,W(:));
            P = cell(ncases(D),1);
            for i=1:ncases(D)
               P{i} = DiscreteDist(T(i,:)','-support',model.labelSpace); 
            end
		end

        function P = logPdf(model,D)
            y = D.Y;
            y = canonizeLabels(y, obj.labelSpace);
            [Pdist, T] = inferOutput(model,D);
            Y = oneOfK(y, model.nclasses);
            P =  sum(Y.*log(T), 2);
        end

		function S = sample(model,D,n)
            if nargin < 3, n = 1; end
			[Pdist,T] = inferOutput(model,D);
            S = zeros(ncases(D),n);
            for i=1:ncases(D)
                S(i,:) = rowvec(sampleDiscrete(T(i,:),1,n));
            end
        end
    end
    
    methods(Access = 'protected')
        
        function model = initialize(model)
            if isempty(model.labelSpace)
                model.labelSpace = 1:model.nclasses;
            end
            
            if isempty(model.fitEng)
                if ischar(model.prior)
                    switch lower(model.prior)
                        case 'l1'
                            model.fitEng = LogRegL1FitEng();
                        otherwise
                            model.fitEng = LogREgL2FitEng();
                    end
                end
            end
        end
    end
end

