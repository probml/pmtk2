classdef DgmTabularConj < DgmTabular & BayesModel
%DGMTABULARCONJ


	properties

		paramDist;

	end


	methods

		function model = DgmTabularConj(varargin)
		%
		end


		function inferParams(model,varargin)
		%
			notYetImplemented('DgmTabularConj.inferParams()');
		end


		function logmarglik(model,varargin)
		%
			notYetImplemented('DgmTabularConj.logmarglik()');
		end


	end


end

