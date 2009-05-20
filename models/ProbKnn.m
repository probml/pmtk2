classdef ProbKnn < CondModel & NonFiniteParamModel
%PROBKNN


	properties

		dof;
		ndimensions;
		params;
		prior;

	end


	methods

		function model = ProbKnn(varargin)
		%
		end


		function computeMapOutput(model,varargin)
		%
			notYetImplemented('ProbKnn.computeMapOutput()');
		end


		function fit(model,varargin)
		%
			notYetImplemented('ProbKnn.fit()');
		end


		function inferOutput(model,varargin)
		%
			notYetImplemented('ProbKnn.inferOutput()');
		end


		function logPdf(model,varargin)
		%
			notYetImplemented('ProbKnn.logpdf()');
		end


		function sample(model,varargin)
		%
			notYetImplemented('ProbKnn.sample()');
		end


	end


end

