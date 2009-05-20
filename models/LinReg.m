classdef LinReg < CondModel
%LINREG


	properties

		dof;
		ndimensions;
		params;
		prior;

	end


	methods

		function model = LinReg(varargin)
		%
		end


		function computeMapOutput(model,varargin)
		%
			notYetImplemented('LinReg.computeMapOutput()');
		end


		function fit(model,varargin)
		%
			notYetImplemented('LinReg.fit()');
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

