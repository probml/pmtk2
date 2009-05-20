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


		function logMargLik(model,varargin)
		%
			notYetImplemented('LinRegConj.logmarglik()');
		end


	end


end

