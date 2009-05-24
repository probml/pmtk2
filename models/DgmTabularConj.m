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


		

	end


end

