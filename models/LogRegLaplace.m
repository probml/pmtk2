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


		
	end


end

