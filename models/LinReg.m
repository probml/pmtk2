classdef LinReg < CondModel

	properties

		dof;
		ndimensions = 1;
		params;
		prior;
        transformer;
        lambda;
        fitEng;
        addOffset;

	end


	methods

		function model = LinReg(varargin)
               [model.params.w0,...
                model.params.w,...
                model.params.sigma2,...
                model.prior,...
                model.lambda,...
                model.fitEng,...
                model.addOffset,...
                model.transformer] = processArgs(varargin,...
                '-w0',[],...
                '-w' ,[],...
                '-sigma2',[],...
                '-prior',NoPrior(),...
                '-lambda',0,...
                '-fitEng',[],...
                '-addOffset',true,...
                '-transformer',NoOpTransformer());
                
		end

		function model = fit(model,varargin)
            D = processArgs(varargin,'+*-data',DataTableXY());
			model = fit(model.fitEng,model,D);
		end


		function inferOutput(model,varargin)
		%
			notYetImplemented('LinReg.inferOutput()');
		end


		function logPdf(model,varargin)
		%
			notYetImplemented('LinReg.logpdf()');
		end


		function sample(model,varargin)
		%
			notYetImplemented('LinReg.sample()');
		end


	end


end

