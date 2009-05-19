classdef ProbCart < CondModel
%PROBCART


	properties

		dof;
		ndimensions;
		params;
		prior;

	end


	methods

		function model = ProbCart(varargin)
		%
		end


		function computeMapOutput(model,varargin)
		%
			notYetImplemented('ProbCart.computeMapOutput()');
		end


		function fit(model,varargin)
		%
			notYetImplemented('ProbCart.fit()');
		end


		function inferOutput(model,varargin)
		%
			notYetImplemented('ProbCart.inferOutput()');
		end


		function logpdf(model,varargin)
		%
			notYetImplemented('ProbCart.logpdf()');
		end


		function sample(model,varargin)
		%
			notYetImplemented('ProbCart.sample()');
		end


	end


end

