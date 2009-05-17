classdef LogRegLaplace < LogReg & BayesModel
%LOGREGLAPLACE


	properties

		paramDist;

	end


	methods

		function model = LogRegLaplace(varargin)
		%
		end


		function inferParams(model,varargin)
		%
			notYetImplemented('LogRegLaplace.inferParams()');
		end


		function logmarglik(model,varargin)
		%
			notYetImplemented('LogRegLaplace.logmarglik()');
		end


	end


end

