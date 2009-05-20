classdef LogReg < CondModel
%LOGREG


	properties

		dof;
		ndimensions;
		params;
		prior;

	end


	methods

		function model = LogReg(varargin)
		%
		end


		function computeMapOutput(model,varargin)
		%
			notYetImplemented('LogReg.computeMapOutput()');
		end


		function fit(model,varargin)
		%
			notYetImplemented('LogReg.fit()');
		end


		function inferOutput(model,varargin)
		%
			notYetImplemented('LogReg.inferOutput()');
		end


		function logPdf(model,varargin)
		%
			notYetImplemented('LogReg.logpdf()');
		end


		function sample(model,varargin)
		%
			notYetImplemented('LogReg.sample()');
		end


	end


end

