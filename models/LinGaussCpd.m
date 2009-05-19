classdef LinGaussCpd < CondProbDist
%LINGAUSSCPD


	properties

		dof;
		ndimensions;
		params;
		prior;

	end


	methods

		function model = LinGaussCpd(varargin)
		%
		end


		function computeMapOutput(model,varargin)
		%
			notYetImplemented('LinGaussCpd.computeMapOutput()');
		end


		function fit(model,varargin)
		%
			notYetImplemented('LinGaussCpd.fit()');
		end


		function inferOutput(model,varargin)
		%
			notYetImplemented('LinGaussCpd.inferOutput()');
		end


		function logpdf(model,varargin)
		%
			notYetImplemented('LinGaussCpd.logpdf()');
		end


		function sample(model,varargin)
		%
			notYetImplemented('LinGaussCpd.sample()');
		end


	end


end

