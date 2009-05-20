classdef TabularCpd < CondProbDist
%TABULARCPD


	properties

		dof;
		ndimensions;
		params;
		prior;

	end


	methods

		function model = TabularCpd(varargin)
		%
		end


		function computeMapOutput(model,varargin)
		%
			notYetImplemented('TabularCpd.computeMapOutput()');
		end


		function fit(model,varargin)
		%
			notYetImplemented('TabularCpd.fit()');
		end


		function inferOutput(model,varargin)
		%
			notYetImplemented('TabularCpd.inferOutput()');
		end


		function logPdf(model,varargin)
		%
			notYetImplemented('TabularCpd.logpdf()');
		end


		function sample(model,varargin)
		%
			notYetImplemented('TabularCpd.sample()');
		end


	end


end

