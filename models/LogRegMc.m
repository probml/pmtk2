classdef LogRegMc < LogReg & BayesModel
%LOGREGMC


	properties

		paramDist;

	end


	methods

		function model = LogRegMc(varargin)
		%
		end


		function getParamPost(model,varargin)
		%
			notYetImplemented('LogRegMc.inferParams()');
		end


		function logMargLik(model,varargin)
		%
			notYetImplemented('LogRegMc.logmarglik()');
		end


	end


end

