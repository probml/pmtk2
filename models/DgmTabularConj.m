classdef DgmTabularConj < DgmTabular & BayesModel
%DGMTABULARCONJ


	properties

		paramDist;

	end


	methods

		function model = DgmTabularConj(varargin)
		%
		end


		function getParamPost(model,varargin)
		%
			notYetImplemented('DgmTabularConj.inferParams()');
		end


		function logMargLik(model,varargin)
		%
			notYetImplemented('DgmTabularConj.logmarglik()');
		end


	end


end

