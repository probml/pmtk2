classdef InputCpd < CondProbDist
%INPUTCPD


	properties

		dof;
		ndimensions;
		params;
		prior;

	end


	methods

		function model = InputCpd(varargin)
		%
		end


		function computeMapOutput(model,varargin)
		%
			notYetImplemented('InputCpd.computeMapOutput()');
		end


		function fit(model,varargin)
		%
			notYetImplemented('InputCpd.fit()');
		end


		function inferOutput(model,varargin)
		%
			notYetImplemented('InputCpd.inferOutput()');
		end


		function logpdf(model,varargin)
		%
			notYetImplemented('InputCpd.logpdf()');
		end


		function sample(model,varargin)
		%
			notYetImplemented('InputCpd.sample()');
		end


	end


end

