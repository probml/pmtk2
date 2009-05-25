classdef GaussProcReg < CondModel & NonFiniteParamModel
%#NotYetImplemented


	properties

		dof;
		ndimensions;
		params;
		prior;

	end


	methods

		function model = GaussProcReg(varargin)
		%
		end


		function computeMapOutput(model,varargin)
		%
			notYetImplemented('GaussProcReg.computeMapOutput()');
		end


		function fit(model,varargin)
		%
			notYetImplemented('GaussProcReg.fit()');
		end


		function inferOutput(model,varargin)
		%
			notYetImplemented('GaussProcReg.inferOutput()');
		end


		function logPdf(model,varargin)
		%
			notYetImplemented('GaussProcReg.logpdf()');
		end


		function sample(model,varargin)
		%
			notYetImplemented('GaussProcReg.sample()');
		end


	end


end

