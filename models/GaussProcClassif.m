classdef GaussProcClassif < CondModel & NonFiniteParamModel
%GAUSSPROCCLASSIF


	properties

		dof;
		ndimensions;
		params;
		prior;

	end


	methods

		function model = GaussProcClassif(varargin)
		%
		end


		function computeMapOutput(model,varargin)
		%
			notYetImplemented('GaussProcClassif.computeMapOutput()');
		end


		function fit(model,varargin)
		%
			notYetImplemented('GaussProcClassif.fit()');
		end


		function inferOutput(model,varargin)
		%
			notYetImplemented('GaussProcClassif.inferOutput()');
		end


		function logpdf(model,varargin)
		%
			notYetImplemented('GaussProcClassif.logpdf()');
		end


		function sample(model,varargin)
		%
			notYetImplemented('GaussProcClassif.sample()');
		end


	end


end

