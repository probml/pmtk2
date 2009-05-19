classdef NoisyOrCpd < CondProbDist
%NOISYORCPD


	properties

		dof;
		ndimensions;
		params;
		prior;

	end


	methods

		function model = NoisyOrCpd(varargin)
		%
		end


		function computeMapOutput(model,varargin)
		%
			notYetImplemented('NoisyOrCpd.computeMapOutput()');
		end


		function fit(model,varargin)
		%
			notYetImplemented('NoisyOrCpd.fit()');
		end


		function inferOutput(model,varargin)
		%
			notYetImplemented('NoisyOrCpd.inferOutput()');
		end


		function logpdf(model,varargin)
		%
			notYetImplemented('NoisyOrCpd.logpdf()');
		end


		function sample(model,varargin)
		%
			notYetImplemented('NoisyOrCpd.sample()');
		end


	end


end

