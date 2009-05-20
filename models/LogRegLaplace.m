classdef LogRegLaplace < LogReg & BayesModel
%LOGREGLAPLACE


	properties

		paramDist;

	end


	methods

		function model = LogRegLaplace(varargin)
		%
		end


		function getParamPost(model,varargin)
		%
			notYetImplemented('LogRegLaplace.inferParams()');
		end


		function logMargLik(model,varargin)
		%
			notYetImplemented('LogRegLaplace.logmarglik()');
		end


	end


end

