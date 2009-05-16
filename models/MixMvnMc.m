classdef MixMvnMc < MixMvn & BayesModel
%MIXMVNMC


	properties

		paramDist;

	end


	methods

		function model = MixMvnMc(varargin)
		%
		end


		function inferParams(model,varargin)
		%
			notYetImplemented('MixMvnMc.inferParams()');
		end


		function logmarglik(model,varargin)
		%
			notYetImplemented('MixMvnMc.logmarglik()');
		end


	end


end

