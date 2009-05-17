classdef MixMvnVb < MixMvn & BayesModel
%MIXMVNVB


	properties

		paramDist;

	end


	methods

		function model = MixMvnVb(varargin)
		%
		end


		function inferParams(model,varargin)
		%
			notYetImplemented('MixMvnVb.inferParams()');
		end


		function logmarglik(model,varargin)
		%
			notYetImplemented('MixMvnVb.logmarglik()');
		end


	end


end

