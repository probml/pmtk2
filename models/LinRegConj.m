classdef LinRegConj < LinReg & BayesModel
%LINREGCONJ


	properties

		paramDist;

	end


	methods

		function model = LinRegConj(varargin)
		%
		end


		function inferParams(model,varargin)
		%
			notYetImplemented('LinRegConj.inferParams()');
		end


		function logmarglik(model,varargin)
		%
			notYetImplemented('LinRegConj.logmarglik()');
		end


	end


end

