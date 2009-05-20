classdef GenClassifier < CondModel
%GENCLASSIFIER


	properties

		dof;
		ndimensions;
		params;
		prior;

	end


	methods

		function model = GenClassifier(varargin)
		%
		end


		function computeMapOutput(model,varargin)
		%
			notYetImplemented('GenClassifier.computeMapOutput()');
		end


		function fit(model,varargin)
		%
			notYetImplemented('GenClassifier.fit()');
		end


		function inferOutput(model,varargin)
		%
			notYetImplemented('GenClassifier.inferOutput()');
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


end

