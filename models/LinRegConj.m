classdef LinRegConj < LinReg & BayesModel
%LINREGCONJ


	properties

		paramDist;

	end


	methods

		function model = LinRegConj(varargin)
		%
		end


		function getParamPost(model,varargin)
		%
			notYetImplemented('LinRegConj.inferParams()');
		end


	end


end

