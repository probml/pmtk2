classdef LogRegMc < LogReg & BayesModel
%LOGREGMC


	properties

		paramDist;

	end


	methods

		function model = LogRegMc(varargin)
		%
		end


		function inferParams(model,varargin)
		%
			notYetImplemented('LogRegMc.inferParams()');
		end


		function logmarglik(model,varargin)
		%
			notYetImplemented('LogRegMc.logmarglik()');
		end


	end


end

