classdef LinGaussHybridCpd < CondProbDist
%LINGAUSSHYBRIDCPD


	properties

		dof;
		ndimensions;
		params;
		prior;

	end


	methods

		function model = LinGaussHybridCpd(varargin)
		%
		end


		function computeMapOutput(model,varargin)
		%
			notYetImplemented('LinGaussHybridCpd.computeMapOutput()');
		end


		function fit(model,varargin)
		%
			notYetImplemented('LinGaussHybridCpd.fit()');
		end


		function inferOutput(model,varargin)
		%
			notYetImplemented('LinGaussHybridCpd.inferOutput()');
		end


		function logpdf(model,varargin)
		%
			notYetImplemented('LinGaussHybridCpd.logpdf()');
		end


		function sample(model,varargin)
		%
			notYetImplemented('LinGaussHybridCpd.sample()');
		end


	end


end

