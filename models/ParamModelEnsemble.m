classdef ParamModelEnsemble < ParamModel & ModelEnsemble



	properties

		dof;
		ndimensions;
		params;
		prior;

	end


	methods

		function model = ParamModelEnsemble(varargin)
		%
		end


		function fit(model,varargin)
		%
			notYetImplemented('ParamModelEnsemble.fit()');
		end


		function logPdf(model,varargin)
		%
			notYetImplemented('ParamModelEnsemble.logPdf()');
		end


		function sample(model,varargin)
		%
			notYetImplemented('ParamModelEnsemble.sample()');
		end


	end


end

