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


		

	end


end

